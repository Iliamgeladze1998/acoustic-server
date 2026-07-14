#!/usr/bin/env python3
"""
Transform Largo scraped data into clean format for merging.
"""

import os
import pandas as pd
from datetime import datetime

INPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "largo_results.xlsx")
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "largo_cleaned.xlsx")


def transform_data():
    if not os.path.exists(INPUT_FILE):
        print(f"ERROR: Input file not found: {INPUT_FILE}")
        return False

    df = pd.read_excel(INPUT_FILE, engine="openpyxl")
    print(f"Loaded {len(df)} products from {INPUT_FILE}")

    # Rename columns to match merger expectations
    df_clean = pd.DataFrame()
    df_clean["Product_Name"] = df["name"].astype(str).str.strip()
    df_clean["Brand"] = df["brand"].astype(str).str.strip()
    df_clean["Price"] = df["price"].apply(lambda x: float(x) if pd.notna(x) and x != "" else 0)
    df_clean["Old_Price"] = df["old_price"].apply(lambda x: float(x) if pd.notna(x) and x != "" else 0)
    df_clean["Availability"] = df["stock_status"].astype(str).str.strip()
    df_clean["Category"] = df["category"].astype(str).str.strip()
    df_clean["Link"] = df["link"].astype(str).str.strip()
    df_clean["Image_URL"] = df["image_url"].astype(str).str.strip()
    df_clean["SKU"] = df["slug"].astype(str).str.strip()

    # Add timestamp
    df_clean["Scraped_At"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Remove products without names
    df_clean = df_clean[df_clean["Product_Name"].notna() & (df_clean["Product_Name"] != "") & (df_clean["Product_Name"] != "nan")]

    # Sort by name
    df_clean = df_clean.sort_values("Product_Name").reset_index(drop=True)

    df_clean.to_excel(OUTPUT_FILE, index=False, engine="openpyxl")
    print(f"✅ Transformed {len(df_clean)} products saved to {OUTPUT_FILE}")
    return True


if __name__ == "__main__":
    success = transform_data()
    exit(0 if success else 1)
