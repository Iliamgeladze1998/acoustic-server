import requests
import cloudscraper
import pandas as pd
import time
import random
import re
import os
import json
import urllib.request
from bs4 import BeautifulSoup
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Get the directory where this script is located
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

FLARESOLVERR_URL = 'http://127.0.0.1:8191/v1'


def flaresolverr_available():
    """Check if FlareSolverr is running."""
    try:
        r = requests.get('http://127.0.0.1:8191/', timeout=5)
        return r.status_code == 200
    except Exception:
        return False


def fetch_via_flaresolverr(url, timeout_ms=60000):
    """Fetch a page through FlareSolverr to bypass Cloudflare. Returns HTML or None."""
    try:
        payload = json.dumps({
            'cmd': 'request.get',
            'url': url,
            'maxTimeout': timeout_ms,
        }).encode()
        req = urllib.request.Request(
            FLARESOLVERR_URL,
            data=payload,
            headers={'Content-Type': 'application/json'},
        )
        with urllib.request.urlopen(req, timeout=timeout_ms // 1000 + 10) as resp:
            data = json.loads(resp.read())
        if data.get('status') == 'ok':
            return data.get('solution', {}).get('response', '')
        logger.error(f"FlareSolverr error: {data.get('message', 'unknown')}")
        return None
    except Exception as e:
        logger.error(f"FlareSolverr request failed: {str(e)[:80]}")
        return None

class GeovoiceProductLinkCollector:
    def __init__(self):
        self.session = cloudscraper.create_scraper(browser={'browser': 'chrome', 'platform': 'windows', 'desktop': True})
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })
        
    def collect_from_category_links(self, category_file="geovoice_category_links.txt"):
        """Collect all product links from category pages file using specific selectors."""
        # Use absolute path for category file
        category_file_path = os.path.join(SCRIPT_DIR, category_file)
        logger.info(f"Reading category page links from {category_file_path}")
        
        try:
            with open(category_file_path, 'r', encoding='utf-8') as f:
                category_page_links = [line.strip() for line in f if line.strip()]
        except Exception as e:
            logger.error(f"Error reading category page links: {e}")
            return False
        
        if not category_page_links:
            logger.error("No category page links found!")
            return False
        
        use_flaresolverr = flaresolverr_available()
        if use_flaresolverr:
            logger.info("FlareSolverr available — using it for Cloudflare bypass")
        else:
            logger.info("FlareSolverr not available — falling back to cloudscraper")
        
        all_product_links = []
        
        for i, category_page_url in enumerate(category_page_links, 1):
            logger.info(f"Processing category page {i}/{len(category_page_links)}: {category_page_url}")
            
            try:
                html = None
                if use_flaresolverr:
                    html = fetch_via_flaresolverr(category_page_url)
                if html is None:
                    response = self.session.get(category_page_url, timeout=10)
                    html = response.text
                
                # Check for Cloudflare challenge (blocked page)
                # Only treat as challenge if "Just a moment" is present AND page is small
                if 'Just a moment' in html and len(html) < 10000:
                    logger.error(f"Cloudflare challenge on {category_page_url}, skipping")
                    continue
                
                soup = BeautifulSoup(html, 'html.parser')
                
                # Find product containers using specific selector: div.ty-column4
                product_containers = soup.find_all('div', class_='ty-column4')
                
                page_product_links = []
                
                for container in product_containers:
                    # Find product links using specific selector: a.product-title
                    product_links = container.find_all('a', class_='product-title')
                    
                    for link_elem in product_links:
                        href = link_elem.get('href', '')
                        if href:
                            # Convert to absolute URL if needed
                            if href.startswith('http'):
                                full_url = href
                            elif href.startswith('/'):
                                full_url = "https://geovoice.ge" + href
                            else:
                                full_url = f"https://geovoice.ge/{href}"
                            
                            if full_url not in all_product_links:
                                page_product_links.append(full_url)
                
                logger.info(f"Extracted {len(page_product_links)} links from {category_page_url}")
                
                # Add to master list
                all_product_links.extend(page_product_links)
                
                # Be respectful to the server (randomized delay to avoid blocking)
                time.sleep(random.uniform(2, 4))
                
            except Exception as e:
                logger.error(f"Error processing category page {category_page_url}: {e}")
                continue
        
        # Remove duplicates
        unique_links = list(set(all_product_links))
        logger.info(f"Total unique product links collected: {len(unique_links)}")
        
        # Save to file using absolute path
        output_file = os.path.join(SCRIPT_DIR, "geovoice_product_links.txt")
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                for link in unique_links:
                    f.write(link + '\n')
            logger.info(f"✅ Saved all product links to {output_file}")
            return True
        except Exception as e:
            logger.error(f"Error saving product links: {e}")
            return False

def main():
    """Main execution for Geovoice product link collection."""
    logger.info("=== Geovoice Product Link Collection Started ===")
    
    # Collect all product links from category pages
    collector = GeovoiceProductLinkCollector()
    if collector.collect_from_category_links():
        logger.info("🎉 All Geovoice product links collected successfully!")
        # Use absolute path for reading the output file
        output_file = os.path.join(SCRIPT_DIR, "geovoice_product_links.txt")
        with open(output_file, 'r', encoding='utf-8') as f:
            link_count = len([line.strip() for line in f.readlines() if line.strip()])
        logger.info(f"Total links ready for scraping: {link_count}")
        logger.info("✅ Ready for next step: Individual product scraping")
    else:
        logger.error("💥 Failed to collect product links!")

if __name__ == "__main__":
    main()