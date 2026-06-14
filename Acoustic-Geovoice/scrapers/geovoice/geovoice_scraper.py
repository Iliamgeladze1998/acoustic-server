import asyncio
import os
import re
import hashlib
import random
import pandas as pd
from datetime import datetime
from playwright.async_api import async_playwright

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
            
            # Random delay before each product page (2-5 seconds) for local use
            if idx > 1:  # Skip delay for first product
                delay = random.uniform(2, 5)
                print(f"  Waiting {delay:.1f}s before visiting...", flush=True)
                await asyncio.sleep(delay)
            
            retry_count = 0
            max_retries = 1
            
            while retry_count <= max_retries:
                try:
                    await page.goto(product_url, wait_until="domcontentloaded", timeout=60000)
                
                    # Check for Cloudflare 'Just a moment' page
                    page_content = await page.content()
                    if 'Just a moment' in page_content or 'Checking your browser' in page_content:
                        print(f"  ⚠ Cloudflare detected! Waiting 2 minutes before retry...", flush=True)
                        await asyncio.sleep(120)  # Wait 2 minutes
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