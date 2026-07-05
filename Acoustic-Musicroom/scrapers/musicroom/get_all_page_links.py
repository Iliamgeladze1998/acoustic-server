import sys
import io
import time
import hashlib
import os
from urllib.parse import urlparse, urlunparse
from pathlib import Path
from bs4 import BeautifulSoup
from flaresolverr_helper import flaresolverr_available, fetch_via_flaresolverr

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', write_through=True)

# Use absolute paths based on script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CATEGORY_FILE = os.path.join(SCRIPT_DIR, "get_main_category_links.txt")
OUTPUT_FILE = os.path.join(SCRIPT_DIR, "all_category_pages.txt")


def normalize_url(url: str) -> str:
    """Normalize URL to prevent double-counting by removing query params and trailing slashes."""
    parsed = urlparse(url)
    normalized = urlunparse((
        parsed.scheme,
        parsed.netloc,
        parsed.path.rstrip('/'),
        '',
        '',
        ''
    ))
    return normalized


class PageLinkScraper:
    def __init__(self):
        self.all_pages: list = []

    def check_page(self, url: str, base_url: str, category_name: str, page_num: int) -> tuple:
        """Check if a page exists. Returns (is_valid, content_hash, redirect_info, product_count)."""
        if not flaresolverr_available():
            print(f"❌ FlareSolverr not available for {url}")
            return (False, None, "FlareSolverr not available", 0)

        result = fetch_via_flaresolverr(url, return_url=True)
        if result is None:
            return (False, None, "FlareSolverr failed", 0)
        html, final_url = result
        if html is None:
            return (False, None, "FlareSolverr failed", 0)

        # Detect redirects to a different page (e.g., invalid pagination -> home page)
        requested_path = normalize_url(url).rstrip('/')
        final_path = normalize_url(final_url).rstrip('/') if final_url else requested_path
        if final_path != requested_path:
            if page_num == 1:
                # Page 1 may redirect to a clean canonical URL for the same category; accept that.
                if final_path == base_url.rstrip('/'):
                    pass
                else:
                    return (False, None, f"redirected to {final_url}", 0)
            else:
                return (False, None, f"redirected to {final_url}", 0)

        soup = BeautifulSoup(html, 'html.parser')
        content_hash = hashlib.md5(html.encode()).hexdigest()

        # Check for empty product grid
        if "პროდუქცია ვერ მოიძებნა" in html:
            return (False, None, "no products found", 0)

        product_links = set()
        for container in soup.select(".product"):
            for a in container.find_all("a", href=True):
                href = a["href"]
                if "/product/" in href:
                    product_links.add(normalize_url(href))

        product_count = len(product_links)

        # Special handling for page 1: redirect to base URL is OK
        if page_num == 1:
            return (True, content_hash, "redirected to base (valid for page 1)", product_count)

        # For page 2 onwards: if no products and no pagination, page doesn't exist
        if product_count == 0:
            return (False, None, "no products found", 0)

        return (True, content_hash, "valid", product_count)

    def scrape_category_pages(self, category_url: str, category_name: str):
        """Scrape all pages for a category."""
        base_url = normalize_url(category_url.rstrip("/"))
        previous_hash = None
        consecutive_empty_pages = 0
        category_pages = set()

        print(f"\n{'='*60}")
        print(f"Processing category: {category_name}")
        print(f"{'='*60}")

        # First, check the base URL (page 1)
        print(f"🔍 Checking {category_name} Page 1: {base_url}")
        is_valid, content_hash, info, product_count = self.check_page(base_url, base_url, category_name, 1)

        if not is_valid:
            print(f"❌ {category_name} Page 1: {info}, finished!")
            return

        category_pages.add(base_url)
        print(f"✅ {category_name} Page 1: {info} ({product_count} unique products)")
        previous_hash = content_hash

        # Now check page/2/, page/3/, etc
        page = 2
        while True:
            time.sleep(0.5)
            page_url = f"{base_url}/page/{page}/"
            print(f"🔍 Checking {category_name} Page {page}: {page_url}")

            is_valid, content_hash, info, product_count = self.check_page(page_url, base_url, category_name, page)

            if not is_valid:
                print(f"✅ {category_name} Page {page}: {info}, moving to next category")
                break

            # Content guard: if hash matches previous, we're on the last page repeating
            if content_hash == previous_hash:
                print(f"✅ {category_name} Page {page}: identical content (last page reached)")
                break

            # Consecutive empty page counter
            if product_count == 0:
                consecutive_empty_pages += 1
                print(f"⚠ {category_name} Page {page}: empty (consecutive empty: {consecutive_empty_pages}/3)")
                if consecutive_empty_pages >= 3:
                    print(f"✅ {category_name}: 3 consecutive empty pages reached, stopping")
                    break
                page += 1
                continue

            consecutive_empty_pages = 0
            normalized_url = normalize_url(page_url)
            category_pages.add(normalized_url)
            print(f"✅ {category_name} Page {page}: valid ({product_count} unique products)")
            previous_hash = content_hash
            page += 1

        self.all_pages.extend(list(category_pages))
        print(f"📊 {category_name}: Found {len(category_pages)} unique page URLs")

    def run(self):
        output_path = Path(__file__).parent / "all_category_pages.txt"
        if output_path.exists():
            output_path.unlink()

        # Read category URLs
        try:
            with open(CATEGORY_FILE, "r", encoding="utf-8") as f:
                category_urls = [line.strip() for line in f if line.strip()]
        except FileNotFoundError:
            print(f"❌ Category file not found: {CATEGORY_FILE}")
            raise SystemExit(1)

        print(f"📂 Found {len(category_urls)} categories to check")

        if not flaresolverr_available():
            print("❌ FlareSolverr not available. Cannot check category pages.")
            raise SystemExit(1)

        # Process categories sequentially
        for category_url in category_urls:
            category_name = category_url.rstrip("/").split("/")[-1]
            self.scrape_category_pages(category_url, category_name)

        # Check for empty list before saving
        if not self.all_pages:
            print("❌ No valid pages found. File not written.")
            raise SystemExit(1)

        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            for page_url in self.all_pages:
                f.write(page_url + "\n")
                f.flush()

        print(f"\n{'='*60}")
        print(f"✅ Complete! Found {len(self.all_pages)} valid pages")
        print(f"💾 Saved to {output_path}")
        print(f"{'='*60}")


def main():
    scraper = PageLinkScraper()
    scraper.run()


if __name__ == "__main__":
    main()
