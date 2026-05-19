#!/usr/bin/env python3
"""
Musicroom Data Transformation
Standardizes column names and data types for merging with Acoustic data
"""

import sys
import io
import os
import re
import pandas as pd
from datetime import datetime

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def create_clean_id(unique_id):
    """Create CLEAN_ID from UNIQUE_ID by removing all non-alphanumeric characters."""
    if pd.isna(unique_id):
        return ""
    # Convert to string and remove all non-alphanumeric characters
    clean_id = re.sub(r'[^a-zA-Z0-9]', '', str(unique_id))
    return clean_id

def clean_price(price):
    """Clean PRICE to be a numeric value only."""
    if pd.isna(price):
        return 0
    # Convert to string and remove any non-numeric characters except decimal point
    price_str = str(price)
    # Remove currency symbols and commas
    price_str = re.sub(r'[₾GEL,]', '', price_str)
    # Convert to float, then to int if it's a whole number
    try:
        price_val = float(price_str)
        return int(price_val) if price_val.is_integer() else price_val
    except:
        return 0

def transform_musicroom_data():
    """Transform Musicroom data with standardized column names"""
    
    # File paths (absolute)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(script_dir, "musicroom_results.xlsx")
    output_file = os.path.join(script_dir, "musicroom_cleaned.xlsx")
    
    print(f"🎵 MUSICOOM DATA TRANSFORMATION")
    print(f"Input: {os.path.basename(input_file)}")
    print(f"Output: {os.path.basename(output_file)}")
    print(f"{'='*60}")
    
    # Load data
    try:
        df = pd.read_excel(input_file)
        print(f"✅ Loaded {len(df)} products from Musicroom")
    except Exception as e:
        print(f"❌ Error loading input file: {e}")
        return False
    
    # Ensure required columns exist
    required_columns = ['UNIQUE_ID', 'NAME', 'PRICE', 'STATUS', 'LINK']
    for col in required_columns:
        if col not in df.columns:
            print(f"❌ Missing required column: {col}")
            return False
    
    # Create new dataframe with strict column order
    df_transformed = pd.DataFrame()
    
    # UNIQUE_ID - force to integer to avoid .0 in Excel
    df_transformed['UNIQUE_ID'] = pd.to_numeric(df['UNIQUE_ID'], errors='coerce').fillna(0).astype(int).astype(str)
    
    # NAME
    df_transformed['NAME'] = df['NAME'].astype(str)
    
    # PRICE - clean to numeric
    df_transformed['PRICE'] = df['PRICE'].apply(clean_price)
    
    # STATUS - standardize to 'In Stock' or 'Out of Stock', or keep raw value
    def standardize_status(status):
        if pd.isna(status):
            return 'Out of Stock'
        status_str = str(status).strip().lower()
        if 'unknown' in status_str:
            return 'Out of Stock'
        elif 'instock' in status_str or 'in stock' in status_str or 'მარაგშია' in status_str or 'ხელმისაწვდომი' in status_str:
            return 'In Stock'
        elif 'outstock' in status_str or 'out of stock' in status_str or 'არ არის' in status_str:
            return 'Out of Stock'
        else:
            # Keep the raw value instead of 'Unknown'
            return str(status).strip()
    
    df_transformed['STATUS'] = df['STATUS'].apply(standardize_status)
    
    # LINK
    df_transformed['LINK'] = df['LINK'].astype(str)
    
    # DATE - today's date in YYYY-MM-DD format
    today_date = datetime.now().strftime('%Y-%m-%d')
    df_transformed['DATE'] = today_date
    
    # CLEAN_ID - from UNIQUE_ID, remove all non-alphanumeric characters
    df_transformed['CLEAN_ID'] = df_transformed['UNIQUE_ID'].apply(create_clean_id)
    
    # Remove duplicates based on CLEAN_ID (keep most recent)
    df_transformed = df_transformed.drop_duplicates(subset=['CLEAN_ID'], keep='last')
    
    # Reorder columns to strict order
    column_order = ['UNIQUE_ID', 'NAME', 'PRICE', 'STATUS', 'LINK', 'DATE', 'CLEAN_ID']
    df_transformed = df_transformed[column_order]
    
    # Show sample rows for verification
    print(f"\n📋 Sample transformed data (first 3 rows):")
    sample_df = df_transformed.head(3)
    for idx, row in sample_df.iterrows():
        print(f"   UNIQUE_ID: {row['UNIQUE_ID']:<15} | CLEAN_ID: {row['CLEAN_ID']:<15} | NAME: {row['NAME'][:30]:<30} | PRICE: {row['PRICE']:<8} | STATUS: {row['STATUS']:<12}")
    
    # Calculate statistics
    total_products = len(df_transformed)
    total_price = df_transformed['PRICE'].sum()
    avg_price = df_transformed['PRICE'].mean() if total_products > 0 else 0
    
    stats = {
        'total_products': total_products,
        'total_price': total_price,
        'average_price': avg_price
    }
    
    # Save cleaned data
    try:
        df_transformed.to_excel(output_file, index=False)
        print(f"\n✅ Saved cleaned data to {os.path.basename(output_file)}")
        print(f"📊 Statistics:")
        print(f"   Total Products: {stats['total_products']}")
        print(f"   Total Price: {stats['total_price']}")
        print(f"   Average Price: {stats['average_price']:.2f}")
        print(f"   Columns: {list(df_transformed.columns)}")
        return True
    except PermissionError:
        print(f"❌ PLEASE CLOSE THE EXCEL FILE BEFORE RUNNING!")
        return False
    except Exception as e:
        print(f"❌ Error saving cleaned data: {e}")
        return False

if __name__ == "__main__":
    print(f"🚀 Musicroom Transformation - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    success = transform_musicroom_data()
    
    if success:
        print(f"\n🎉 Musicroom transformation completed successfully!")
    else:
        print(f"\n❌ Musicroom transformation failed!")
    
    sys.exit(0 if success else 1)
