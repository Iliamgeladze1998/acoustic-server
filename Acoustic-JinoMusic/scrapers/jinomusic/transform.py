#!/usr/bin/env python3
"""Transform raw JinoMusic scraper data into cleaned format for merging."""

import pandas as pd
import os
import re
import sys

INPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "jinomusic_results.xlsx")
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "jinomusic_cleaned.xlsx")


def clean_model_name(name):
    """Normalize product name for matching."""
    if not name or str(name).strip() == "":
        return ""
    text = str(name).strip()
    # Remove common suffixes
    text = re.sub(r'\s*\(copy\)\s*', ' ', text, flags=re.IGNORECASE)
    text = re.sub(r'\s*-\s*copy\s*', ' ', text, flags=re.IGNORECASE)
    # Remove special characters but keep alphanumeric and spaces
    text = re.sub(r'[^\w\s-]', ' ', text)
    # Collapse whitespace
    text = ' '.join(text.split())
    return text.strip()


def extract_brand(name):
    """Try to extract brand from product name."""
    if not name:
        return ""
    text = str(name).strip()
    # Common brands
    brands = [
        "Fender", "Yamaha", "Ibanez", "Gibson", "Epiphone", "Taylor",
        "Martin", "Cordoba", "Takamine", "Alvarez", "Boss", "Roland",
        "Korg", "Casio", "Kawai", "Nord", "Arturia", "Akai", "M-Audio",
        "Focusrite", "PreSonus", "Universal Audio", "Apollo", "Shure",
        "Sennheiser", "AKG", "Rode", "Neumann", "Audio-Technica",
        "Beyerdynamic", "Behringer", "Mackie", "JBL", "KRK", "Pioneer",
        "Denon", "Numark", "Native Instruments", "Ableton", "Propellerhead",
        "Elixir", "D'Addario", "Ernie Ball", "Martin", "Dunlop", "GHS",
        "Savarez", "Hannabach", "Dadarrio", "DR Strings", "GHS Strings",
        "Line 6", "Marshall", "Orange", "Vox", "Blackstar", "Friedman",
        "Mesa Boogie", "Peavey", "Crate", "Randall", "ENGL", "Hughes & Kettner",
        "Laney", "Ashdown", "Ampeg", "Gallien-Krueger", "Hartke", "Trace Elliot",
        "Zildjian", "Sabian", "Meinl", "Paiste", "Istanbul", "Bosphorus",
        "Tama", "Pearl", "Yamaha", "Mapex", "Sonor", "DW", "PDP", "Ludwig",
        "Remo", "Evans", "Aquarian", "Pro-Mark", "Vic Firth", "Regal Tip",
        "Ahead", " Vater", "Wincent", "Ahead", "Gibraltar", "Pacific",
        "Dunlop", "Korg", "Boss", "TC Electronic", "Electro-Harmonix",
        "MXR", "Fulltone", "Strymon", "Eventide", "Walrus Audio",
        "Joyo", "Mooer", "Donner", "Caline", "Mooer", "Rowin",
        "Dolamo", "Irin", "Smiger", "Valencia", "Palatino",
    ]
    for brand in brands:
        if brand.lower() in text.lower():
            return brand
    return ""


def transform_data():
    """Transform raw scraper data into cleaned format."""
    if not os.path.exists(INPUT_FILE):
        print(f"❌ Input file not found: {INPUT_FILE}")
        return False

    print(f"📥 Loading raw data from {INPUT_FILE}")
    df = pd.read_excel(INPUT_FILE)
    print(f"   Loaded {len(df)} products")

    # Clean and normalize
    print("🧹 Cleaning and normalizing data...")

    # Ensure required columns exist
    df["NAME"] = df["NAME"].fillna("").astype(str).str.strip()
    df["PRICE"] = pd.to_numeric(df["PRICE"], errors="coerce").fillna(0)
    df["SKU"] = df["SKU"].fillna("").astype(str).str.strip()
    df["STATUS"] = df["STATUS"].fillna("Unknown").astype(str).str.strip()
    df["URL"] = df["URL"].fillna("").astype(str).str.strip()
    df["CATEGORY"] = df["CATEGORY"].fillna("").astype(str).str.strip()

    # Create cleaned model name
    df["CLEAN_NAME"] = df["NAME"].apply(clean_model_name)

    # Extract brand
    df["BRAND"] = df["NAME"].apply(extract_brand)

    # Create a CLEAN_ID from SKU if available, otherwise from URL slug
    def make_clean_id(row):
        sku = str(row.get("SKU", "")).strip()
        if sku and sku.lower() not in ("", "n/a", "sku:", "none"):
            # Normalize SKU: remove non-alphanumeric
            return re.sub(r'[^a-zA-Z0-9]', '', sku).upper()
        # Fallback: use URL slug
        url = str(row.get("URL", ""))
        slug = url.rstrip("/").split("/")[-1]
        return re.sub(r'[^a-zA-Z0-9]', '', slug).upper()

    df["CLEAN_ID"] = df.apply(make_clean_id, axis=1)

    # Rename columns for consistency with other projects
    df = df.rename(columns={
        "NAME": "NAME",
        "PRICE": "PRICE",
        "URL": "LINK",
    })

    # Select and order columns
    output_cols = ["NAME", "CLEAN_NAME", "BRAND", "CLEAN_ID", "PRICE", "SKU", "STATUS", "CATEGORY", "LINK", "IMAGE", "DESCRIPTION"]
    for col in output_cols:
        if col not in df.columns:
            df[col] = ""

    df = df[output_cols]

    # Remove completely empty rows
    df = df[df["NAME"].str.strip() != ""]

    # Save
    df.to_excel(OUTPUT_FILE, index=False, engine="openpyxl")
    print(f"✅ Saved {len(df)} cleaned products to {OUTPUT_FILE}")

    return True


if __name__ == "__main__":
    transform_data()
