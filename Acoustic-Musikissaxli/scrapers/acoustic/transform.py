#!/usr/bin/env python3
"""
Acoustic Store Data Transformation
Applies store-specific cleaning to extract CLEAN_MODEL column
"""

import os
import sys
import re
import pandas as pd
from datetime import datetime

def transform_acoustic_data():
    """Transform Acoustic Store data with store-specific cleaning"""
    
    # File paths (absolute)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(script_dir, "acoustic_final_stock.xlsx")
    output_file = os.path.join(script_dir, "acoustic_cleaned_models.xlsx")
    
    print(f"🎸 ACOUSTIC STORE DATA TRANSFORMATION")
    print(f"Input: {os.path.basename(input_file)}")
    print(f"Output: {os.path.basename(output_file)}")
    print(f"{'='*60}")
    
    # Load data
    try:
        df = pd.read_excel(input_file)
        print(f"✅ Loaded {len(df)} products from Acoustic Store")
    except Exception as e:
        print(f"❌ Error loading input file: {e}")
        return False
    
    # 1. Create CLEAN_ID column (remove everything except letters and numbers)
    def create_clean_id(unique_id):
        if pd.isna(unique_id):
            return ""
        # Remove everything except letters and numbers
        return re.sub(r'[^A-Za-z0-9]', '', str(unique_id).upper())
    
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
    
    # Add instrument type for reference (simplified, no cleaner dependency)
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
    
    # Calculate cleaning statistics
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
    print(f"\n📋 Sample NAME vs CLEAN_MODEL verification:")
    sample_df = df_cleaned[['NAME', 'CLEAN_MODEL', 'CLEAN_ID']].head(10)
    for idx, row in sample_df.iterrows():
        product_name = str(row['NAME']) if pd.notna(row['NAME']) else "No Name"
        print(f"   {product_name[:50]:<50} -> {str(row['CLEAN_MODEL']):<30} (ID: {row['CLEAN_ID']})")
    
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
    print(f"🚀 Acoustic Store Transformation - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    success = transform_acoustic_data()
    
    if success:
        print(f"\n🎉 Acoustic Store transformation completed successfully!")
    else:
        print(f"\n❌ Acoustic Store transformation failed!")
    
    sys.exit(0 if success else 1)