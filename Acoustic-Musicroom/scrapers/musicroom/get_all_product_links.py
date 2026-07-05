import sys
import io
import os
from urllib.parse import urlparse, urlunparse, urljoin
from pathlib import Path
from bs4 import BeautifulSoup
from flaresolverr_helper import flaresolverr_available, fetch_via_flaresolverr

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', write_through=True)

# Use absolute paths based on script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_FILE = os.path.join(SCRIPT_DIR, "all_category_pages.txt")
OUTPUT_FILE = os.path.join(SCRIPT_DIR, "all_product_links.txt")


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


def extract_product_links(html, url):
    """Extract product links from a page."""
    if not html:
        return []
    soup = BeautifulSoup(html, 'html.parser')
    unique_links = set()
    product_containers = soup.select(".product")
    for container in product_containers:
        for a in container.find_all("a", href=True):
            href = a["href"]
            if "/product/" in href:
                href = urljoin(url, href)
                unique_links.add(normalize_url(href.strip()))
    return list(unique_links)


def main():
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

    if not flaresolverr_available():
        print("❌ FlareSolverr not available. Cannot extract product links.")
        raise SystemExit(1)

    all_product_links = set()

    for i, page_url in enumerate(page_urls, 1):
        print(f"Processing page {i}/{len(page_urls)}: {page_url}")
        result = fetch_via_flaresolverr(page_url, return_url=True)
        if result is None:
            print(f"  ⚠ Failed to fetch page (Total unique: {len(all_product_links)})")
            continue
        html, final_url = result

        # Skip pages that were redirected to a different URL (e.g., home page)
        if normalize_url(final_url or page_url) != normalize_url(page_url):
            print(f"  ⚠ Skipped: redirected to {final_url} (Total unique: {len(all_product_links)})")
            continue

        product_links = extract_product_links(html, page_url)

        if product_links:
            all_product_links.update(product_links)
            print(f"  ✓ Found {len(product_links)} unique product links on this page (Total unique: {len(all_product_links)})")
            if len(product_links) > 0:
                for link in product_links[:3]:
                    print(f"    - {link}")
        else:
            print(f"  ⚠ No product links found (Total unique: {len(all_product_links)})")

    # Save results
    if not all_product_links:
        print("❌ No product links found. File not written.")
        raise SystemExit(1)

    output_path = Path(__file__).parent / "all_product_links.txt"
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with open(output_path, "w", encoding="utf-8") as f:
        for link in sorted(all_product_links):
            f.write(link + "\n")
            f.flush()

    print(f"\n✅ Complete! Found {len(all_product_links)} unique product links")
    print(f"💾 Saved to {output_path}")


if __name__ == "__main__":
    main()
