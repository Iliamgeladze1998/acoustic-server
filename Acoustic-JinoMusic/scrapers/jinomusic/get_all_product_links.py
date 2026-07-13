#!/usr/bin/env python3
"""Fetch all product links from all categories on jinomusic.ge/en/."""

import requests
from bs4 import BeautifulSoup
import os
import time
import sys
import re

BASE_URL = "https://jinomusic.ge/en/"
CATEGORY_LINKS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "category_links.txt")
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "all_product_links.txt")

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9",
}

PRODUCT_LINK_PATTERN = re.compile(r'href="(https://jinomusic\.ge/en/product/[^"]+)"')


def get_max_pages(category_url):
    """Determine the maximum number of pages for a category by checking pagination."""
    try:
        response = requests.get(category_url, headers=HEADERS, timeout=30)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"   ⚠️  Failed to fetch {category_url}: {e}")
        return 1

    # Look for pagination links like ?product-page=N
    page_numbers = set()
    for match in re.finditer(r'product-page=(\d+)', response.text):
        page_numbers.add(int(match.group(1)))

    if not page_numbers:
        return 1

    return max(page_numbers)


def get_product_links_from_page(url):
    """Extract product links from a single page."""
    try:
        response = requests.get(url, headers=HEADERS, timeout=30)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"   ⚠️  Failed to fetch {url}: {e}")
        return set()

    links = set()
    for match in PRODUCT_LINK_PATTERN.finditer(response.text):
        link = match.group(1)
        # Clean up any trailing slashes for consistency
        if not link.endswith("/"):
            link = link + "/"
        links.add(link)

    return links


def get_all_product_links():
    """Fetch all product links from all categories, paginating through every page."""
    # Load category links
    if not os.path.exists(CATEGORY_LINKS_FILE):
        print("⚠️  category_links.txt not found. Running get_category_links first...")
        from get_category_links import get_category_links
        get_category_links()

    with open(CATEGORY_LINKS_FILE, "r", encoding="utf-8") as f:
        categories = [line.strip() for line in f if line.strip()]

    print(f"📋 Loaded {len(categories)} categories")

    all_product_links = set()
    total_seen = 0

    for category_url in categories:
        category_name = category_url.rstrip("/").split("/")[-1]
        print(f"\n📂 Processing category: {category_name}")

        # First, determine max pages
        max_pages = get_max_pages(category_url)
        print(f"   📄 Total pages: {max_pages}")

        # Fetch all pages
        for page_num in range(1, max_pages + 1):
            if page_num == 1:
                page_url = category_url
            else:
                # WooCommerce pagination format: /en/guitar/?product-page=2
                page_url = f"{category_url}?product-page={page_num}"

            print(f"   [{page_num}/{max_pages}] Fetching {page_url}")
            page_links = get_product_links_from_page(page_url)

            if not page_links:
                print(f"   ⚠️  No product links found on page {page_num}, stopping this category")
                break

            new_links = page_links - all_product_links
            all_product_links.update(page_links)
            total_seen += len(page_links)
            print(f"   ✅ Found {len(page_links)} products ({len(new_links)} new, {len(all_product_links)} total unique)")

            # Be polite
            time.sleep(0.5)

    # Save all unique product links
    sorted_links = sorted(all_product_links)
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        for link in sorted_links:
            f.write(link + "\n")

    print(f"\n{'='*60}")
    print(f"✅ Total unique product links: {len(sorted_links)}")
    print(f"💾 Saved to {OUTPUT_FILE}")
    print(f"{'='*60}")

    return sorted_links


if __name__ == "__main__":
    get_all_product_links()
