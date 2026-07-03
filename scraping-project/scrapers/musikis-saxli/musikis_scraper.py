import asyncio
import os
import re
import sys
import io
import pandas as pd
from datetime import datetime
from playwright.async_api import async_playwright

# Force UTF-8 output to handle Georgian text
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

# File paths (script-relative)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_FILE = os.path.join(BASE_DIR, "music-store-product-links.txt")
OUTPUT_FILE = os.path.join(BASE_DIR, "music_store_final_stock.xlsx")

# Parallel request limit to avoid blocking
SEMAPHORE_LIMIT = 15

# Semantic soft-404 marker: musikis-saxli.ge returns this Georgian
# "requested page was not found" message (sometimes with HTTP 200)
# when a product URL no longer exists (e.g. after link structure changes).
NOT_FOUND_MARKER = "მოთხოვნილი გვერდი არ იქნა ნაპოვნი"

def is_valid_product_page(html) -> bool:
    """Guard-rail against 'false-positive 200 OK' responses.

    Returns True if the document appears to be a real product page,
    False if it is empty or contains the Georgian 'page not found' marker.
    Pure content analysis — no network calls.
    """
    if isinstance(html, bytes):
        html = html.decode("utf-8", errors="replace")
    if not html or not html.strip():
        return False
    return NOT_FOUND_MARKER not in html

def extract_unique_id(url: str) -> str:
    """Fallback ID from URL slug (handles old '--SKU' and new '-SKU' structures)"""
    slug = url.rstrip('/').rsplit('/', 1)[-1]
    if '--' in slug:
        return slug.split('--')[-1]
    if '-' in slug:
        return slug.rsplit('-', 1)[-1]
    return "N/A"

async def extract_sku_from_page(page):
    """Extract the real SKU from the product page ('კოდი:' row in .rev_item).

    This is the primary ID source — the URL slug is only a fallback, since the
    site changed its link structure (name--SKU -> name-SKU) and URL parsing
    is no longer reliable.
    """
    try:
        sku = await page.evaluate("""() => {
            for (const item of document.querySelectorAll('.rev_item')) {
                const spans = item.querySelectorAll('span');
                if (spans.length >= 2 && spans[0].textContent.trim().startsWith('კოდი')) {
                    return spans[1].textContent.trim();
                }
            }
            return null;
        }""")
        return sku.strip() if sku and sku.strip() else None
    except Exception:
        return None

def dedup_products(df):
    """Deduplicate by UNIQUE_ID, but never collapse missing/placeholder IDs.

    Rows with 'N/A'/empty IDs are kept as individual entries instead of being
    merged into a single row by drop_duplicates.
    """
    ids = df['UNIQUE_ID'].astype(str).str.strip()
    valid = df['UNIQUE_ID'].notna() & ~ids.isin(['', 'N/A', 'nan', 'None'])
    deduped_valid = df[valid].drop_duplicates(subset=['UNIQUE_ID'], keep='last')
    return pd.concat([deduped_valid, df[~valid]], ignore_index=True)

