import asyncio
import os
import re
import pandas as pd
from datetime import datetime
from playwright.async_api import async_playwright

def extract_price_with_regex(price_text):
    """Extract first whole number from text using regex"""
    if not price_text:
        return 0.0
    
    # Handle case where text is just 'GEL' or contains no digits
    if price_text.strip().upper() == 'GEL':
        return 0.0
    
    # Find first whole number only (ignore decimals in separate tags)
    cleaned_text = price_text.replace(',', '').replace(' ', '')
    match = re.search(r'\d+', cleaned_text)
    
    return float(match.group()) if match else 0.0

async def scrape_acoustic_full():
    """Full scraper with integrated pagination and data extraction"""
    
    # Exact selectors from screenshots
    SELECTORS = {
        'product_block': 'div.ty-column4',
        'name_link': 'a.product-title',
        'price': 'span.ty-price-num',
        'unique_id': 'span[id^="product_code_"]',
        'status': 'span.ty-qty-in-stock'
    }
    
    # Status mapping for Georgian text
    STATUS_MAPPING = {
        'გაყიდვაშია': 'In Stock',
        'მარაგშია': 'In Stock',
        'არ არის მარაგში': 'Out of Stock',
        'in stock': 'In Stock',
        'out of stock': 'Out of Stock'
    }
    
    # Read base links from subcategory_links.txt
    script_dir = os.path.dirname(os.path.abspath(__file__))
    try:
        with open(os.path.join(script_dir, "subcategory_links.txt"), "r", encoding="utf-8") as f:
            base_links = [line.strip() for line in f.readlines() if line.strip()]
    except FileNotFoundError:
        print("Error: subcategory_links.txt not found!", flush=True)
        return
    
    if not base_links:
        print("Error: subcategory_links.txt is empty!", flush=True)
        return
    
    print(f"Starting full scrape for {len(base_links)} categories...", flush=True)
    
    all_products = []
    category_count = 0
    
    async with async_playwright() as p:
        headless_mode = os.getenv('HEADLESS', 'true').lower() == 'true'
        browser = await p.chromium.launch(headless=headless_mode, args=['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'])
        context = await browser.new_context(
            user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36'
        )
        page = await context.new_page()
        
        for base_link in base_links:
            category_count += 1
            print(f"\n{'='*60}", flush=True)
            print(f"CATEGORY {category_count}/{len(base_links)}: {base_link}", flush=True)
            print(f"{'='*60}", flush=True)
            
            page_num = 1
            
            while True:
                # Construct URL (no /page-1/ for first page)
                if page_num == 1:
                    current_url = base_link
                else:
                    current_url = f"{base_link.rstrip('/')}/page-{page_num}/"
                
                print(f"Category {category_count} | Page {page_num} | Checking: {current_url}", flush=True)
                
                try:
                    response = await page.goto(current_url, wait_until="domcontentloaded", timeout=25000)
                    await asyncio.sleep(3)  # Increased sleep for cm-reload container hydration
                    
                    if not response or response.status != 200:
                        print(f"Category {category_count} | Page {page_num} | Status: {response.status if response else 'N/A'} - Stopping pagination", flush=True)
                        break
                    
                    # Find all product blocks
                    product_blocks = await page.query_selector_all(SELECTORS['product_block'])
                    
                    if len(product_blocks) == 0:
                        print(f"Category {category_count} | Page {page_num} | Found 0 products - Stopping pagination", flush=True)
                        # Debug: Check if selector is working
                        try:
                            page_content = await page.content()
                            if 'ty-column4' in page_content:
                                print(f"DEBUG: Product selector 'ty-column4' found in page HTML but query returned 0 results", flush=True)
                            else:
                                print(f"DEBUG: Product selector 'ty-column4' NOT found in page HTML", flush=True)
                        except:
                            print(f"DEBUG: Could not check page HTML content", flush=True)
                        break
                    
                    print(f"Category {category_count} | Page {page_num} | Found {len(product_blocks)} products", flush=True)
                    
                    # Process all products on the page
                    
                    # Extract data from each product
                    for block in product_blocks:
                        try:
                            # Name & Link
                            name_element = await block.query_selector(SELECTORS['name_link'])
                            if name_element:
                                name = await name_element.inner_text()
                                link = await name_element.get_attribute('href')
                            else:
                                continue  # Skip if no name found
                            
                            # Target the deepest possible element directly
                            price_element = await block.query_selector('span[id^="sec_discounted_price_"]')
                            if not price_element:
                                price_element = await block.query_selector('span.ty-price-num')

                            if price_element:
                                # Get content even if it's hidden or nested
                                raw_text = await price_element.evaluate('el => el.textContent')
                                # Remove everything except digits
                                clean_price = "".join(filter(str.isdigit, raw_text))
                                # Convert to proper decimal (20000 -> 200.00)
                                price = float(clean_price) / 100 if clean_price else 0.0
                            else:
                                price = 0.0
                            
                            # Unique ID
                            id_element = await block.query_selector(SELECTORS['unique_id'])
                            if id_element:
                                unique_id = await id_element.inner_text()
                            else:
                                unique_id = "N/A"
                            
                            # Status with Georgian mapping (case-insensitive)
                            status_element = await block.query_selector(SELECTORS['status'])
                            if status_element:
                                status_raw = await status_element.inner_text()
                                status_clean = status_raw.strip().lower()
                                status = STATUS_MAPPING.get(status_clean, 'Out of Stock')
                            else:
                                status = 'Out of Stock'
                            
                            # Add to results
                            all_products.append({
                                'UNIQUE_ID': unique_id.strip(),
                                'NAME': name.strip(),
                                'PRICE': price,
                                'STATUS': status.strip(),
                                'LINK': link.strip() if link else "N/A",
                                'DATE': datetime.now().strftime("%Y-%m-%d %H:%M")
                            })
                            
                        except Exception as e:
                            print(f"Error extracting product data: {str(e)[:50]}", flush=True)
                            continue
                    
                    page_num += 1
                    
                except Exception as e:
                    print(f"Category {category_count} | Page {page_num} | Error: {str(e)[:50]} - Stopping pagination", flush=True)
                    break
        
        await browser.close()
    
    # Export data to Excel
    if all_products:
        df = pd.DataFrame(all_products)
        df.drop_duplicates(subset=['UNIQUE_ID'], keep='first', inplace=True)
        
        output_file = os.path.join(script_dir, "acoustic_final_stock.xlsx")
        # Ensure PRICE column is numeric in Excel
        df['PRICE'] = pd.to_numeric(df['PRICE'], errors='coerce')
        df.to_excel(output_file, index=False)
        
        print(f"\n{'='*60}", flush=True)
        print(f"SCRAPE COMPLETE!", flush=True)
        print(f"   Total categories processed: {len(base_links)}", flush=True)
        print(f"   Total products found: {len(df)}", flush=True)
        print(f"   Unique products (after dedup): {len(df)}", flush=True)
        print(f"   Output file: {output_file}", flush=True)
        print(f"{'='*60}", flush=True)
    else:
        print("\nNo products found across all categories!", flush=True)
        print("Possible issues:", flush=True)
        print("- Product selector 'div.ty-column4' may not match the actual website structure", flush=True)
        print("- Website may have changed its layout", flush=True)
        print("- All pages may have returned 404 errors", flush=True)
        print("- Network connectivity issues", flush=True)

if __name__ == "__main__":
    asyncio.run(scrape_acoustic_full())