#!/usr/bin/env python3
"""
Largo.ge scraper
Uses WordPress REST API for product list + HTML parsing for prices.
"""

import requests
import re
import json
import time
import os
import pandas as pd
from bs4 import BeautifulSoup
from datetime import datetime

BASE_URL = "https://largo.ge"
API_URL = f"{BASE_URL}/wp-json/wp/v2/product"
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "largo_results.xlsx")

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Referer": "https://largo.ge/",
}


def fetch_all_products():
    """Fetch all products from WordPress REST API."""
    all_products = []
    page = 1
    while True:
        print(f"  Fetching page {page}...")
        resp = requests.get(
            API_URL,
            params={"per_page": 100, "page": page},
            headers=HEADERS,
            timeout=30
        )
        if resp.status_code != 200:
            print(f"  API returned status {resp.status_code}, stopping.")
            break

        data = resp.json()
        if not data:
            break

        for item in data:
            classes = item.get("class_list", [])
            stock_status = "In Stock"
            if "outofstock" in classes:
                stock_status = "Out of Stock"

            product = {
                "name": item.get("title", {}).get("rendered", ""),
                "link": item.get("link", ""),
                "slug": item.get("slug", ""),
                "id": item.get("id", ""),
                "stock_status": stock_status,
                "content": item.get("content", {}).get("rendered", ""),
                "excerpt": item.get("excerpt", {}).get("rendered", ""),
                "product_cat": item.get("product_cat", []),
                "product_brand": item.get("product_brand", []),
            }
            all_products.append(product)

        print(f"  Page {page}: {len(data)} products (total: {len(all_products)})")

        if len(data) < 100:
            break

        page += 1
        time.sleep(1)

    return all_products


def fetch_product_details(url):
    """Fetch product page HTML and extract price, brand, image, category."""
    try:
        resp = requests.get(url, headers=HEADERS, timeout=30)
        if resp.status_code != 200:
            return None

        html = resp.text
        soup = BeautifulSoup(html, "html.parser")

        # Extract price - look for woocommerce price elements
        price = None
        old_price = None

        price_container = soup.find("p", class_="price")
        if price_container:
            # Sale price (ins element) or regular price
            sale_price_el = price_container.find("ins")
            regular_price_el = price_container.find("del")

            if sale_price_el:
                amount_el = sale_price_el.find("span", class_="woocommerce-Price-amount")
                if amount_el:
                    price_text = amount_el.get_text(strip=True).replace("\xa0", "").replace("₾", "").strip()
                    price = float(price_text) if price_text else None
            elif regular_price_el:
                amount_el = regular_price_el.find("span", class_="woocommerce-Price-amount")
                if amount_el:
                    price_text = amount_el.get_text(strip=True).replace("\xa0", "").replace("₾", "").strip()
                    price = float(price_text) if price_text else None
            else:
                amount_el = price_container.find("span", class_="woocommerce-Price-amount")
                if amount_el:
                    price_text = amount_el.get_text(strip=True).replace("\xa0", "").replace("₾", "").strip()
                    price = float(price_text) if price_text else None

            if regular_price_el and sale_price_el:
                old_amount = regular_price_el.find("span", class_="woocommerce-Price-amount")
                if old_amount:
                    old_text = old_amount.get_text(strip=True).replace("\xa0", "").replace("₾", "").strip()
                    old_price = float(old_text) if old_text else None

        # If no price found in price container, try any woocommerce-Price-amount
        if price is None:
            amounts = soup.find_all("span", class_="woocommerce-Price-amount")
            for amt in amounts:
                text = amt.get_text(strip=True).replace("\xa0", "").replace("₾", "").strip()
                try:
                    val = float(text)
                    if val > 20:  # Skip delivery prices (10-20 GEL)
                        price = val
                        break
                except ValueError:
                    continue

        # Extract brand
        brand = ""
        brand_link = soup.find("a", href=re.compile(r"/brand/"))
        if brand_link:
            brand = brand_link.get_text(strip=True)

        # Extract image
        image_url = ""
        img_tag = soup.find("img", class_=re.compile(r"wp-post-image|product-image|attachment"))
        if img_tag:
            image_url = img_tag.get("src", "") or img_tag.get("data-src", "")
        if not image_url:
            og_image = soup.find("meta", property="og:image")
            if og_image:
                image_url = og_image.get("content", "")

        # Extract category from breadcrumb
        category = ""
        breadcrumb = soup.find("nav", class_=re.compile(r"breadcrumb|woocommerce-breadcrumb"))
        if breadcrumb:
            crumbs = breadcrumb.find_all("a")
            if len(crumbs) >= 2:
                category = crumbs[-1].get_text(strip=True)

        # Check stock status from HTML
        stock_div = soup.find("p", class_=re.compile(r"stock|availability"))
        if stock_div:
            stock_text = stock_div.get_text(strip=True).lower()
            if "out" in stock_text or "გაყიდული" in stock_text:
                stock_status = "Out of Stock"
            elif "in" in stock_text or "მარაგში" in stock_text:
                stock_status = "In Stock"

        return {
            "price": price,
            "old_price": old_price,
            "brand": brand,
            "image_url": image_url,
            "category": category,
        }

    except Exception as e:
        print(f"    Error fetching {url}: {e}")
        return None


def scrape_all_products():
    """Main scraping function."""
    print("=" * 60)
    print("LARGO.GE SCRAPER")
    print("=" * 60)

    # Step 1: Fetch all products from API
    print("\nStep 1: Fetching product list from WordPress API...")
    products = fetch_all_products()
    print(f"\nTotal products found: {len(products)}")

    if not products:
        print("No products found! Exiting.")
        return False

    # Step 2: Fetch details (price, brand, image) from each product page
    print(f"\nStep 2: Fetching product details (prices, brands, images)...")
    for i, product in enumerate(products):
        print(f"  [{i+1}/{len(products)}] {product['name']} - {product['link']}")
        details = fetch_product_details(product["link"])
        if details:
            product["price"] = details["price"]
            product["old_price"] = details["old_price"]
            product["brand"] = details["brand"]
            product["image_url"] = details["image_url"]
            product["category"] = details["category"]
        else:
            product["price"] = None
            product["old_price"] = None
            product["brand"] = ""
            product["image_url"] = ""
            product["category"] = ""

        time.sleep(1.0)  # Be polite, avoid blocking

        # Save incrementally every 20 products
        if (i + 1) % 20 == 0:
            save_to_excel(products[:i+1])
            print(f"  💾 Incremental save ({i+1} products)")

    # Step 3: Save to Excel
    print(f"\nStep 3: Saving to {OUTPUT_FILE}...")
    save_to_excel(products)

    print(f"\n✅ Scraping complete! {len(products)} products saved to {OUTPUT_FILE}")
    return True


def save_to_excel(products):
    """Save products list to Excel file."""
    df = pd.DataFrame(products)
    # Reorder columns
    columns = ["name", "brand", "price", "old_price", "stock_status", "category", "link", "image_url", "slug", "id"]
    for col in columns:
        if col not in df.columns:
            df[col] = ""
    df = df[columns]
    df.to_excel(OUTPUT_FILE, index=False, engine="openpyxl")


if __name__ == "__main__":
    success = scrape_all_products()
    exit(0 if success else 1)