async def scrape_single_product(semaphore, context, url, index, total):
    """Extract data from a single product"""
    async with semaphore:
        print(f"[{index}/{total}] Starting scrape for: {url}", flush=True)
        page = await context.new_page()
        product_id = extract_unique_id(url)
        
        print(f"[{index}/{total}] Product ID: {product_id}", flush=True)
        
        # Default values
        name = "Unknown"
        price = 0
        status = "Out of Stock"
        
        try:
            print(f"[{index}/{total}] Loading page...", flush=True)
            # Shorter timeout with wait_for_selector
            await page.goto(url, wait_until="domcontentloaded", timeout=30000)
            print(f"[{index}/{total}] Page loaded successfully", flush=True)
            
            # Guard-rail: skip soft-404 pages (site may return 200 OK with a
            # Georgian "page not found" message for stale/dead product links).
            # Skipped products never reach the Excel output, so dead links
            # cannot propagate to the merger, Google Sheet, or Telegram alerts.
            page_content = await page.content()
            if not is_valid_product_page(page_content):
                print(f"[{index}/{total}] SOFT-404 detected ('{NOT_FOUND_MARKER}') — skipping dead link: {url}", flush=True)
                await page.close()
                return None
            
            # Wait for main product container
            try:
                print(f"[{index}/{total}] Waiting for product elements...", flush=True)
                await page.wait_for_selector(".prod_id, h1, .prod_price", timeout=10000)
                print(f"[{index}/{total}] Product elements found", flush=True)
            except:
                print(f"[{index}/{total}] Warning: Product elements not found within timeout", flush=True)
                pass  # Continue even if wait times out
            
            await asyncio.sleep(0.3)

            # Primary ID source: real SKU from the page ('კოდი:' row).
            # Falls back to the URL-derived ID if the element is missing.
            page_sku = await extract_sku_from_page(page)
            if page_sku:
                product_id = page_sku
                print(f"[{index}/{total}] SKU from page: {product_id}", flush=True)
            else:
                print(f"[{index}/{total}] SKU element not found, using URL fallback: {product_id}", flush=True)

            # 1. Name - protected with try/except
            try:
                print(f"[{index}/{total}] Extracting product name...", flush=True)
                name_elem = page.locator("h1, .prod_id").first
                if name_elem:
                    name = (await name_elem.inner_text()).strip()
                    print(f"[{index}/{total}] Product name extracted: '{name}'", flush=True)
                else:
                    print(f"[{index}/{total}] No name element found", flush=True)
            except Exception as e:
                print(f"[{index}/{total}] Error extracting name: {str(e)[:50]}", flush=True)
                name = "Unknown"

            # 2. Price - protected with try/except
            try:
                print(f"[{index}/{total}] Extracting price...", flush=True)
                # Target the LAST span inside .prod_price (this is the main price)
                price_elem = page.locator('.prod_price > span').last
                price_raw = await price_elem.inner_text()
                print(f"[{index}/{total}] Raw price from LAST span: '{price_raw}'", flush=True)
                
                # Verify it contains 'gel' symbol (character code 8382) and does NOT contain installment words
                if (8382 in [ord(c) for c in price_raw]) and 'monthly' not in price_raw.lower() and 'monthly' not in price_raw.lower():
                    # Remove 'gel', commas and decimals, keep only digits
                    price_part = price_raw.split('.')[0]  # Remove decimal part
                    clean_price = "".join(filter(str.isdigit, price_part))
                    price = int(clean_price) if clean_price else 0
                    print(f"[{index}/{total}] Price extracted: {price}", flush=True)
                else:
                    print(f"[{index}/{total}] LAST span doesn't match criteria, trying fallback...", flush=True)
                    # Fallback to first span if last doesn't match criteria
                    try:
                        fallback_price = await page.locator('.prod_price > span').first.inner_text()
                        print(f"[{index}/{total}] Fallback price from FIRST span: '{fallback_price}'", flush=True)
                        if 8382 in [ord(c) for c in fallback_price]:
                            price_part = fallback_price.split('.')[0]
                            clean_price = "".join(filter(str.isdigit, price_part))
                            price = int(clean_price) if clean_price else 0
                            print(f"[{index}/{total}] Fallback price extracted: {price}", flush=True)
                        else:
                            print(f"[{index}/{total}] Fallback price doesn't contain 'gel' symbol", flush=True)
                            price = 0
                    except Exception as e:
                        print(f"[{index}/{total}] Error in fallback price extraction: {str(e)[:50]}", flush=True)
                        price = 0
            except Exception as e:
                print(f"[{index}/{total}] Error extracting price: {str(e)[:50]}", flush=True)
                price = 0

            # 3. Status - protected with try/except
            try:
                print(f"[{index}/{total}] Extracting stock status...", flush=True)
                status_elem = page.locator(".prod-status p").first
                if status_elem:
                    status_raw = await status_elem.inner_text()
                    print(f"[{index}/{total}] Raw status text: '{status_raw}'", flush=True)
                    if "მარაგშია" in status_raw:
                        status = "In Stock"
                        print(f"[{index}/{total}] Product is in stock", flush=True)
                    else:
                        print(f"[{index}/{total}] Stock status unclear", flush=True)
                elif price > 0:
                    # If price exists and status not visible, often means it's in stock
                    status = "In Stock"
                    print(f"[{index}/{total}] Assuming in stock (price exists but no status text)", flush=True)
                else:
                    print(f"[{index}/{total}] No price found, marking as out of stock", flush=True)
            except Exception as e:
                print(f"[{index}/{total}] Error extracting status: {str(e)[:50]}", flush=True)
                status = "Out of Stock"

            print(f"[{index}/{total}] {product_id} | {price}".encode('utf-8', errors='ignore').decode('utf-8'), flush=True)
            
            await page.close()
            return {
                'UNIQUE_ID': product_id,
                'NAME': name,
                'PRICE': price,
                'STATUS': status,
                'LINK': url,
                'DATE': datetime.now().strftime("%Y-%m-%d %H:%M")
            }

        except Exception as e:
            print(f"[{index}/{total}] Error on {product_id}: {str(e)[:30]}".encode('utf-8', errors='ignore').decode('utf-8'), flush=True)
            await page.close()
            # Return partial data instead of None
            return {
                'UNIQUE_ID': product_id,
                'NAME': name,
                'PRICE': price,
                'STATUS': status,
                'LINK': url,
                'DATE': datetime.now().strftime("%Y-%m-%d %H:%M")
            }

