import sys
import io
import asyncio
import os
from urllib.parse import urlparse, urlunparse
from pathlib import Path
from playwright.async_api import async_playwright

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

# Use absolute paths based on script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_FILE = os.path.join(SCRIPT_DIR, "all_category_pages.txt")
OUTPUT_FILE = os.path.join(SCRIPT_DIR, "all_product_links.txt")


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


async def extract_product_links(page, url, max_retries=3):
    """Extract product links from a page with retry logic for Target Closed errors."""
    for attempt in range(max_retries):
        try:
            await page.goto(url, wait_until="domcontentloaded", timeout=90000)
            
            # Extract links only from .product containers to avoid duplicates
            unique_links = set()
            product_containers = await page.locator(".product").all()
            
            for container in product_containers:
                links = await container.locator("a").all()
                for link in links:
                    href = await link.get_attribute("href")
                    if href and "/product/" in href:
                        # Ensure absolute URL
                        if not href.startswith("http"):
                            href = "https://musicroom.ge" + href
                        # Normalize URL before adding to set
                        normalized = normalize_url(href.strip())
                        unique_links.add(normalized)
            
            return list(unique_links)
            
        except Exception as e:
            if "Target closed" in str(e) or attempt < max_retries - 1:
                print(f"  ⚠ Retry {attempt + 1}/{max_retries} for {url}")
                await asyncio.sleep(1)
                continue
            else:
                print(f"  ❌ Error on {url}: {e}")
                return []


async def main():
    output_path = Path(OUTPUT_FILE)
    if output_path.exists():
        output_path.unlink()
        print(f"🗑️ Cleared existing {output_path.name}")

    # Read category page URLs
    input_path = Path(INPUT_FILE)
    try:
        with open(input_path, "r", encoding="utf-8") as f:
            page_urls = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"❌ Input file not found: {INPUT_FILE}")
        raise SystemExit(1)
    
    print(f"📂 Found {len(page_urls)} pages to process")
    
    # Initialize browser
    playwright = await async_playwright().start()
    browser = await playwright.chromium.launch(headless=True)
    context = await browser.new_context(
        user_agent=USER_AGENT,
        viewport={"width": 1920, "height": 1080},
        ignore_https_errors=True
    )
    page = await context.new_page()
    
    # Block only images to speed up loading (keep CSS for rendering)
    await page.route("**/*.{png,jpg,jpeg,gif,webp}", lambda route: route.abort())
    
    all_product_links = set()  # Use set for deduplication across all pages
    
    try:
        for i, page_url in enumerate(page_urls, 1):
            print(f"Processing page {i}/{len(page_urls)}: {page_url}")
            
            product_links = await extract_product_links(page, page_url)
            
            if product_links:
                all_product_links.update(product_links)
                print(f"  ✓ Found {len(product_links)} unique product links on this page (Total unique: {len(all_product_links)})")
                # Debug: show first 3 links
                if len(product_links) > 0:
                    for link in product_links[:3]:
                        print(f"    - {link}")
            else:
                print(f"  ⚠ No product links found (Total unique: {len(all_product_links)})")
    
    finally:
        await page.close()
        await context.close()
        await browser.close()
        await playwright.stop()
    
    # Save results
    if not all_product_links:
        print("❌ No product links found. File not written.")
        raise SystemExit(1)
    
    output_path = Path(__file__).parent / "all_product_links.txt"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Write unique links to file
    with open(output_path, "w", encoding="utf-8") as f:
        for link in sorted(all_product_links):  # Sort for consistent output
            f.write(link + "\n")
            f.flush()
    
    print(f"\n✅ Complete! Found {len(all_product_links)} unique product links")
    print(f"💾 Saved to {output_path}")


if __name__ == "__main__":
    asyncio.run(main())
