import sys
import io
import os
import re
import socket
import requests
import pandas as pd
from datetime import datetime

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

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

def fetch_products():
    """Fetch products from API using hostname-based proxy detection."""
    url = 'https://acoustic.ge/data/products.json'
    hostname = socket.gethostname()
    
    print(f"Hostname: {hostname}", flush=True)
    
    # On server: fetch directly. Locally: use SOCKS5 proxy via SSH tunnel (port 1080)
    if 'root' in hostname or 'ubuntu' in hostname or 'server' in hostname.lower():
        print("Server environment detected - fetching directly.", flush=True)
        response = requests.get(url, timeout=30)
    else:
        print("Local environment detected - using SOCKS5 proxy on port 1080.", flush=True)
        proxies = {
            'http': 'socks5://127.0.0.1:1080',
            'https': 'socks5://127.0.0.1:1080'
        }
        response = requests.get(url, proxies=proxies, timeout=30)
    
    if response.status_code != 200:
        print(f"Error: API returned status code {response.status_code}", flush=True)
        return None
    
    return response.json()

def scrape_acoustic_full():
    """Full scraper using JSON API instead of Playwright"""
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    print(f"Fetching data from https://acoustic.ge/data/products.json", flush=True)
    
    try:
        products_data = fetch_products()
        if products_data is None:
            return
    except requests.exceptions.RequestException as e:
        print(f"Error fetching from API: {e}", flush=True)
        return
    
    # Handle different JSON structures
    if isinstance(products_data, list):
        products_list = products_data
    elif isinstance(products_data, dict):
        if 'products' in products_data:
            products_list = products_data['products']
        elif 'data' in products_data:
            products_list = products_data['data']
        elif 'items' in products_data:
            products_list = products_data['items']
        else:
            products_list = [products_data]
    else:
        print(f"Unexpected JSON structure: {type(products_data)}", flush=True)
        return
    
    print(f"Found {len(products_list)} products in JSON response", flush=True)
    
    # Status mapping for Georgian text
    STATUS_MAPPING = {
        'გაყიდვაშია': 'In Stock',
        'მარაგშია': 'In Stock',
        'არ არის მარაგში': 'Out of Stock',
        'in stock': 'In Stock',
        'out of stock': 'Out of Stock',
        'true': 'In Stock',
        'false': 'Out of Stock',
        True: 'In Stock',
        False: 'Out of Stock'
    }
    
    all_products = []
    
    # Process each product from JSON
    for item in products_list:
        try:
            # Map JSON fields to output structure using correct API keys
            unique_id = str(item.get('sku', 'N/A')).strip()
            name = str(item.get('product', '')).strip()
            
            # Price handling
            price_raw = item.get('price', 0)
            if isinstance(price_raw, (int, float)):
                price = float(price_raw)
            else:
                price = extract_price_with_regex(str(price_raw))
            
            # Status derived from stock amount
            amount = item.get('amount', 0)
            try:
                amount = int(amount)
            except (ValueError, TypeError):
                amount = 0
            status = 'In Stock' if amount > 0 else 'Out of Stock'
            
            # Link handling
            link = str(item.get('url', '')).strip()
            
            # Add to results - UNIQUE_ID and LINK are aliases for SKU and URL
            # to maintain compatibility with transform.py and acmi_data_merger.py
            all_products.append({
                'UNIQUE_ID': unique_id,
                'NAME': name,
                'PRICE': price,
                'STATUS': status,
                'LINK': link,
                'DATE': datetime.now().strftime("%Y-%m-%d %H:%M")
            })
            
        except Exception as e:
            print(f"Error processing product item: {str(e)[:50]}", flush=True)
            continue
    
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
        print(f"   Total products found: {len(df)}", flush=True)
        print(f"   Unique products (after dedup): {len(df)}", flush=True)
        print(f"   Output file: {output_file}", flush=True)
        print(f"{'='*60}", flush=True)
    else:
        print("\nNo products found in JSON response!", flush=True)
        print("Possible issues:", flush=True)
        print("- JSON structure may not match expected format", flush=True)
        print("- API endpoint may have returned empty data", flush=True)
        print("- Field names in JSON may differ from expected", flush=True)

if __name__ == "__main__":
    scrape_acoustic_full()