async def main():
    if not os.path.exists(INPUT_FILE):
        print(f"Error: {INPUT_FILE} not found!", flush=True)
        return False

    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        urls = [line.strip() for line in f if line.strip()]
    if not urls:
        print(f"Error: {INPUT_FILE} contains no product URLs!", flush=True)
        return False

    print(f"Starting Music-Store scrape for {len(urls)} products...", flush=True)

    # Always start with a clean slate — do NOT merge with previous run's data.
    # If a stale output file exists, remove it so this run fully owns the output.
    if os.path.exists(OUTPUT_FILE):
        try:
            os.remove(OUTPUT_FILE)
            print(f"[INFO] Removed stale {os.path.basename(OUTPUT_FILE)} before fresh scrape", flush=True)
        except Exception as e:
            print(f"[WARN] Could not remove existing output file: {e}", flush=True)

    semaphore = asyncio.Semaphore(SEMAPHORE_LIMIT)
    all_products = []
    processed_count = 0
    batch_size = 100
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True, args=['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'])
        context = await browser.new_context()

        # Process in batches of 100
        for batch_start in range(0, len(urls), batch_size):
            batch_end = min(batch_start + batch_size, len(urls))
            batch_urls = urls[batch_start:batch_end]
            
            print(f"[BATCH] Processing products {batch_start + 1}-{batch_end} (batch {batch_start // batch_size + 1} of {(len(urls) - 1) // batch_size + 1})", flush=True)
            
            # Create task list for this batch
            tasks = []
            for i, url in enumerate(batch_urls, batch_start + 1):
                tasks.append(scrape_single_product(semaphore, context, url, i, len(urls)))
            
            # Run batch in parallel
            try:
                batch_results = await asyncio.gather(*tasks)
                batch_products = [r for r in batch_results if r is not None]
                all_products.extend(batch_products)
                processed_count += len(batch_products)
                print(f"[BATCH] Completed batch {batch_start // batch_size + 1}: {len(batch_products)} products processed, {processed_count}/{len(urls)} total", flush=True)
            except Exception as e:
                print(f"[ERROR] Batch {batch_start // batch_size + 1} failed: {e}", flush=True)
                continue  # Continue to next batch
            
            # Save checkpoint every 100 products
            if processed_count >= 100:
                try:
                    # Checkpoint uses only this run's data — no merging with prior file
                    combined_df = dedup_products(pd.DataFrame(all_products))
                    combined_df['PRICE'] = combined_df['PRICE'].fillna(0).astype(int)
                    try:
                        combined_df.to_excel(OUTPUT_FILE, index=False, engine='openpyxl')
                        print(f"[CHECKPOINT] Saved {len(combined_df)} unique products to {os.path.basename(OUTPUT_FILE)}", flush=True)
                    except Exception as save_err:
                        print(f"[ERROR] Excel save failed: {save_err}", flush=True)
                except Exception as e:
                    print(f"[ERROR] Could not save checkpoint: {e}", flush=True)
        
        await browser.close()
    
    # Final save if any products were processed
    if all_products:
        try:
            # Final output contains ONLY this run's data — overwrite completely.
            final_df = dedup_products(pd.DataFrame(all_products))
            final_df['PRICE'] = final_df['PRICE'].fillna(0).astype(int)
            try:
                # Remove any existing file first to guarantee a clean overwrite
                if os.path.exists(OUTPUT_FILE):
                    try:
                        os.remove(OUTPUT_FILE)
                    except Exception:
                        pass
                final_df.to_excel(OUTPUT_FILE, index=False, engine='openpyxl')
                print(f"\n{'='*60}", flush=True)
                print(f"DONE! Total Unique Products: {len(final_df)}", flush=True)
                print(f"File saved: {OUTPUT_FILE}", flush=True)
                print(f"{'='*60}", flush=True)
                return True
            except Exception as final_err:
                print(f"[ERROR] Final Excel save failed: {final_err}", flush=True)
                return False
        except Exception as e:
            print(f"[ERROR] Could not save final file: {e}", flush=True)
            return False
    else:
        print("No products extracted.", flush=True)
        return False

if __name__ == "__main__":
    sys.exit(0 if asyncio.run(main()) else 1)