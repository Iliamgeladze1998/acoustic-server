import requests
from bs4 import BeautifulSoup
import time
import os

def get_all_product_links():
    # Use BASE_DIR for cross-platform compatibility
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    input_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_pages.txt')
    output_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_products.txt')
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    product_links = set()
    
    try:
        # Read page URLs from file
        with open(input_file, 'r', encoding='utf-8') as f:
            page_urls = [line.strip() for line in f if line.strip()]
        
        print(f"Processing {len(page_urls)} pages...")
        
        for idx, url in enumerate(page_urls, 1):
            try:
                # Fetch the page
                response = requests.get(url, headers=headers)
                response.raise_for_status()
                
                soup = BeautifulSoup(response.content, 'html.parser')
                
                # Find all product links inside h3.product-title
                product_titles = soup.find_all('h3', class_='product-title')
                
                for title in product_titles:
                    link = title.find('a')
                    if link and link.get('href'):
                        product_links.add(link.get('href'))
                
                print(f"Processed page {idx}/{len(page_urls)} - Total unique products: {len(product_links)}")
                
                # Sleep between requests
                time.sleep(0.5)
                
            except requests.exceptions.RequestException as e:
                print(f"Error fetching page {url}: {e}")
                continue
        
        # Save unique product links to file
        with open(output_file, 'w', encoding='utf-8') as f:
            for link in sorted(product_links):
                f.write(link + '\n')
        
        print(f"Successfully saved {len(product_links)} unique product links to {output_file}")
        
    except FileNotFoundError:
        print(f"Error: {input_file} not found. Please run get_all_page_links.py first.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    get_all_product_links()
