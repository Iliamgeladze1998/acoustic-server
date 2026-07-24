import requests

import cloudscraper

import time

import random

import os

import logging

import json

import urllib.request


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



# Configure logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

logger = logging.getLogger(__name__)



# Get the directory where this script is located

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))



class GeovoiceLinkCollector:

    def __init__(self):

        self.session = cloudscraper.create_scraper(browser={'browser': 'chrome', 'platform': 'windows', 'desktop': True})

        self.session.headers.update({

            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'

        })

        

        # Main category URLs provided by user

        self.main_categories = [

            "https://geovoice.ge/audio/",

            "https://geovoice.ge/dj-studia/", 

            "https://geovoice.ge/video-aparatura/",

            "https://geovoice.ge/sasceno-ganateba/",

            "https://geovoice.ge/komutacia/",

            "https://geovoice.ge/sadgamebi-sakidebi/",

            "https://geovoice.ge/bose-products/",

            "https://geovoice.ge/sale/"

        ]

        

    def get_all_category_pages(self):

        """Get all paginated pages for all categories."""

        logger.info("Starting Geovoice category pagination...")

        

        use_flaresolverr = flaresolverr_available()

        if use_flaresolverr:

            logger.info("FlareSolverr available — using it for Cloudflare bypass")

        else:

            logger.info("FlareSolverr not available — falling back to cloudscraper")

        

        all_category_pages = []

        

        for category_url in self.main_categories:

            logger.info(f"Processing category: {category_url}")

            

            # Start with page 1 (the base URL)

            page = 1

            category_pages = []

            

            while True:

                if page == 1:

                    page_url = category_url  # First page is the base URL

                else:

                    page_url = f"{category_url}page-{page}/"

                

                logger.info(f"Testing page {page}: {page_url}")

                

                try:

                    html = None

                    if use_flaresolverr:
                        html = fetch_via_flaresolverr(page_url)

                    if html is None:
                        response = self.session.get(page_url, timeout=10)
                        html = response.text

                    

                    # Check for Cloudflare challenge (blocked page)
                    # Real Cloudflare challenge pages have "Just a moment" in title
                    # and are small (< 10KB). Normal pages may contain
                    # 'challenge-platform' in a script tag but still have full content.
                    if 'Just a moment' in html and len(html) < 10000:
                        logger.error(f"Page {page} returned Cloudflare challenge. Category finished.")
                        break

                    # Check if page has actual content (not empty or error page)
                    if len(html) < 1000:  # Basic content check
                        logger.info(f"Page {page} appears empty. Category finished.")
                        break
                    
                    # Verify page has real product content (not just Cloudflare wrapper)
                    if 'ty-column4' not in html and 'product-title' not in html and page > 1:
                        logger.info(f"Page {page} has no product content. Category finished.")
                        break

                    

                    # Page exists and has content

                    category_pages.append(page_url)

                    logger.info(f"✅ Page {page} is valid")

                    

                    page += 1

                    

                    # Be respectful to the server (randomized delay to avoid blocking)

                    time.sleep(random.uniform(2, 4))

                    

                except requests.RequestException as e:

                    logger.error(f"Error accessing page {page}: {e}")

                    break

                except Exception as e:

                    logger.error(f"Unexpected error on page {page}: {e}")

                    break

            

            logger.info(f"Category {category_url} has {len(category_pages)} pages")

            all_category_pages.extend(category_pages)

        

        logger.info(f"Total category pages collected: {len(all_category_pages)}")

        return all_category_pages

    

    def save_category_pages_to_file(self, pages, filename="geovoice_category_links.txt"):

        """Save all category page links to file."""

        try:

            with open(filename, 'w', encoding='utf-8') as f:

                for page_url in pages:

                    f.write(page_url + '\n')

            logger.info(f"Saved {len(pages)} category page links to {filename}")

            return True

        except Exception as e:

            logger.error(f"Error saving category page links: {e}")

            return False



def main():

    """Main execution for Geovoice category pagination."""

    logger.info("=== Geovoice Category Pagination Started ===")

    

    # Collect all category pages with pagination

    collector = GeovoiceLinkCollector()

    category_pages = collector.get_all_category_pages()

    

    if category_pages:

        if collector.save_category_pages_to_file(category_pages):

            logger.info("✅ All category page links saved successfully!")

            logger.info(f"Ready for product link collection from {len(category_pages)} pages")

        else:

            logger.error("❌ Failed to save category page links!")

    else:

        logger.error("❌ No category page links found!")



if __name__ == "__main__":

    main()