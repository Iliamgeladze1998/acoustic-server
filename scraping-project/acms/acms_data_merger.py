#!/usr/bin/env python3
"""
Data Merger for Music Store Price Comparison
Combines cleaned data from both stores and creates price comparison report
"""

import os
import sys
import pandas as pd
import json
from datetime import datetime
from fuzzywuzzy import fuzz, process

def load_blacklist():
    """Load blacklisted pairs from JSON file"""
    blacklist_file = os.path.join(os.path.dirname(__file__), 'data', 'blacklist.json')
    
    if not os.path.exists(blacklist_file):
        return []
    
    try:
        with open(blacklist_file, 'r', encoding='utf-8') as f:
            return json.load(f)
    except:
        return []

def is_pair_blacklisted(link_ac, link_ms, blacklist):
    """Check if a pair of links is blacklisted"""
    return any(
        item["link_ac"] == link_ac and item["link_ms"] == link_ms 
        for item in blacklist
    )

def is_valid_model_for_matching(model):
    """Reject model strings that are too short, purely numeric, or generic power ratings."""
    if not model or not model.strip():
        return False
    model = model.strip()
    # Reject strings shorter than 4 characters
    if len(model) < 4:
        return False
    # Reject purely numeric strings (e.g. '1500', '2000')
    if model.isdigit():
        return False
    # Reject generic power-rating patterns like '1500W', '1000W', '2000w'
    import re
    if re.fullmatch(r'\d+\s*[Ww]', model):
        return False
    # Reject single letter + 1-2 digits (e.g. 'C1', 'D1', 'F10')
    if re.fullmatch(r'[A-Za-z]\d{1,2}', model):
        return False
    # Reject strings that are just a few digits followed by a single letter (e.g. '107F')
    if re.fullmatch(r'\d{1,3}[A-Za-z]', model):
        return False
    return True

