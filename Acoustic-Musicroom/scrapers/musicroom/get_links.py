import sys
import io
from pathlib import Path
from bs4 import BeautifulSoup
from flaresolverr_helper import flaresolverr_available, fetch_via_flaresolverr

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', write_through=True)

BASE_URL = "https://musicroom.ge/"

# Known category slugs on musicroom.ge
FALLBACK_CATEGORIES = [
    "https://musicroom.ge/products/gitara/",
    "https://musicroom.ge/products/klavishi/",
    "https://musicroom.ge/products/dasartkami/",
    "https://musicroom.ge/products/audio/",
    "https://musicroom.ge/products/ganateba/",
    "https://musicroom.ge/products/dj-studia/",
    "https://musicroom.ge/products/saorkestro/",
]

TARGET_CATEGORIES = {
    "გიტარა",
    "დასარტყამი",
    "აუდიო",
    "განათება",
    "DJ & სტუდია",
    "საორკესტრო",
}

# Partial match keywords for keyboard instruments
KEYWORD_MATCHES = ["კლავიშ", "klavish"]


def fetch_category_links():
    if not flaresolverr_available():
        print("⚠ FlareSolverr not available. Using fallback categories.")
        return FALLBACK_CATEGORIES

    html = fetch_via_flaresolverr(BASE_URL)
    if not html:
        print("⚠ FlareSolverr returned empty. Using fallback categories.")
        return FALLBACK_CATEGORIES

    soup = BeautifulSoup(html, 'html.parser')
    category_urls = {}

    # Look for the product menu (Woodmart theme)
    menu = soup.select_one("ul.menu-product-menu")
    if menu:
        links = menu.select("a.woodmart-nav-link")
    else:
        links = soup.select("a.woodmart-nav-link")

    for link in links:
        text = link.get_text(strip=True)
        href = link.get("href")
        if not href:
            continue

        # Check for exact match
        if text.strip() in TARGET_CATEGORIES and text.strip() not in category_urls:
            if not href.startswith("http"):
                href = BASE_URL.rstrip("/") + href
            category_urls[text.strip()] = href.strip()

        # Check for partial match for keyboard instruments
        for keyword in KEYWORD_MATCHES:
            if keyword.lower() in text.lower() and "კლავიშებიანი ინსტრუმენტები" not in category_urls:
                if not href.startswith("http"):
                    href = BASE_URL.rstrip("/") + href
                category_urls["კლავიშებიანი ინსტრუმენტები"] = href.strip()

    if not category_urls:
        print("⚠ No category links found in HTML. Using fallback categories.")
        return FALLBACK_CATEGORIES

    return list(category_urls.values())


def main():
    # Clear previous run's output before fetching so stale links cannot survive.
    output_file = Path(__file__).parent / "get_main_category_links.txt"
    if output_file.exists():
        output_file.unlink()

    urls = fetch_category_links()

    # Check for empty list before opening file
    if not urls:
        print("❌ No category links found. File not written.")
        raise SystemExit(1)

    with open(output_file, "w", encoding="utf-8") as f:
        for url in urls:
            f.write(url + "\n")
            f.flush()  # Immediate flush

    print(f"Extracted {len(urls)} category links to {output_file}")
    for url in urls:
        print(f"  {url}")


if __name__ == "__main__":
    main()