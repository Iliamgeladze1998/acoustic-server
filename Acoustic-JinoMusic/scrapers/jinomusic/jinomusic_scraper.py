#!/usr/bin/env python3
"""Scrape individual product pages from jinomusic.ge/en/."""

import requests
from bs4 import BeautifulSoup
import json
import os
import time
import re
import sys
import pandas as pd
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE_URL = "https://jinomusic.ge/en/"
PRODUCT_LINKS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "all_product_links.txt")
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "jinomusic_results.xlsx")

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9",
}

MAX_WORKERS = 5
REQUEST_DELAY = 0.3


def parse_price(price_str):
    """Parse price string to float, return 0.0 if invalid."""
    if not price_str:
        return 0.0
    try:
        cleaned = re.sub(r'[^\d.]', '', str(price_str).strip())
        return float(cleaned) if cleaned else 0.0
    except (ValueError, TypeError):
        return 0.0


def extract_json_ld(soup):
    """Extract product data from JSON-LD schema.org markup."""
    scripts = soup.find_all("script", type="application/ld+json")
    for script in scripts:
        try:
            data = json.loads(script.string)
            if isinstance(data, dict) and data.get("@type") == "Product":
                return data
        except (json.JSONDecodeError, TypeError):
            continue
    return None


def scrape_product(url, index, total):
    """Scrape a single product page and return product data dict."""
    try:
        response = requests.get(url, headers=HEADERS, timeout=30)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"[{index}/{total}] ⚠️  Failed to fetch {url}: {e}")
        return None

    soup = BeautifulSoup(response.text, "html.parser")

    # Try JSON-LD first (most reliable)
    json_ld = extract_json_ld(soup)

    name = ""
    price = 0.0
    sku = ""
    availability = ""
    image_url = ""

    if json_ld:
        name = json_ld.get("name", "")
        image_url = json_ld.get("image", "")

        offers = json_ld.get("offers", [])
        if isinstance(offers, list) and offers:
            offer = offers[0]
            price = parse_price(offer.get("price", 0))
            avail = offer.get("availability", "")
            if "OutOfStock" in avail:
                availability = "Out of Stock"
            elif "InStock" in avail:
                availability = "In Stock"
            else:
                availability = "Unknown"
        elif isinstance(offers, dict):
            price = parse_price(offers.get("price", 0))
            avail = offers.get("availability", "")
            if "OutOfStock" in avail:
                availability = "Out of Stock"
            elif "InStock" in avail:
                availability = "In Stock"
            else:
                availability = "Unknown"

        sku_raw = json_ld.get("sku", "")
        if sku_raw and str(sku_raw).strip() not in ("", "SKU: "):
            sku = str(sku_raw).strip()

    # Fallback: extract from HTML if JSON-LD failed
    if not name:
        title_tag = soup.find("title")
        if title_tag:
            name = title_tag.text.replace(" | Jino Music", "").strip()

    if price == 0.0:
        price_tag = soup.find("span", class_="woocommerce-Price-amount")
        if price_tag:
            price = parse_price(price_tag.get_text())

    if not availability:
        stock_tag = soup.find("p", class_="stock")
        if stock_tag:
            avail_text = stock_tag.get_text(strip=True).lower()
            if "out" in avail_text:
                availability = "Out of Stock"
            elif "in" in avail_text:
                availability = "In Stock"
            else:
                availability = "Unknown"
        else:
            # Check for add to cart button
            cart_btn = soup.find("button", class_=re.compile("add-to-cart|single_add_to_cart_button"))
            if cart_btn:
                availability = "In Stock"
            else:
                availability = "Unknown"

    if not sku:
        sku_tag = soup.find("span", class_="sku")
        if sku_tag:
            sku_text = sku_tag.get_text(strip=True)
            if sku_text and sku_text.lower() not in ("n/a", "sku:", ""):
                sku = sku_text

    # Get category from breadcrumb
    category = ""
    breadcrumb = soup.find("nav", class_="woocommerce-breadcrumb")
    if breadcrumb:
        crumbs = breadcrumb.get_text(separator="|").split("|")
        if len(crumbs) >= 2:
            category = crumbs[1].strip()

    # Get product description
    description = ""
    desc_div = soup.find("div", class_=re.compile("woocommerce-product-details__short-description|product-details"))
    if desc_div:
        description = desc_div.get_text(strip=True)[:500]

    product_data = {
        "NAME": name,
        "PRICE": price,
        "SKU": sku,
        "STATUS": availability,
        "CATEGORY": category,
        "URL": url,
        "IMAGE": image_url,
        "DESCRIPTION": description,
    }

    status_icon = "✅" if availability == "In Stock" else "❌"
    print(f"[{index}/{total}] {status_icon} {name[:50]} | {price}₾ | {availability}")

    return product_data


def scrape_all_products():
    """Scrape all products from the product links file."""
    # Load product links
    if not os.path.exists(PRODUCT_LINKS_FILE):
        print("⚠️  all_product_links.txt not found. Running get_all_product_links first...")
        from get_all_product_links import get_all_product_links
        get_all_product_links()

    with open(PRODUCT_LINKS_FILE, "r", encoding="utf-8") as f:
        product_links = [line.strip() for line in f if line.strip()]

    total = len(product_links)
    print(f"\n🚀 Starting to scrape {total} products from jinomusic.ge")
    print(f"   Workers: {MAX_WORKERS} | Delay: {REQUEST_DELAY}s")
    print(f"{'='*60}")

    all_products = []
    failed = 0

    # Use ThreadPoolExecutor for parallel scraping
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        future_to_url = {
            executor.submit(scrape_product, url, i + 1, total): url
            for i, url in enumerate(product_links)
        }

        for future in as_completed(future_to_url):
            result = future.result()
            if result:
                all_products.append(result)
            else:
                failed += 1

    print(f"\n{'='*60}")
    print(f"✅ Scraped {len(all_products)} products successfully")
    if failed:
        print(f"⚠️  Failed to scrape {failed} products")
    print(f"{'='*60}")

    # Save to Excel
    if all_products:
        df = pd.DataFrame(all_products)
        df.to_excel(OUTPUT_FILE, index=False, engine="openpyxl")
        print(f"💾 Saved to {OUTPUT_FILE}")
    else:
        print("⚠️  No products to save!")
        return False

    return True


if __name__ == "__main__":
    scrape_all_products()
