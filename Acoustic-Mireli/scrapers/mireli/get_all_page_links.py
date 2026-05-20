import requests
from bs4 import BeautifulSoup
import os

def get_all_page_links():
    base_url = "https://mireli.ge/product-category/qhvela/page/"
    
    # Use BASE_DIR for cross-platform compatibility
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    output_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_pages.txt')
    if os.path.exists(output_file):
        os.remove(output_file)
    
    try:
        # Fetch the first page
        response = requests.get(base_url + "1/")
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Locate pagination section
        pagination = soup.find('ul', class_='page-numbers')
        
        if not pagination:
            print("No pagination found on the page.")
            return False
        
        # Extract all page numbers from pagination links
        page_numbers = []
        for link in pagination.find_all('a'):
            href = link.get('href', '')
            # Extract page number from URL
            if '/page/' in href:
                try:
                    page_num = int(href.split('/page/')[-1].strip('/'))
                    page_numbers.append(page_num)
                except ValueError:
                    continue
        
        if not page_numbers:
            print("No page numbers found in pagination.")
            return False
        
        # Get the highest page number
        max_page = max(page_numbers)
        print(f"Found {max_page} pages total.")
        
        # Generate all page URLs
        page_urls = [f"{base_url}{i}/" for i in range(1, max_page + 1)]
        
        # Save to file
        with open(output_file, 'w', encoding='utf-8') as f:
            for url in page_urls:
                f.write(url + '\n')
        
        print(f"Successfully saved {len(page_urls)} page URLs to {output_file}")
        return True
        
    except requests.exceptions.RequestException as e:
        print(f"Connection error occurred: {e}")
        return False
    except Exception as e:
        print(f"An error occurred: {e}")
        return False

if __name__ == "__main__":
    import sys
    sys.exit(0 if get_all_page_links() else 1)
