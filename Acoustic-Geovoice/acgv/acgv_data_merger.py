#!/usr/bin/env python3
"""
Data Merger for Acoustic and Geovoice Stores
Combines cleaned data from both stores and creates price comparison report
"""

import os
import pandas as pd
from datetime import datetime
from rapidfuzz import fuzz, process

def merge_acgv_data():
    """Merge cleaned data from Acoustic and Geovoice stores"""
    
    print("=== ACOUSTIC & GEOVOICE DATA MERGER ===")
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Load cleaned data from both stores
    print("\n1. Loading cleaned data...")
    
    # Load Acoustic Store data
    acoustic_file = os.path.join(os.path.dirname(__file__), '..', 'scrapers', 'acoustic', 'acoustic_cleaned_models.xlsx')
    df_acoustic = pd.read_excel(acoustic_file, dtype={'UNIQUE_ID': str, 'CLEAN_ID': str})
    print(f"   Loaded {len(df_acoustic)} products from Acoustic Store")
    
    # Load Geovoice data
    geovoice_file = os.path.join(os.path.dirname(__file__), '..', 'scrapers', 'geovoice', 'geovoice_cleaned_models.xlsx')
    df_geovoice = pd.read_excel(geovoice_file, dtype={'UNIQUE_ID': str, 'CLEAN_ID': str})
    print(f"   Loaded {len(df_geovoice)} products from Geovoice")
    
    # Step 1: ID Matching (100% matches)
    print("\n2. Performing ID matching...")
    
    # Create sets for ID matching
    acoustic_ids = set(df_acoustic['CLEAN_ID'].dropna().astype(str))
    geovoice_ids = set(df_geovoice['CLEAN_ID'].dropna().astype(str))
    
    # Find common IDs
    common_ids = acoustic_ids.intersection(geovoice_ids)
    print(f"   Found {len(common_ids)} ID matches")
    
    # Filter data for ID matches
    acoustic_id_matches = df_acoustic[df_acoustic['CLEAN_ID'].isin(common_ids)].copy()
    geovoice_id_matches = df_geovoice[df_geovoice['CLEAN_ID'].isin(common_ids)].copy()
    
    # Merge on CLEAN_ID for ID matches
    id_matches = pd.merge(
        acoustic_id_matches,
        geovoice_id_matches,
        on='CLEAN_ID',
        suffixes=('_AC', '_GV'),
        how='inner'
    )
    
    # Add match type and key
    id_matches['Matching_Style'] = 'ID'
    id_matches['Match_Key'] = id_matches['CLEAN_ID']
    
    # Calculate price difference
    id_matches['Price_Diff'] = id_matches['PRICE_GV'] - id_matches['PRICE_AC']
    
    # Add timestamp and feedback
    id_matches['Last_Updated'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    id_matches['Feedback'] = ''
    
    # Select and rename columns
    id_matches_final = id_matches[[
        'Matching_Style', 'Match_Key', 
        'NAME_AC', 'NAME_GV',
        'PRICE_AC', 'PRICE_GV', 'Price_Diff',
        'LINK_AC', 'LINK_GV',
        'Last_Updated', 'Feedback'
    ]].rename(columns={
        'NAME_AC': 'Product_Name_AC',
        'NAME_GV': 'Product_Name_GV',
        'PRICE_AC': 'Price_AC',
        'PRICE_GV': 'Price_GV',
        'LINK_AC': 'Link_AC',
        'LINK_GV': 'Link_GV'
    })
    
    print(f"   Created {len(id_matches_final)} ID matches")
    
    # Step 2: Fuzzy Matching (for remaining products)
    print("\n3. Performing fuzzy name matching...")
    
    # Get remaining products (those not matched by ID)
    acoustic_remaining = df_acoustic[~df_acoustic['CLEAN_ID'].isin(common_ids)].copy()
    geovoice_remaining = df_geovoice[~df_geovoice['CLEAN_ID'].isin(common_ids)].copy()
    
    print(f"   Remaining products: {len(acoustic_remaining)} from Acoustic, {len(geovoice_remaining)} from Geovoice")
    
    # Function to clean names for fuzzy matching
    def clean_name(name):
        """Clean name for fuzzy matching: lowercase, remove punctuation"""
        import string
        cleaned = str(name).lower()
        # Remove punctuation
        cleaned = cleaned.translate(str.maketrans('', '', string.punctuation))
        # Remove extra whitespace
        cleaned = ' '.join(cleaned.split())
        return cleaned
    
    # Add cleaned names to remaining dataframes
    acoustic_remaining['clean_name'] = acoustic_remaining['NAME'].apply(clean_name)
    geovoice_remaining['clean_name'] = geovoice_remaining['NAME'].apply(clean_name)
    
    # Fuzzy matching with relaxed threshold
    threshold = 75
    fuzzy_matches = []
    
    # For each Acoustic remaining product, try to find a match in Geovoice remaining
    for idx_g, row_g in acoustic_remaining.iterrows():
        acoustic_clean_name = row_g['clean_name']
        
        # Get list of Geovoice cleaned names for comparison
        geovoice_clean_names = geovoice_remaining['clean_name'].tolist()
        
        if geovoice_clean_names:
            # Use rapidfuzz to find best match with token_set_ratio
            result = process.extractOne(
                acoustic_clean_name,
                geovoice_clean_names,
                scorer=fuzz.token_set_ratio,
                score_cutoff=threshold
            )
            
            if result:
                match_name, score, match_idx = result
                geovoice_row = geovoice_remaining.iloc[match_idx]
                
                match_data = {
                    'Matching_Style': 'Fuzzy',
                    'Match_Key': match_name,
                    'Product_Name_AC': row_g['NAME'],
                    'Product_Name_GV': geovoice_row['NAME'],
                    'Price_AC': row_g['PRICE'],
                    'Price_GV': geovoice_row['PRICE'],
                    'Price_Diff': geovoice_row['PRICE'] - row_g['PRICE'],
                    'Link_AC': row_g['LINK'],
                    'Link_GV': geovoice_row['LINK'],
                    'Last_Updated': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    'Feedback': ''
                }
                fuzzy_matches.append(match_data)
    
    df_fuzzy_matches = pd.DataFrame(fuzzy_matches)
    print(f"   Created {len(df_fuzzy_matches)} fuzzy matches")
    
    # Combine all matches
    print("\n4. Combining all matches...")
    
    # Combine ID and fuzzy matches
    if not df_fuzzy_matches.empty:
        df_final = pd.concat([id_matches_final, df_fuzzy_matches], ignore_index=True)
    else:
        df_final = id_matches_final.copy()
    
    # Priority sorting: First by Matching_Style (ID first, then Fuzzy), then by Price_AC descending
    # Use categorical ordering to ensure 'ID' comes before 'Fuzzy'
    df_final['Matching_Style'] = pd.Categorical(df_final['Matching_Style'], categories=['ID', 'Fuzzy'], ordered=True)
    df_final = df_final.sort_values(['Matching_Style', 'Price_AC'], ascending=[True, False])
    
    print(f"   Total matches: {len(df_final)}")
    print(f"   ID matches: {len(df_final[df_final['Matching_Style'] == 'ID'])}")
    print(f"   Fuzzy matches: {len(df_final[df_final['Matching_Style'] == 'Fuzzy'])}")
    
    # Save to reports directory
    print("\n5. Saving results...")
    output_dir = os.path.join(os.path.dirname(__file__), '..', 'reports')
    os.makedirs(output_dir, exist_ok=True)
    
    output_file = os.path.join(output_dir, 'acoustic_geovoice_comparison.xlsx')
    df_final.to_excel(output_file, index=False)
    print(f"   Results saved to: {output_file}")
    
    # Display statistics
    print("\n6. Price Comparison Statistics:")
    print(f"   Average price difference: {df_final['Price_Diff'].mean():.2f}")
    
    # Display sample
    print("\n7. Sample matches (first 10):")
    sample_cols = ['Matching_Style', 'Product_Name_AC', 'Product_Name_GV', 'Price_AC', 'Price_GV', 'Price_Diff']
    print(df_final[sample_cols].head(10).to_string(index=False))
    
    return True

if __name__ == "__main__":
    success = merge_acgv_data()
    if success:
        print(f"\n=== MERGER COMPLETED SUCCESSFULLY ===")
    else:
        print(f"\n=== MERGER FAILED ===")
