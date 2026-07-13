#!/usr/bin/env python3
"""Runner script for JinoMusic scraper pipeline: categories → links → scrape → transform."""

import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def main():
    print("=" * 60)
    print("JinoMusic Scraper Pipeline")
    print("=" * 60)

    # Step 1: Get category links
    print("\n📂 Step 1: Fetching category links...")
    from get_category_links import get_category_links
    categories = get_category_links()
    if not categories:
        print("❌ Failed to get category links!")
        return False

    # Step 2: Get all product links
    print("\n📋 Step 2: Fetching all product links...")
    from get_all_product_links import get_all_product_links
    product_links = get_all_product_links()
    if not product_links:
        print("❌ Failed to get product links!")
        return False

    # Step 3: Scrape all products
    print("\n🚀 Step 3: Scraping all products...")
    from jinomusic_scraper import scrape_all_products
    success = scrape_all_products()
    if not success:
        print("❌ Scraping failed!")
        return False

    # Step 4: Transform data
    print("\n🧹 Step 4: Transforming data...")
    from transform import transform_data
    success = transform_data()
    if not success:
        print("❌ Transform failed!")
        return False

    print("\n" + "=" * 60)
    print("✅ JinoMusic scraper pipeline completed successfully!")
    print("=" * 60)
    return True


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
