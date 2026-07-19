import asyncio
import os
import re
import hashlib
import random
import requests
import pandas as pd
from datetime import datetime
from bs4 import BeautifulSoup
from playwright.async_api import async_playwright

FLARESOLVERR_URL = os.getenv('FLARESOLVERR_URL', 'http://localhost:8191/v1')

def flaresolverr_available():
    """Check if FlareSolverr is running and reachable"""
    try:
        r = requests.get(FLARESOLVERR_URL.rsplit('/v1', 1)[0] + '/', timeout=5)
        return r.status_code == 200
    except Exception:
        return False

def fetch_via_flaresolverr(url, timeout_ms=60000):
    """Fetch a page through FlareSolverr to bypass Cloudflare. Returns HTML or None."""
    try:
        resp = requests.post(
            FLARESOLVERR_URL,
            json={'cmd': 'request.get', 'url': url, 'maxTimeout': timeout_ms},
            timeout=timeout_ms / 1000 + 30
        )
        data = resp.json()
        if data.get('status') == 'ok':
            return data['solution']['response']
        print(f"  FlareSolverr error: {data.get('message', 'unknown')}", flush=True)
        return None
    except Exception as e:
        print(f"  FlareSolverr request failed: {str(e)[:80]}", flush=True)
        return None

async def scrape_geovoice_full():
    """Direct product page scraper: read links from file, visit each product page for detailed extraction"""
    
    # Selectors for product pages
    PRODUCT_PAGE_SELECTORS = {
        'unique_id': 'span[id^="product_code_"]',
        'price_discounted': 'span[id^="sec_discounted_price_"]',
        'price_regular': 'span.ty-price-num',
        'stock': 'span.ty-qty-in-stock',
        'product_block': '.ty-product-block',
        'name': '.ty-product-block-title'
    }
    
    def extract_price_from_text(price_text):
        """Extract price from text, handling commas and currency symbols"""
        if not price_text:
            return 0.0
        
        # Remove currency symbols, spaces, and other non-numeric characters except comma and dot
        cleaned = re.sub(r'[^\d.,]', '', str(price_text))
        
        # Handle comma as decimal separator (European format: 1,299.00 -> 1299.00)
        # If there's a comma and a dot, assume comma is thousands separator
        if ',' in cleaned and '.' in cleaned:
            # 1,299.00 -> 1299.00
            cleaned = cleaned.replace(',', '')
        elif ',' in cleaned:
            # 1,299 or 1299,00 -> check if comma is decimal or thousands
            parts = cleaned.split(',')
            if len(parts) == 2 and len(parts[1]) <= 2:
                # 1299,00 -> 1299.00 (comma is decimal)
                cleaned = cleaned.replace(',', '.')
            else:
                # 1,299 -> 1299 (comma is thousands)
                cleaned = cleaned.replace(',', '')
        
        # Remove any remaining dots (thousands separators)
        cleaned = cleaned.replace('.', '')
        
        # Convert to float
        try:
            return float(cleaned)
        except:
            return 0.0
    
    def save_progress(products, output_file):
        """Save current progress to Excel"""
        if products:
            df = pd.DataFrame(products)
            df.drop_duplicates(subset=['UNIQUE_ID'], keep='first', inplace=True)
            df['PRICE'] = pd.to_numeric(df['PRICE'], errors='coerce')
            df.to_excel(output_file, index=False)
    
    # Read product links from geovoice_product_links.txt
    script_dir = os.path.dirname(os.path.abspath(__file__))
    try:
        with open(os.path.join(script_dir, "geovoice_product_links.txt"), "r", encoding="utf-8") as f:
            product_links = [line.strip() for line in f.readlines() if line.strip()]
    except FileNotFoundError:
        print("Error: geovoice_product_links.txt not found!", flush=True)
        return
    
    if not product_links:
        print("Error: geovoice_product_links.txt is empty!", flush=True)
        return
    
    # Smoke-test overrides (env vars): MAX_PRODUCTS limits count, NO_DELAY disables sleeps
    max_products = int(os.getenv('MAX_PRODUCTS', '0'))
    no_delay = os.getenv('NO_DELAY', 'false').lower() == 'true'
    if max_products > 0:
        product_links = product_links[:max_products]
        print(f"[SMOKE TEST] Limited to {max_products} products, no_delay={no_delay}", flush=True)
    
    def parse_product_html(html, product_url):
        """Parse product data from HTML using BeautifulSoup (FlareSolverr mode)"""
        soup = BeautifulSoup(html, 'html.parser')
        
        name_el = soup.select_one('.ty-product-block-title')
        name = name_el.get_text(strip=True) if name_el else (soup.title.get_text(strip=True) if soup.title else 'N/A')
        
        id_el = soup.select_one('span[id*="product_code_"]')
        if id_el:
            unique_id = re.sub(r'[^A-Za-z0-9-]', '', id_el.get_text(strip=True)).strip('-')
        else:
            print(f"  ERROR: Could not find ID for {name[:40]}", flush=True)
            unique_id = "N/A"
        
        price_el = soup.select_one('span[id^="sec_discounted_price_"]') or soup.select_one('span.ty-price-num')
        if price_el:
            price = extract_price_from_text(price_el.get_text(strip=True))
        else:
            print(f"  ERROR: Could not find price for {name[:40]}", flush=True)
            price = 0.0
        
        stock_el = soup.select_one('span.ty-qty-in-stock')
        status = 'In Stock' if (stock_el and 'მარაგშია' in stock_el.get_text()) else 'Out of Stock'
        
        return {
            'UNIQUE_ID': unique_id.strip(),
            'NAME': name.strip(),
            'PRICE': price,
            'STATUS': status,
            'LINK': product_url.strip(),
            'DATE': datetime.now().strftime("%Y-%m-%d %H:%M")
        }
    
    # --- FLARESOLVERR MODE: bypass Cloudflare via local FlareSolverr (port 8191) ---
    use_flaresolverr = os.getenv('USE_FLARESOLVERR', 'true').lower() == 'true' and flaresolverr_available()
    if use_flaresolverr:
        print(f"Using FlareSolverr at {FLARESOLVERR_URL} to bypass Cloudflare", flush=True)
        all_products = []
        output_file = os.path.join(script_dir, "geovoice_final_stock.xlsx")
        
        for idx, product_url in enumerate(product_links, 1):
            print(f"\nProduct {idx}/{len(product_links)}: {product_url}", flush=True)
            
            if idx > 1 and not no_delay:
                delay = random.uniform(2, 4)
                print(f"  Waiting {delay:.1f}s before visiting...", flush=True)
                await asyncio.sleep(delay)
            
            if idx > 1 and idx % 100 == 0 and not no_delay:
                cooldown = random.uniform(20, 40)
                print(f"  Taking a {cooldown:.0f}s cooldown break after {idx} products...", flush=True)
                await asyncio.sleep(cooldown)
            
            html = fetch_via_flaresolverr(product_url)
            if html is None:
                html = fetch_via_flaresolverr(product_url)  # single retry
            if html is None:
                print(f"  ERROR: Failed to fetch {product_url}, skipping", flush=True)
                continue
            
            if 'Just a moment' in html and len(html) < 5000:
                print(f"  ERROR: Cloudflare challenge not solved by FlareSolverr for {product_url}", flush=True)
                if no_delay:
                    print("  [SMOKE TEST] Fail-fast: aborting on Cloudflare detection", flush=True)
                    return
                continue
            
            try:
                product = parse_product_html(html, product_url)
                all_products.append(product)
                print(f"  ✓ Extracted: {product['NAME'][:40]} | ID: {product['UNIQUE_ID']} | Price: {product['PRICE']}", flush=True)
            except Exception as e:
                print(f"  ERROR: Failed to parse product data: {str(e)[:80]}", flush=True)
            
            if idx % 20 == 0:
                save_progress(all_products, output_file)
                print(f"  Progress saved ({idx} products)", flush=True)
        
        if all_products:
            df = pd.DataFrame(all_products)
            df.drop_duplicates(subset=['UNIQUE_ID'], keep='first', inplace=True)
            df['PRICE'] = pd.to_numeric(df['PRICE'], errors='coerce')
            df.to_excel(output_file, index=False)
            print(f"\n{'='*60}", flush=True)
            print(f"SCRAPE COMPLETE (FlareSolverr mode)!", flush=True)
            print(f"   Total products processed: {len(product_links)}", flush=True)
            print(f"   Unique products (after dedup): {len(df)}", flush=True)
            print(f"   Output file: {output_file}", flush=True)
            print(f"{'='*60}", flush=True)
        else:
            print("\nNo products found (FlareSolverr mode)!", flush=True)
        return
    
    print("FlareSolverr not available - falling back to Playwright mode", flush=True)
    
    print(f"Starting deep extraction for {len(product_links)} products...", flush=True)
    
    # STEP 2: Visit each product page and extract detailed data
    print("\n" + "="*60, flush=True)
    print("STEP 2: Visiting product pages for detailed extraction", flush=True)
    print("="*60, flush=True)
    
    all_products = []
    output_file = os.path.join(script_dir, "geovoice_final_stock.xlsx")
    
    # Random User-Agents for human-mimic
    USER_AGENTS = [
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/122.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0'
    ]
    
    async with async_playwright() as p:
        headless_mode = os.getenv('HEADLESS', 'true').lower() == 'true'
        # Pick random user-agent for this session
        random_user_agent = random.choice(USER_AGENTS)
        print(f"Using User-Agent: {random_user_agent[:50]}...", flush=True)
        
        browser = await p.chromium.launch(headless=headless_mode, args=['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'])
        context = await browser.new_context(
            user_agent=random_user_agent,
            extra_http_headers={'Referer': 'https://geovoice.ge/'}
        )
        page = await context.new_page()
        
        for idx, product_url in enumerate(product_links, 1):
            print(f"\nProduct {idx}/{len(product_links)}: {product_url}", flush=True)
            
            # Random delay before each product page (3-6 seconds) to avoid blocking
            if idx > 1 and not no_delay:  # Skip delay for first product
                delay = random.uniform(3, 6)
                print(f"  Waiting {delay:.1f}s before visiting...", flush=True)
                await asyncio.sleep(delay)
            
            # Longer cooldown break every 100 products to stay under rate limits
            if idx > 1 and idx % 100 == 0 and not no_delay:
                cooldown = random.uniform(30, 60)
                print(f"  Taking a {cooldown:.0f}s cooldown break after {idx} products...", flush=True)
                await asyncio.sleep(cooldown)
            
            retry_count = 0
            max_retries = 2
            
            while retry_count <= max_retries:
                try:
                    await page.goto(product_url, wait_until="domcontentloaded", timeout=60000)
                
                    # Check for Cloudflare 'Just a moment' page
                    page_content = await page.content()
                    if 'Just a moment' in page_content or 'Checking your browser' in page_content:
                        if no_delay:
                            print(f"  [SMOKE TEST] Cloudflare detected on {product_url} - fail-fast, aborting", flush=True)
                            await browser.close()
                            return
                        wait_time = 180 * (retry_count + 1)  # 3 min, then 6 min
                        print(f"  ⚠ Cloudflare detected! Waiting {wait_time//60} minutes before retry...", flush=True)
                        await asyncio.sleep(wait_time)
                        retry_count += 1
                        if retry_count <= max_retries:
                            print(f"  Retrying ({retry_count}/{max_retries})...", flush=True)
                            continue
                        else:
                            print(f"  ERROR: Cloudflare block persists after retry, skipping product", flush=True)
                            break
                    
                    try:
                        # Wait for product block to load
                        await page.wait_for_selector(PRODUCT_PAGE_SELECTORS['product_block'], timeout=10000)
                    
                        await asyncio.sleep(1)  # Additional sleep for dynamic content
                    
                        # Extract Name
                        name_element = await page.query_selector(PRODUCT_PAGE_SELECTORS['name'])
                        if name_element:
                            name = await name_element.inner_text()
                        else:
                            # Try to get from title as fallback
                            name = await page.title()
                    
                        # Extract Unique ID - Priority: span[id*="product_code_"], then fallback
                        id_element = await page.query_selector('span[id*="product_code_"]')
                        if not id_element:
                            id_element = await page.query_selector(PRODUCT_PAGE_SELECTORS['unique_id'])
                    
                        if id_element:
                            unique_id = await id_element.inner_text()
                            # Clean ID: remove only spaces, dots, and special characters - preserve alphanumeric and dashes
                            # This preserves SKUs like APTXDG2-ESS instead of just extracting "2"
                            unique_id = re.sub(r'[^A-Za-z0-9-]', '', str(unique_id).strip())
                            # Remove leading/trailing dashes if present
                            unique_id = unique_id.strip('-')
                        else:
                            print(f"  ERROR: Could not find ID for {name[:40]}", flush=True)
                            unique_id = "N/A"
                    
                        # Extract Price - prioritize discounted
                        price_element = await page.query_selector(PRODUCT_PAGE_SELECTORS['price_discounted'])
                        if not price_element:
                            price_element = await page.query_selector(PRODUCT_PAGE_SELECTORS['price_regular'])
                    
                        if price_element:
                            raw_price = await price_element.inner_text()
                            price = extract_price_from_text(raw_price)
                        else:
                            print(f"  ERROR: Could not find price for {name[:40]}", flush=True)
                            price = 0.0
                    
                        # Extract Stock Status
                        stock_element = await page.query_selector(PRODUCT_PAGE_SELECTORS['stock'])
                        if stock_element:
                            stock_text = await stock_element.inner_text()
                            if 'მარაგშია' in stock_text:
                                status = 'In Stock'
                            else:
                                status = 'Out of Stock'
                        else:
                            status = 'Out of Stock'
                    
                        # Add to results
                        all_products.append({
                            'UNIQUE_ID': unique_id.strip(),
                            'NAME': name.strip(),
                            'PRICE': price,
                            'STATUS': status,
                            'LINK': product_url.strip(),
                            'DATE': datetime.now().strftime("%Y-%m-%d %H:%M")
                        })
                    
                        print(f"  ✓ Extracted: {name[:40]} | ID: {unique_id} | Price: {price}", flush=True)
                    
                        # Save progress every 20 products
                        if idx % 20 == 0:
                            save_progress(all_products, output_file)
                            print(f"  Progress saved ({idx} products)", flush=True)
                    
                    except Exception as e:
                        print(f"  ERROR: Failed to extract product data: {str(e)[:50]}", flush=True)
                    
                    break  # Success, exit retry loop
                
                except Exception as e:
                    if retry_count < max_retries and 'CancelledError' not in str(type(e)):
                        print(f"  ERROR: Failed to scrape {product_url}: {str(e)[:50]}", flush=True)
                        retry_count += 1
                        await asyncio.sleep(5)  # Brief pause before retry
                        continue
                    else:
                        print(f"  ERROR: Failed to scrape {product_url}: {str(e)[:50]}", flush=True)
                        break
        
        await browser.close()
    
    # Export data to Excel
    if all_products:
        df = pd.DataFrame(all_products)
        df.drop_duplicates(subset=['UNIQUE_ID'], keep='first', inplace=True)
        
        output_file = os.path.join(script_dir, "geovoice_final_stock.xlsx")
        # Ensure PRICE column is numeric in Excel
        df['PRICE'] = pd.to_numeric(df['PRICE'], errors='coerce')
        df.to_excel(output_file, index=False)
        
        print(f"\n{'='*60}", flush=True)
        print(f"SCRAPE COMPLETE!", flush=True)
        print(f"   Total products processed: {len(product_links)}", flush=True)
        print(f"   Total products found: {len(df)}", flush=True)
        print(f"   Unique products (after dedup): {len(df)}", flush=True)
        print(f"   Output file: {output_file}", flush=True)
        print(f"{'='*60}", flush=True)
    else:
        print("\nNo products found across all categories!", flush=True)
        print("Possible issues:", flush=True)
        print("- Product selector 'div.ut2-gl__body' or 'div.ty-column4' may not match the actual website structure", flush=True)
        print("- Website may have changed its layout", flush=True)
        print("- All pages may have returned 404 errors", flush=True)
        print("- Network connectivity issues", flush=True)

if __name__ == "__main__":
    asyncio.run(scrape_geovoice_full())