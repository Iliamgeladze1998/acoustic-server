#!/usr/bin/env python3
"""Fetch all product links from all categories on jinomusic.ge/en/ using Camoufox + Tor."""

import os
import time
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from camoufox_fetcher import init_browser, close_browser, fetch_page

BASE_URL = "https://jinomusic.ge/en/"
CATEGORY_LINKS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "category_links.txt")
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "all_product_links.txt")

PRODUCT_LINK_PATTERN = re.compile(r'href="(https://jinomusic\.ge/en/product/[^"]+)"')


def get_max_pages(html_content):
    """Determine the maximum number of pages for a category from its HTML."""
    page_numbers = set()
    for match in re.finditer(r'product-page=(\d+)', html_content):
        page_numbers.add(int(match.group(1)))
    if not page_numbers:
        return 1
    return max(page_numbers)


def get_product_links_from_html(html_content):
    """Extract product links from HTML content."""
    links = set()
    for match in PRODUCT_LINK_PATTERN.finditer(html_content):
        link = match.group(1)
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

    init_browser()

    all_product_links = set()

    for category_url in categories:
        category_name = category_url.rstrip("/").split("/")[-1]
        print(f"\n📂 Processing category: {category_name}")

        # Fetch first page
        print(f"   [1/?] Fetching {category_url}")
        html = fetch_page(category_url)
        if not html:
            print(f"   ❌ Failed to fetch first page of {category_name}, skipping")
            continue

        # Check for JS challenge
        if "One moment" in html or "Just a moment" in html:
            print(f"   ⚠️  JS challenge detected, waiting more...")
            time.sleep(10)
            html = fetch_page(category_url)
            if not html or "One moment" in html:
                print(f"   ❌ Could not pass JS challenge for {category_name}")
                continue

        max_pages = get_max_pages(html)
        print(f"   📄 Total pages: {max_pages}")

        page_links = get_product_links_from_html(html)
        if not page_links:
            print(f"   ⚠️  No product links found on page 1, skipping category")
            continue

        all_product_links.update(page_links)
        print(f"   ✅ Found {len(page_links)} products ({len(all_product_links)} total unique)")

        # Fetch remaining pages
        for page_num in range(2, max_pages + 1):
            page_url = f"{category_url}?product-page={page_num}"
            print(f"   [{page_num}/{max_pages}] Fetching {page_url}")
            html = fetch_page(page_url)

            if not html:
                print(f"   ⚠️  Failed to fetch page {page_num}, stopping this category")
                break

            page_links = get_product_links_from_html(html)
            if not page_links:
                print(f"   ⚠️  No product links found on page {page_num}, stopping this category")
                break

            new_links = page_links - all_product_links
            all_product_links.update(page_links)
            print(f"   ✅ Found {len(page_links)} products ({len(new_links)} new, {len(all_product_links)} total unique)")

    close_browser()

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
