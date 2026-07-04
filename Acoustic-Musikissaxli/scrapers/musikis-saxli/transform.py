#!/usr/bin/env python3
"""
Music Store Data Transformation
Applies store-specific cleaning to extract CLEAN_MODEL column
"""

import os
import sys
import re
import pandas as pd
from datetime import datetime

# Add the 'acms' directory to path so scrapers can still find the cleaner
ACMS_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'acms')
if ACMS_PATH not in sys.path:
    sys.path.append(ACMS_PATH)

from cleaners import MusicInstrumentCleaner

def transform_musikis_data():
    """Transform Music Store data with store-specific cleaning"""
    
    # File paths (absolute)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(script_dir, "music_store_final_stock.xlsx")
    output_file = os.path.join(script_dir, "final_stock_cleaned.xlsx")
    
    print(f"🎵 MUSIC STORE DATA TRANSFORMATION")
    print(f"Input: {os.path.basename(input_file)}")
    print(f"Output: {os.path.basename(output_file)}")
    print(f"{'='*60}")
    
    # Load data
    try:
        df = pd.read_excel(input_file)
        print(f"✅ Loaded {len(df)} products from Music Store")
    except Exception as e:
        print(f"❌ Error loading input file: {e}")
        return False
    
    # Initialize cleaner with Music Store specific adjustments
    cleaner = MusicInstrumentCleaner()
    
    # Add Music Store specific patterns
    cleaner.instrument_patterns.update({
        # Music Store Georgian-specific terms
        r'\b(?:გიტარა|gitara|გიტარა)\b': 'guitar',
        r'\b(?:ფორტეპიანო|piano|ფორტეპიანო)\b': 'piano',
        r'\b(?:დრამ|drum|დრამი)\b': 'drums',
        r'\b(?:საქსოფონ|sax|საქსოფონი)\b': 'saxophone',
        
        # Music Store specific product codes
        r'\b(?:MS|music\s*store|store)\s*\d+': '',
        r'\b(?:item|product|code|sku)\s*[:#]?\s*\w+': '',
        
        # Common Music Store brands to clean
        r'\b(?:marshall|vox|laney|blackstar|orange|bugera)\b': '',  # Amps
        r'\b(?:shure|sennheiser|akai|pioneer|denon)\b': '',  # Audio
        r'\b(?:ernie\s*ball|daddario|elixir|martin|fender)\b': '',  # Strings/Accessories
        
        # Music Store specific descriptors
        r'\b(?:ახალზიანი|akhaliani|new|ახალი|used|მეორე|მეორედ)\b': '',
        r'\b(?:ფასი|fasi|original|ორიგინალი|original)\b': '',
    })
    
    # Apply cleaning
    print("🧹 Applying Music Store specific cleaning...")
    df_cleaned = cleaner.clean_dataframe(df, 'NAME')
    
    # Apply strict numeric filter for Music Store
    print("Apply Music Store strict numeric filter...")
    
    # 1. Create CLEAN_ID column (remove hyphens, dots, spaces, make uppercase)
    def create_clean_id(unique_id):
        if pd.isna(unique_id):
            return ""
        return re.sub(r'[-.\s]', '', str(unique_id).upper())
    
    df_cleaned = df.copy()
    df_cleaned['CLEAN_ID'] = df_cleaned['UNIQUE_ID'].apply(create_clean_id)
    
    # 2. Extract CLEAN_MODEL with strict Letter + Digit rule
    def extract_clean_model(name, clean_id):
        if pd.isna(name):
            return ""
        
        # Split NAME into individual words
        words = str(name).split()
        
        # Unified brand blacklist for both stores
        brand_blacklist = ['Yamaha', 'Ibanez', 'Stagg', 'Alice', 'Istanbul', 'AKG', 'Korg', 'Casio', 'Shelter', 'Harley Benton']
        
        # Pick words that have BOTH letters AND digits and are not blacklisted
        valid_models = []
        for word in words:
            # Remove Georgian characters first
            clean_word = re.sub(r'[\u10D0-\u10F6]+', '', word)
            
            # Check if word contains BOTH at least one letter AND at least one digit
            has_letter = re.search(r'[A-Za-z]', clean_word)
            has_digit = re.search(r'\d', clean_word)
            
            if has_letter and has_digit:
                # Check if word is not a blacklisted brand
                word_lower = clean_word.lower()
                is_blacklisted = any(brand.lower() in word_lower for brand in brand_blacklist)
                
                if not is_blacklisted:
                    valid_models.append(clean_word)
        
        # If no valid models found, return empty
        if not valid_models:
            return ""
        
        # Process each valid model word individually
        processed_models = []
        for model_word in valid_models:
            # Step 2: The Truncator - cut off at hyphen, dot, or slash
            base_model = re.split(r'[-./]', model_word)[0]
            
            # Step 3: Digit-only check - ensure it still has both letters and digits
            has_letter = re.search(r'[A-Za-z]', base_model)
            has_digit = re.search(r'\d', base_model)
            
            if has_letter and has_digit:
                # Step 4: Remove trailing color suffixes (optional)
                base_model = re.sub(r'(BL|NS|BK|WH|RD|GN|GR|OR|PK|PU|TBS|NAT|SB|LG|WK|OPN|CE|D|E|G|GC)$', '', base_model)
                processed_models.append(base_model)
        
        # If no valid models after processing, return empty
        if not processed_models:
            return ""
        
        # Join processed models
        final_model = ''.join(processed_models)
        
        return final_model.strip()
    
    df_cleaned['CLEAN_MODEL'] = df_cleaned.apply(
        lambda row: extract_clean_model(row['NAME'], row['CLEAN_ID']), axis=1
    )
    
    # Add instrument type for reference
    df_cleaned['INSTRUMENT_TYPE'] = df_cleaned['CLEAN_MODEL'].apply(
        lambda x: cleaner.identify_instrument_type(x) if x else "unknown"
    )
    
    # Get cleaning statistics
    stats = cleaner.get_cleaning_stats(df_cleaned)
    
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
    print(f"🚀 Music Store Transformation - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    success = transform_musikis_data()
    
    if success:
        print(f"\n🎉 Music Store transformation completed successfully!")
    else:
        print(f"\n❌ Music Store transformation failed!")
    
    sys.exit(0 if success else 1)
