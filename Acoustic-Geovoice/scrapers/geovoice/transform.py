#!/usr/bin/env python3
"""
Geovoice Store Data Transformation
Applies store-specific cleaning to extract CLEAN_MODEL column
Mirrors acoustic/transform.py structure for Geovoice
"""

import os
import sys
import re
import pandas as pd
from datetime import datetime

def transform_geovoice_data():
    """Transform Geovoice Store data with store-specific cleaning"""
    
    # File paths (absolute)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(script_dir, "geovoice_final_stock.xlsx")
    output_file = os.path.join(script_dir, "geovoice_cleaned_models.xlsx")
    
    print(f"🎵 GEOVOICE STORE DATA TRANSFORMATION")
    print(f"Input: {os.path.basename(input_file)}")
    print(f"Output: {os.path.basename(output_file)}")
    print(f"{'='*60}")
    
    # Load data - force UNIQUE_ID to be read as string to preserve leading zeros
    try:
        df = pd.read_excel(input_file, dtype={'UNIQUE_ID': str})
        print(f"✅ Loaded {len(df)} products from Geovoice Store")
    except Exception as e:
        print(f"❌ Error loading input file: {e}")
        return False
    
    # 1. Create CLEAN_ID column from UNIQUE_ID (preserve leading zeros as strings)
    def create_clean_id(unique_id):
        if pd.isna(unique_id):
            return ""
        # Remove only dashes (-), dots (.), and spaces - keep everything else as-is
        # This preserves leading zeros and treats the ID as a string
        cleaned = str(unique_id).replace('-', '').replace('.', '').replace(' ', '')
        return cleaned
    
    df_cleaned = df.copy()
    df_cleaned['CLEAN_ID'] = df_cleaned['UNIQUE_ID'].apply(create_clean_id)
    
    # 2. CLEAN_MODEL comes directly from CLEAN_ID (not from NAME)
    # This preserves the actual product code from the UNIQUE_ID column
    df_cleaned['CLEAN_MODEL'] = df_cleaned['CLEAN_ID']
    
    # 3. Clean NAME column with brand blacklist for display purposes only
    # No model extraction - just clean the product title
    def clean_name(name):
        """Remove blacklisted brands from NAME for display purposes"""
        if pd.isna(name):
            return name
        
        # Unified brand blacklist for both stores
        brand_blacklist = ['Yamaha', 'Ibanez', 'Stagg', 'Alice', 'Istanbul', 'AKG', 'Korg', 'Casio', 'Shelter', 'Harley Benton', 'Bose', 'AdamHall', 'KLOTZ', 'ALESIS', 'Native-instruments']
        
        clean_name = str(name)
        for brand in brand_blacklist:
            # Case-insensitive removal
            clean_name = re.sub(re.escape(brand), '', clean_name, flags=re.IGNORECASE)
        
        # Clean up extra spaces and special characters
        clean_name = re.sub(r'\s+', ' ', clean_name).strip()
        clean_name = re.sub(r'[|,]', '', clean_name)  # Remove pipe and commas
        
        return clean_name
    
    df_cleaned['NAME_CLEAN'] = df_cleaned['NAME'].apply(clean_name)
    
    # Add instrument type for reference
    def identify_instrument_type(model):
        """Simple instrument type identification based on model name"""
        if pd.isna(model) or not model:
            return "unknown"
        
        model_lower = model.lower()
        
        if 'guitar' in model_lower:
            if 'acoustic' in model_lower:
                return 'acoustic guitar'
            elif 'electric' in model_lower:
                return 'electric guitar'
            return 'guitar'
        elif 'ukulele' in model_lower:
            return 'ukulele'
        elif 'mandolin' in model_lower:
            return 'mandolin'
        elif 'banjo' in model_lower:
            return 'banjo'
        elif 'bass' in model_lower:
            return 'bass guitar'
        elif 'drum' in model_lower:
            return 'drums'
        elif 'piano' in model_lower or 'keyboard' in model_lower:
            return 'keyboard/piano'
        elif 'microphone' in model_lower or 'mic' in model_lower:
            return 'microphone'
        elif 'speaker' in model_lower:
            return 'speaker'
        elif 'amplifier' in model_lower or 'amp' in model_lower:
            return 'amplifier'
        elif 'mixer' in model_lower:
            return 'mixer'
        elif 'audio' in model_lower:
            return 'audio equipment'
        
        return "unknown"
    
    df_cleaned['INSTRUMENT_TYPE'] = df_cleaned['CLEAN_MODEL'].apply(identify_instrument_type)
    
    # Refine instrument types for geovoice store
    def refine_geovoice_instrument_type(row):
        """Refine instrument types for geovoice store"""
        model = row['CLEAN_MODEL']
        instrument_type = row['INSTRUMENT_TYPE']
        
        if pd.notna(model) and model:
            model_lower = model.lower()
            
            # More specific geovoice classifications
            if 'acoustic' in model_lower and 'guitar' in model_lower:
                return 'acoustic guitar'
            elif 'electric' in model_lower and 'guitar' in model_lower:
                return 'electric guitar'
            elif 'ukulele' in model_lower:
                return 'ukulele'
            elif 'mandolin' in model_lower:
                return 'mandolin'
            elif 'banjo' in model_lower:
                return 'banjo'
            elif 'dread' in model_lower or 'jumbo' in model_lower:
                return 'acoustic guitar'
        
        return instrument_type
    
    df_cleaned['INSTRUMENT_TYPE'] = df_cleaned.apply(refine_geovoice_instrument_type, axis=1)
    
    # Get cleaning statistics
    total_products = len(df_cleaned)
    successfully_cleaned = len(df_cleaned[df_cleaned['CLEAN_MODEL'] != ''])
    success_rate = f"{(successfully_cleaned / total_products * 100):.1f}%" if total_products > 0 else "0%"
    
    instrument_distribution = df_cleaned['INSTRUMENT_TYPE'].value_counts().to_dict() if total_products > 0 else {}
    
    stats = {
        'total_products': total_products,
        'successfully_cleaned': successfully_cleaned,
        'success_rate': success_rate,
        'instrument_distribution': instrument_distribution
    }
    
    # Show sample rows for verification
    print(f"\n📋 Sample verification (UNIQUE_ID -> CLEAN_ID -> CLEAN_MODEL):")
    sample_df = df_cleaned[['UNIQUE_ID', 'CLEAN_ID', 'CLEAN_MODEL', 'NAME']].head(5)
    for idx, row in sample_df.iterrows():
        print(f"   UNIQUE_ID: '{row['UNIQUE_ID']}' -> CLEAN_ID: '{row['CLEAN_ID']}' -> CLEAN_MODEL: '{row['CLEAN_MODEL']}'")
        print(f"      NAME: {row['NAME'][:60]}")
    
    # Save cleaned data
    try:
        df_cleaned.to_excel(output_file, index=False)
        print(f"✅ Saved cleaned data to {os.path.basename(output_file)}")
        print(f"📊 Cleaning Statistics:")
        print(f"   Total Products: {stats['total_products']}")
        print(f"   Successfully Cleaned: {stats['successfully_cleaned']}")
        print(f"   Success Rate: {stats['success_rate']}")
        print(f"   Instrument Types: {stats['instrument_distribution']}")
        return True
    except Exception as e:
        print(f"❌ Error saving cleaned data: {e}")
        return False

if __name__ == "__main__":
    print(f"🚀 Geovoice Store Transformation - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    success = transform_geovoice_data()
    
    if success:
        print(f"\n🎉 Geovoice Store transformation completed successfully!")
    else:
        print(f"\n❌ Geovoice Store transformation failed!")
    
    sys.exit(0 if success else 1)
