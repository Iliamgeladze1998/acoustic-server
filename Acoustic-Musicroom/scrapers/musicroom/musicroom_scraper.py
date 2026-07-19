import sys
import io
import pandas as pd
import json
import requests
from bs4 import BeautifulSoup
import time
import os
import threading
from pathlib import Path
from flaresolverr_helper import flaresolverr_available, fetch_via_flaresolverr

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', write_through=True)

# Use absolute paths based on script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_FILE = os.path.join(SCRIPT_DIR, "all_product_links.txt")
OUTPUT_FILE = os.path.join(SCRIPT_DIR, "musicroom_results.xlsx")
CHECKPOINT_FILE = os.path.join(SCRIPT_DIR, "musicroom_checkpoint.json")

PER_PRODUCT_TIMEOUT = 180  # 3 minutes max per product

all_data = []

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


def scrape_with_timeout(url, timeout_sec=PER_PRODUCT_TIMEOUT):
    """Run scrape_musicroom with a hard timeout. Returns None if timed out."""
    result = [None]
    def worker():
        result[0] = scrape_musicroom(url)
    t = threading.Thread(target=worker, daemon=True)
    t.start()
    t.join(timeout=timeout_sec)
    if t.is_alive():
        print(f"  TIMEOUT after {timeout_sec}s — skipping this product")
        return None
    return result[0]


def load_checkpoint():
    """Load previously scraped data and the index we left off at."""
    try:
        with open(CHECKPOINT_FILE, "r", encoding="utf-8") as f:
            cp = json.load(f)
            return cp.get("data", []), cp.get("last_index", 0)
    except (FileNotFoundError, json.JSONDecodeError):
        return [], 0


def save_checkpoint(data, last_index):
    """Save checkpoint so we can resume after crash/restart."""
    try:
        with open(CHECKPOINT_FILE, "w", encoding="utf-8") as f:
            json.dump({"data": data, "last_index": last_index}, f, ensure_ascii=False)
    except Exception as e:
        print(f"  Checkpoint save error: {e}")


# Read all product links
input_path = Path(INPUT_FILE)
output_path = Path(OUTPUT_FILE)

try:
    with open(input_path, "r", encoding="utf-8") as f:
        product_links = [line.strip() for line in f if line.strip()]
except FileNotFoundError:
    print(f" Input file not found: {INPUT_FILE}")
    exit(1)

print(f" Found {len(product_links)} product links to process")

# Load checkpoint and resume
checkpoint_data, start_index = load_checkpoint()
if checkpoint_data:
    all_data = checkpoint_data
    print(f" Resuming from checkpoint: {len(all_data)} products already scraped, starting at index {start_index}")
    if start_index >= len(product_links):
        print(" Checkpoint shows all products done. Starting fresh.")
        all_data = []
        start_index = 0
else:
    if output_path.exists():
        output_path.unlink()
        print(f"Cleared existing output file: {output_path}")

if flaresolverr_available():
    print(" Using Camoufox for Cloudflare bypass")
else:
    print(" Camoufox not available, falling back to direct requests")

max_products = os.getenv('MAX_PRODUCTS')
if max_products and max_products.isdigit():
    max_products = int(max_products)
    if max_products > 0:
        product_links = product_links[:max_products]
        print(f" [TEST MODE] Limited to {max_products} products")

if not product_links:
    print(" No product links found. Aborting.")
    exit(1)

# Main loop - process all links, resuming from checkpoint
for i, link in enumerate(product_links, 1):
    if i <= start_index:
        continue
    print(f"Processing {i}/{len(product_links)}: {link}")
    data = scrape_with_timeout(link)
    if data:
        all_data.append(data)
        print(f" Scraped: {data['NAME']} - Price: {data['PRICE']} - ID: {data['UNIQUE_ID']}")
    else:
        print(f" Skipped product {i} (failed or timed out)")
    # Save checkpoint every 10 products
    if i % 10 == 0:
        save_checkpoint(all_data, i)
    time.sleep(1)  # Delay to avoid server blocking

# Final checkpoint clear
save_checkpoint(all_data, len(product_links))

# Create XLSX file in same folder as script
if all_data:
    df = pd.DataFrame(all_data)
    # Save to the output path
    df.to_excel(output_path, index=False)
    print(f"\n Complete. {len(all_data)} products saved to {output_path}")
    # Clear checkpoint after successful save
    try:
        os.remove(CHECKPOINT_FILE)
    except OSError:
        pass
else:
    print(" No data collected. File not created.")
    exit(1)