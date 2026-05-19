import requests
from bs4 import BeautifulSoup
import pandas as pd
import time
from datetime import datetime
import re
import json
import os

def scrape_product_details(url, session):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        response = session.get(url, headers=headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Initialize price
        price = 0
        
        # Extract NAME from <h1 class="product_title">
        title_h1 = soup.select_one('h1.product_title')
        name = title_h1.get_text(strip=True) if title_h1 else ''
        
        # Extract UNIQUE_ID from <span class="sku">
        sku_span = soup.select_one('span.sku')
        unique_id = sku_span.get_text(strip=True) if sku_span else ''
        
        # Extract PRICE - try .summary .woocommerce-Price-amount bdi first
        price_elements = soup.select('.summary .woocommerce-Price-amount bdi')
        if price_elements:
            # Take the last price in .summary section (usually the active price)
            price_text = price_elements[-1].get_text()
            
            # Use regex to strip everything except digits
            price_cleaned = re.sub(r'[^\d]', '', price_text)
            
            # If ends in 00, remove last two zeros (Mireli uses ,00 at the end)
            if price_cleaned.endswith('00') and len(price_cleaned) > 2:
                price_cleaned = price_cleaned[:-2]
            
            # Final safeguard: if empty string, set to 0, otherwise convert to int
            if not price_cleaned:
                price = 0
            else:
                try:
                    price = int(price_cleaned)
                except ValueError:
                    price = 0
        else:
            # Fallback: Try to extract from JSON-LD script
            json_ld_script = soup.find('script', type='application/ld+json')
            if json_ld_script:
                try:
                    json_data = json.loads(json_ld_script.string)
                    # JSON-LD can be a dict or list
                    if isinstance(json_data, list):
                        json_data = json_data[0]
                    
                    # Handle @graph structure
                    if isinstance(json_data, dict) and '@graph' in json_data:
                        graph_items = json_data['@graph']
                        if isinstance(graph_items, list):
                            # Find the item with @type Product or containing offers
                            for item in graph_items:
                                if isinstance(item, dict):
                                    if '@type' in item and ('Product' in item['@type'] or 'offers' in item):
                                        if 'offers' in item:
                                            offers = item['offers']
                                            if isinstance(offers, list):
                                                offers = offers[0]
                                            if isinstance(offers, dict) and 'price' in offers:
                                                price_str = str(offers['price'])
                                                price = int(float(price_str))
                                                break
                    # Handle direct offers structure
                    elif isinstance(json_data, dict) and 'offers' in json_data:
                        offers = json_data['offers']
                        if isinstance(offers, list):
                            offers = offers[0]
                        if isinstance(offers, dict) and 'price' in offers:
                            price_str = str(offers['price'])
                            price = int(float(price_str))
                        else:
                            price = 0
                    else:
                        price = 0
                except (json.JSONDecodeError, KeyError, ValueError, AttributeError) as e:
                    price = 0
            else:
                price = 0
        
        # Extract STATUS
        status_el = soup.select_one('.klb-single-stock')
        if status_el:
            status_text = status_el.get_text(strip=True)
            if 'მარაგშია' in status_text:
                status = 'In Stock'
            else:
                status = 'Out of Stock'
        else:
            status = 'Out of Stock'
        
        # Current timestamp
        date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        return {
            'UNIQUE_ID': unique_id,
            'NAME': name,
            'PRICE': price,
            'STATUS': status,
            'LINK': url,
            'DATE': date
        }
        
    except requests.exceptions.RequestException as e:
        print(f"Error scraping {url}: {e}")
        return None

def main():
    # Use BASE_DIR for cross-platform compatibility
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    input_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_products.txt')
    output_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_final_stock.xlsx')
    
    # Use session for better performance
    session = requests.Session()
    
    # Read product URLs
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            product_urls = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"Error: {input_file} not found. Please run get_all_product_links.py first.")
        return
    
    print(f"Found {len(product_urls)} products to scrape.")
    print("-" * 80)
    
    # Scrape all products
    products_data = []
    for idx, url in enumerate(product_urls, 1):
        product_data = scrape_product_details(url, session)
        if product_data:
            products_data.append(product_data)
            # Live monitoring: print summary for each product
            print(f"[Product #{idx}/{len(product_urls)}] | ID: {product_data['UNIQUE_ID']} | Price: {product_data['PRICE']} | Status: {product_data['STATUS']} | Name: {product_data['NAME'][:50]}... | URL: {url}")
        
        # Sleep between requests
        time.sleep(0.5)
    
    # Create DataFrame and save to Excel
    if products_data:
        df = pd.DataFrame(products_data, columns=['UNIQUE_ID', 'NAME', 'PRICE', 'STATUS', 'LINK', 'DATE'])
        df.to_excel(output_file, index=False, engine='openpyxl')
        print(f"Successfully saved {len(products_data)} products to {output_file}")
    else:
        print("No product data was scraped.")

if __name__ == "__main__":
    main()