def merge_store_data():
    """Merge cleaned data from both stores and create price comparison"""
    
    print("=== MUSIC STORE DATA MERGER ===")
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Load blacklist for filtering
    print("\n0. Loading blacklist...")
    blacklist = load_blacklist()
    print(f"   Loaded {len(blacklist)} blacklisted pairs")
    
    # Load cleaned data from both stores
    print("\n1. Loading cleaned data...")
    
    # Load Acoustic Store data
    acoustic_file = os.path.join(os.path.dirname(__file__), '..', 'scrapers', 'acoustic', 'acoustic_cleaned_models.xlsx')
    df_acoustic = pd.read_excel(acoustic_file)
    print(f"   Loaded {len(df_acoustic)} products from Acoustic Store")
    
    # Load Music Store data
    music_file = os.path.join(os.path.dirname(__file__), '..', 'scrapers', 'musikis-saxli', 'final_stock_cleaned.xlsx')
    df_music = pd.read_excel(music_file)
    print(f"   Loaded {len(df_music)} products from Music Store")
    
    # Step 1: ID Matching (100% matches)
    print("\n2. Performing ID matching...")
    
    # Create sets for ID matching
    acoustic_ids = set(df_acoustic['CLEAN_ID'].dropna())
    music_ids = set(df_music['CLEAN_ID'].dropna())
    
    # Find common IDs
    common_ids = acoustic_ids.intersection(music_ids)
    print(f"   Found {len(common_ids)} ID matches")
    
    # Filter data for ID matches
    acoustic_id_matches = df_acoustic[df_acoustic['CLEAN_ID'].isin(common_ids)].copy()
    music_id_matches = df_music[df_music['CLEAN_ID'].isin(common_ids)].copy()
    
    # Merge on CLEAN_ID for ID matches
    id_matches = pd.merge(
        acoustic_id_matches,
        music_id_matches,
        on='CLEAN_ID',
        suffixes=('_AC', '_MS'),
        how='inner'
    )
    
    # Add match type
    id_matches['match_type'] = 'ID'
    id_matches['identifier'] = id_matches['CLEAN_ID']
    
    # Filter out blacklisted pairs from ID matches
    if blacklist:
        print(f"   Filtering {len(id_matches)} ID matches against blacklist...")
        original_count = len(id_matches)
        
        # Filter out blacklisted pairs
        id_matches = id_matches[~id_matches.apply(
            lambda row: is_pair_blacklisted(
                row.get('LINK_AC', ''), 
                row.get('LINK_MS', ''), 
                blacklist
            ), axis=1
        )]
        
        filtered_count = original_count - len(id_matches)
        if filtered_count > 0:
            print(f"   Filtered out {filtered_count} blacklisted ID matches")
    
    print(f"   Created {len(id_matches)} ID matches")
    
    # Step 2: Model Matching (for remaining products)
    print("\n3. Performing model matching...")
    
    # Get remaining products (those not matched by ID)
    acoustic_remaining = df_acoustic[~df_acoustic['CLEAN_ID'].isin(common_ids)].copy()
    music_remaining = df_music[~df_music['CLEAN_ID'].isin(common_ids)].copy()
    
    print(f"   Remaining products: {len(acoustic_remaining)} from Acoustic, {len(music_remaining)} from Music Store")
    
    # Create model matching with fuzzy logic
    model_matches = []
    
    # Get clean models from both stores
    acoustic_models = acoustic_remaining['CLEAN_MODEL'].dropna().unique()
    music_models = music_remaining['CLEAN_MODEL'].dropna().unique()
    
    # Remove empty strings and invalid models (too short, generic, etc.)
    acoustic_models = [model for model in acoustic_models if model and model.strip() and is_valid_model_for_matching(model)]
    music_models = [model for model in music_models if model and model.strip() and is_valid_model_for_matching(model)]
    
    print(f"   Unique models to match: {len(acoustic_models)} from Acoustic, {len(music_models)} from Music Store")
    
    # Fuzzy matching with stricter threshold to prevent loose model matches
    threshold = 90  # Similarity threshold (raised from 80 to reduce false positives)
    
    for acoustic_model in acoustic_models:
        # Find best match in music models
        match = process.extractOne(acoustic_model, music_models, scorer=fuzz.ratio)
        
        if match and match[1] >= threshold:
            music_model = match[0]
            similarity = match[1]
            
            # Get all products with these models
            acoustic_products = acoustic_remaining[acoustic_remaining['CLEAN_MODEL'] == acoustic_model]
            music_products = music_remaining[music_remaining['CLEAN_MODEL'] == music_model]
            
            # Create all combinations (many-to-many matching)
            for _, acoustic_row in acoustic_products.iterrows():
                for _, music_row in music_products.iterrows():
                    # Check if this pair is blacklisted
                    link_ac = acoustic_row['LINK']
                    link_ms = music_row['LINK']
                    
                    if not blacklist or not is_pair_blacklisted(link_ac, link_ms, blacklist):
                        match_data = {
                            'identifier': acoustic_model,
                            'match_type': 'Model',
                            'similarity': similarity,
                            'CLEAN_ID_AC': acoustic_row['CLEAN_ID'],
                            'CLEAN_ID_MS': music_row['CLEAN_ID'],
                            'CLEAN_MODEL_AC': acoustic_row['CLEAN_MODEL'],
                            'CLEAN_MODEL_MS': music_row['CLEAN_MODEL'],
                            'NAME_AC': acoustic_row['NAME'],
                            'NAME_MS': music_row['NAME'],
                            'PRICE_AC': acoustic_row['PRICE'],
                            'PRICE_MS': music_row['PRICE'],
                            'LINK_AC': acoustic_row['LINK'],
                            'LINK_MS': music_row['LINK']
                        }
                        model_matches.append(match_data)
                    else:
                        print(f"   Skipped blacklisted model match: {acoustic_model}")
    
    # Convert model matches to DataFrame
    if model_matches:
        df_model_matches = pd.DataFrame(model_matches)
        print(f"   Created {len(df_model_matches)} model matches")
    else:
        df_model_matches = pd.DataFrame()
        print("   No model matches found")
    
    # Combine all matches
    print("\n4. Combining all matches...")
    
    # Create final DataFrame structure
    final_matches = []
    
    # Add ID matches
    for _, row in id_matches.iterrows():
        match_data = {
            'identifier': row['CLEAN_ID'],
            'Matching_Style': 'ID',
            'Match_Key': row['CLEAN_ID'],
            'similarity': 100,  # Perfect match
            'Product_Name_AC': row['NAME_AC'],
            'Product_Name_MS': row['NAME_MS'],
            'Price_AC': row['PRICE_AC'],
            'Price_MS': row['PRICE_MS'],
            'Price_Diff': row['PRICE_MS'] - row['PRICE_AC'],
            'Link_AC': row['LINK_AC'],
            'Link_MS': row['LINK_MS']
        }
        final_matches.append(match_data)
    
    # Add model matches
    if not df_model_matches.empty:
        for _, row in df_model_matches.iterrows():
            match_data = {
                'identifier': row['identifier'],
                'Matching_Style': 'Model',
                'Match_Key': row['identifier'],
                'similarity': row['similarity'],
                'Product_Name_AC': row['NAME_AC'],
                'Product_Name_MS': row['NAME_MS'],
                'Price_AC': row['PRICE_AC'],
                'Price_MS': row['PRICE_MS'],
                'Price_Diff': row['PRICE_MS'] - row['PRICE_AC'],
                'Link_AC': row['LINK_AC'],
                'Link_MS': row['LINK_MS']
            }
            final_matches.append(match_data)
    
    # Create final DataFrame
    if final_matches:
        df_final = pd.DataFrame(final_matches)
        
        # Priority sorting: First by Matching_Style (ID first, then Model), then by Price_AC descending
        df_final = df_final.sort_values(['Matching_Style', 'Price_AC'], ascending=[True, False])
        
        print(f"   Total matches: {len(df_final)}")
        print(f"   ID matches: {len(df_final[df_final['Matching_Style'] == 'ID'])}")
        print(f"   Model matches: {len(df_final[df_final['Matching_Style'] == 'Model'])}")
        
        # Save to acms/reports directory
        output_dir = os.path.join(os.path.dirname(__file__), 'reports')
        os.makedirs(output_dir, exist_ok=True)
        
        output_file = os.path.join(output_dir, 'price_comparison_final.xlsx')
        df_final.to_excel(output_file, index=False)
        print(f"\n6. Results saved to: {output_file}")
        
        # Display statistics
        print("\n7. Price Comparison Statistics:")
        print(f"   Average price difference: {df_final['Price_Diff'].mean():.2f}")
        
        # Define columns for display
        sample_cols = ['identifier', 'Matching_Style', 'Product_Name_AC', 'Product_Name_MS', 'Price_AC', 'Price_MS', 'Price_Diff']
        print(df_final[sample_cols].head(10).to_string(index=False))
        
        return True
    else:
        print("   No matches found!")
        return False

if __name__ == "__main__":
    success = merge_store_data()
    if success:
        print(f"\n=== MERGER COMPLETED SUCCESSFULLY ===")
    else:
        print(f"\n=== MERGER FAILED ===")
