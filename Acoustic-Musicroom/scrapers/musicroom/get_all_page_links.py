import asyncio
import random
import hashlib
import os
from urllib.parse import urlparse, urlunparse
from pathlib import Path
from playwright.async_api import async_playwright

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

# Use absolute paths based on script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CATEGORY_FILE = os.path.join(SCRIPT_DIR, "get_main_category_links.txt")
OUTPUT_FILE = os.path.join(SCRIPT_DIR, "all_category_pages.txt")


def normalize_url(url: str) -> str:
    """Normalize URL to prevent double-counting by removing query params and trailing slashes."""
    parsed = urlparse(url)
    # Remove query parameters and fragment, normalize path
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
        self.semaphore = asyncio.Semaphore(3)
        self.all_pages: list = []
        self.playwright = None
        self.browser = None
        self.context = None

    async def init_browser(self):
        self.playwright = await async_playwright().start()
        self.browser = await self.playwright.chromium.launch(headless=True)
        self.context = await self.browser.new_context(
            user_agent=USER_AGENT,
            viewport={"width": 1920, "height": 1080},
            ignore_https_errors=True
        )

    async def close_browser(self):
        if self.context:
            await self.context.close()
        if self.browser:
            await self.browser.close()
        if self.playwright:
            await self.playwright.stop()

    async def check_page(self, url: str, base_url: str, category_name: str, page_num: int, max_retries=3) -> tuple:
        """Check if a page exists. Returns (is_valid, content_hash, redirect_info, product_count)."""
        for attempt in range(max_retries):
            async with self.semaphore:
                page = await self.context.new_page()
                # Block only images to speed up loading (keep CSS for rendering)
                await page.route("**/*.{png,jpg,jpeg,gif,webp}", lambda route: route.abort())
                try:
                    await page.goto(url, wait_until="domcontentloaded", timeout=90000)
                    
                    # Wait for products to render
                    await asyncio.sleep(2)
                    
                    # Wait for products to load
                    try:
                        await page.wait_for_selector(".product, .product-item, .product-grid-item, div[class*='product'], .wd-product", timeout=10000)
                    except:
                        pass  # Continue even if selector not found
                    
                    # Check for redirect using page.url
                    actual_url = normalize_url(page.url)
                    
                    # If redirected to main domain without /products/, page doesn't exist
                    if "musicroom.ge" in actual_url and "/products/" not in actual_url:
                        await page.close()
                        return (False, None, "redirected to main domain", 0)
                    
                    # Special handling for page 1: redirect to base URL is OK
                    if page_num == 1:
                        # Page 1 redirecting to base URL is valid
                        if actual_url == base_url:
                            content = await page.content()
                            content_hash = hashlib.md5(content.encode()).hexdigest()
                            # Extract unique product links for page 1 with immediate normalization
                            unique_links = set()
                            links = await page.locator(".product a").all()
                            for link in links:
                                href = await link.get_attribute("href")
                                if href and "/product/" in href:
                                    unique_links.add(normalize_url(href))
                            product_count = len(unique_links)
                            await page.close()
                            return (True, content_hash, "redirected to base (valid for page 1)", product_count)
                    
                    # For page 2 onwards: redirect to base URL means stop
                    if page_num >= 2:
                        if "/page/" in url and "/page/" not in actual_url:
                            await page.close()
                            return (False, None, "redirected to base URL", 0)
                        if actual_url == base_url:
                            await page.close()
                            return (False, None, "redirected to base URL", 0)
                    
                    # Get content for hash comparison and empty check
                    content = await page.content()
                    content_hash = hashlib.md5(content.encode()).hexdigest()
                    
                    # Check for empty product grid or "პროდუქცია ვერ მოიძებნა"
                    if "პროდუქცია ვერ მოიძებნა" in content:
                        await page.close()
                        return (False, None, "no products found", 0)
                    
                    # Extract unique product links with immediate normalization
                    unique_links = set()
                    links = await page.locator(".product a").all()
                    for link in links:
                        href = await link.get_attribute("href")
                        if href and "/product/" in href:
                            unique_links.add(normalize_url(href))
                    product_count = len(unique_links)
                    
                    await page.close()
                    return (True, content_hash, "valid", product_count)
                    
                except Exception as e:
                    if attempt < max_retries - 1:
                        print(f"⚠ Retry {attempt + 1}/{max_retries} for {url}: {e}")
                        await asyncio.sleep(1)
                        continue
                    else:
                        print(f"❌ Error checking {url}: {e}")
                        await page.close()
                        return (False, None, f"error: {e}", 0)

    async def scrape_category_pages(self, category_url: str, category_name: str):
        """Scrape all pages for a category."""
        base_url = normalize_url(category_url.rstrip("/"))
        previous_hash = None
        consecutive_empty_pages = 0
        category_pages = set()  # Use set to ensure uniqueness
        
        print(f"\n{'='*60}")
        print(f"Processing category: {category_name}")
        print(f"{'='*60}")
        
        # First, check the base URL (page 1)
        print(f"🔍 Checking {category_name} Page 1: {base_url}")
        is_valid, content_hash, info, product_count = await self.check_page(base_url, base_url, category_name, 1)
        
        if not is_valid:
            print(f"❌ {category_name} Page 1: {info}, finished!")
            return
        
        category_pages.add(base_url)
        print(f"✅ {category_name} Page 1: {info} ({product_count} unique products)")
        previous_hash = content_hash
        
        # Now check page/2/, page/3/, etc (skip page/1/ to avoid double-counting)
        page = 2
        while True:
            await asyncio.sleep(0.5)
            
            page_url = f"{base_url}/page/{page}/"
            print(f"🔍 Checking {category_name} Page {page}: {page_url}")
            
            is_valid, content_hash, info, product_count = await self.check_page(page_url, base_url, category_name, page)
            
            if not is_valid:
                print(f"✅ {category_name} Page {page}: {info}, moving to next category")
                break
            
            # Content guard: if hash matches previous, we're on the last page repeating
            if content_hash == previous_hash:
                print(f"✅ {category_name} Page {page}: identical content (last page reached)")
                break
            
            # Consecutive empty page counter: stop after 3 consecutive empty pages
            if product_count == 0:
                consecutive_empty_pages += 1
                print(f"⚠ {category_name} Page {page}: empty (consecutive empty: {consecutive_empty_pages}/3)")
                if consecutive_empty_pages >= 3:
                    print(f"✅ {category_name}: 3 consecutive empty pages reached, stopping")
                    break
            else:
                consecutive_empty_pages = 0  # Reset counter if page has products
            
            normalized_url = normalize_url(page_url)
            category_pages.add(normalized_url)
            print(f"✅ {category_name} Page {page}: valid ({product_count} unique products)")
            previous_hash = content_hash
            page += 1
        
        # Add all unique pages for this category to the master list
        self.all_pages.extend(list(category_pages))
        print(f"📊 {category_name}: Found {len(category_pages)} unique page URLs")

    async def run(self):
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
        
        # Initialize browser
        await self.init_browser()
        
        try:
            # Process categories sequentially (one by one)
            for category_url in category_urls:
                # Extract category name from URL for logging
                category_name = category_url.rstrip("/").split("/")[-1]
                await self.scrape_category_pages(category_url, category_name)
        finally:
            # Close browser
            await self.close_browser()
        
        # Check for empty list before saving
        if not self.all_pages:
            print("❌ No valid pages found. File not written.")
            raise SystemExit(1)
        
        # Save results with strict pathing
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_path, "w", encoding="utf-8") as f:
            for page_url in self.all_pages:
                f.write(page_url + "\n")
                f.flush()
        
        print(f"\n{'='*60}")
        print(f"✅ Complete! Found {len(self.all_pages)} valid pages")
        print(f"💾 Saved to {output_path}")
        print(f"{'='*60}")


async def main():
    scraper = PageLinkScraper()
    await scraper.run()


if __name__ == "__main__":
    asyncio.run(main())
