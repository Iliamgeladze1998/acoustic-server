import sys
import io
import pandas as pd
import json
import requests
from bs4 import BeautifulSoup
import time
import os
from pathlib import Path

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', write_through=True)

# Use absolute paths based on script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_FILE = os.path.join(SCRIPT_DIR, "all_product_links.txt")
OUTPUT_FILE = os.path.join(SCRIPT_DIR, "musicroom_results.xlsx")

all_data = []

FLARESOLVERR_URL = os.getenv('FLARESOLVERR_URL', 'http://localhost:8191/v1')

def flaresolverr_available():
    try:
        r = requests.get(FLARESOLVERR_URL.rsplit('/v1', 1)[0] + '/', timeout=5)
        return r.status_code == 200
    except Exception:
        return False

def fetch_via_flaresolverr(url, timeout_ms=60000):
    try:
        resp = requests.post(
            FLARESOLVERR_URL,
            json={'cmd': 'request.get', 'url': url, 'maxTimeout': timeout_ms},
            timeout=timeout_ms / 1000 + 30
        )
        data = resp.json()
        if data.get('status') == 'ok':
            return data['solution']['response']
        print(f"  FlareSolverr error: {data.get('message', 'unknown')}")
        return None
    except Exception as e:
        print(f"  FlareSolverr request failed: {str(e)[:80]}")
        return None

def scrape_musicroom(url):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        html = None
        if flaresolverr_available():
            html = fetch_via_flaresolverr(url)
        if html is None:
            response = requests.get(url, headers=headers)
            html = response.text
        soup = BeautifulSoup(html, 'html.parser')

        # Find Schema.org JSON data (SKU, Name, Price are in there)
        schema_data = soup.find('script', type='application/ld+json', class_='rank-math-schema')
        
        if schema_data:
            data_json = json.loads(schema_data.string)
            # Find Product part in the graph
            product_info = next(item for item in data_json['@graph'] if item['@type'] == 'Product')
            
            # Extract data
            name = product_info.get('name')
            sku = product_info.get('sku')  # This is UNIQUE_ID
            price = product_info.get('offers', {}).get('price')
            
            # Format price as integer (remove trailing zeros and decimals)
            if price:
                try:
                    price = int(float(price))
                except (ValueError, TypeError):
                    price = 0
            
            # Extract status from Meta tag (more reliable)
            availability_meta = soup.find('meta', property='product:availability')
            status = availability_meta['content'] if availability_meta else "unknown"

            return {
                "UNIQUE_ID": sku,
                "NAME": name,
                "PRICE": price,
                "STATUS": status,
                "LINK": url
            }
    except Exception as e:
        print(f"Error scraping {url}: {e}")
        return None

# Read all product links
input_path = Path(INPUT_FILE)
output_path = Path(OUTPUT_FILE)
if output_path.exists():
    output_path.unlink()
    print(f"Cleared existing output file: {output_path}")

try:
    with open(input_path, "r", encoding="utf-8") as f:
        product_links = [line.strip() for line in f if line.strip()]
except FileNotFoundError:
    print(f" Input file not found: {INPUT_FILE}")
    exit(1)

print(f" Found {len(product_links)} product links to process")
if flaresolverr_available():
    print(f" Using FlareSolverr at {FLARESOLVERR_URL} for Cloudflare bypass")
else:
    print(" FlareSolverr not available, falling back to direct requests")

max_products = os.getenv('MAX_PRODUCTS')
if max_products and max_products.isdigit():
    max_products = int(max_products)
    if max_products > 0:
        product_links = product_links[:max_products]
        print(f" [TEST MODE] Limited to {max_products} products")

if not product_links:
    print(" No product links found. Aborting.")
    exit(1)

# Main loop - process all links
for i, link in enumerate(product_links, 1):
    print(f"Processing {i}/{len(product_links)}: {link}")
    data = scrape_musicroom(link)
    if data:
        all_data.append(data)
        # Real-time logging for each product
        print(f" Scraped: {data['NAME']} - Price: {data['PRICE']} - ID: {data['UNIQUE_ID']}")
    time.sleep(1)  # Delay to avoid server blocking

# Create XLSX file in same folder as script
if all_data:
    df = pd.DataFrame(all_data)
    # Save to the output path
    df.to_excel(output_path, index=False)
    print(f"\n Complete. {len(all_data)} products saved to {output_path}")
else:
    print(" No data collected. File not created.")
    exit(1)