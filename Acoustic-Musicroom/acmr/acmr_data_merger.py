#!/usr/bin/env python3
"""
ACMR Data Merger
Merges Acoustic and Musicroom datasets using fuzzy name matching
"""

import os
import re
import pandas as pd
from fuzzywuzzy import fuzz, process
try:
    import Levenshtein
    LEVENSHTEIN_AVAILABLE = True
except ImportError:
    LEVENSHTEIN_AVAILABLE = False


def safe_price_diff(price_ac, price_mr):
    if price_ac > 0 and price_mr > 0:
        return price_mr - price_ac
    return 0

def normalize_model(name):
    """Normalize model number by removing all non-alphanumeric characters and lowercasing.
    Used for 'under the hood' matching only - original names are preserved in output.
    Examples: 'D-28' → 'd28', 'D 28' → 'd28', 'GA-H16-3TS' → 'gah163ts'
    """
    if pd.isna(name):
        return ""
    # Remove all non-alphanumeric characters and convert to lowercase
    normalized = re.sub(r'[^a-zA-Z0-9]', '', str(name)).lower()
    return normalized

def extract_model_number(name):
    """Extract alphanumeric model number from product name."""
    if pd.isna(name):
        return ""
    # Look for patterns like: DBSBN40120M, GAH11N, etc.
    # Match sequences of 3+ uppercase letters followed by numbers, or vice versa
    model_pattern = re.compile(r'\b[A-Z]{2,}\d+[A-Z0-9]*\b|\b\d+[A-Z]{2,}\b')
    matches = model_pattern.findall(str(name))
    if matches:
        return matches[0]
    return ""


def extract_and_normalize_model_token(name):
    token = extract_model_number(name)
    return normalize_model(token) if token else ""

def create_search_name(name):
    """Create a search name by keeping only English letters and numbers."""
    if pd.isna(name):
        return ""
    
    search_name = str(name)
    
    # Remove Georgian characters
    georgian_pattern = re.compile(r'[\u10A0-\u10FF]')
    search_name = georgian_pattern.sub('', search_name)
    
    # Remove noise words (Georgian and English)
    noise_words = [' - Music Room', 'Music Room', 'Acoustic', ' - Acoustic', 'გარანტიით', 'ახალი']
    for noise in noise_words:
        search_name = search_name.replace(noise, '')
    
    # Keep only English letters, numbers, and basic punctuation
    search_name = re.sub(r'[^a-zA-Z0-9\s\-]', '', search_name)
    
    # Convert to lowercase
    search_name = search_name.lower()
    
    # Clean up extra whitespace and hyphens
    search_name = ' '.join(search_name.replace('-', ' ').split())
    
    return search_name.strip()

def merge_datasets(fuzzy_limit=None, batch_size=100):
    """Merge Acoustic and Musicroom datasets using fuzzy name matching
    
    Args:
        fuzzy_limit: Optional limit for fuzzy matching (for testing). None = no limit.
        batch_size: Number of items to process before saving incremental progress.
    """
    
    # Get script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    # Input file paths
    acoustic_file = os.path.join(project_root, "scrapers", "acoustic", "acoustic_cleaned_models.xlsx")
    musicroom_file = os.path.join(project_root, "scrapers", "musicroom", "musicroom_cleaned.xlsx")
    
    # Output directory and file
    reports_dir = os.path.join(project_root, "reports")
    if not os.path.exists(reports_dir):
        os.makedirs(reports_dir)
    
    output_file = os.path.join(reports_dir, "acmr_merged_report.xlsx")
    
    print("="*60)
    print("ACMR DATA MERGER")
    print("="*60)
    if LEVENSHTEIN_AVAILABLE:
        print("✅ python-Levenshtein detected - fuzzy matching will be fast")
    else:
        print("⚠️  python-Levenshtein not found - fuzzy matching will be slow")
        print("   Install with: pip install python-Levenshtein")
    print("="*60)
    print(f"Acoustic File: {acoustic_file}")
    print(f"Musicroom File: {musicroom_file}")
    print(f"Output File: {output_file}")
    print("="*60)
    
    # Load datasets
    try:
        df_acoustic = pd.read_excel(acoustic_file)
        print(f"✅ Loaded {len(df_acoustic)} products from Acoustic")
    except Exception as e:
        print(f"❌ Error loading Acoustic file: {e}")
        return False
    
    try:
        df_musicroom = pd.read_excel(musicroom_file)
        print(f"✅ Loaded {len(df_musicroom)} products from Musicroom")
    except Exception as e:
        print(f"❌ Error loading Musicroom file: {e}")
        return False
    
    # Note: ID matching abandoned - IDs have different formats between stores
    print("\n⚠️  ID matching skipped - IDs have different formats between stores")
    print("   Using fuzzy name matching only")
    
    # Ensure required columns exist
    required_acoustic = ['NAME', 'PRICE', 'LINK']
    required_musicroom = ['NAME', 'PRICE', 'LINK']
    
    for col in required_acoustic:
        if col not in df_acoustic.columns:
            print(f"❌ Missing column in Acoustic: {col}")
            return False
    
    for col in required_musicroom:
        if col not in df_musicroom.columns:
            print(f"❌ Missing column in Musicroom: {col}")
            return False
    
    # Step 1: Smart model matching using normalized comparison (fast indexed lookup)
    print("\n📌 Step 1: Smart model matching (normalized)...")

    # Extract model tokens and build normalized tokens for matching
    df_acoustic['model_num'] = df_acoustic['NAME'].apply(extract_model_number)
    df_musicroom['model_num'] = df_musicroom['NAME'].apply(extract_model_number)
    df_acoustic['model_token'] = df_acoustic['NAME'].apply(extract_and_normalize_model_token)
    df_musicroom['model_token'] = df_musicroom['NAME'].apply(extract_and_normalize_model_token)

    # Index musicroom by normalized model (exact key)
    mr_index = {}
    for idx_mr, token in df_musicroom['model_token'].items():
        if isinstance(token, str) and token and len(token) >= 3:
            mr_index.setdefault(token, []).append(idx_mr)

    model_matches = []
    matched_musicroom_indices = set()
    matched_acoustic_indices = set()

    total_ac = len(df_acoustic)
    for i, (idx_ac, row_ac) in enumerate(df_acoustic.iterrows(), start=1):
        if i % 500 == 0 or i == total_ac:
            print(f"   Model matching progress: {i}/{total_ac}")

        token_ac = row_ac['model_token']
        if not isinstance(token_ac, str) or not token_ac or len(token_ac) < 3:
            continue

        # Exact normalized match first
        candidate_indices = mr_index.get(token_ac, [])
        chosen_idx = None
        for idx_mr in candidate_indices:
            if idx_mr not in matched_musicroom_indices:
                chosen_idx = idx_mr
                break

        if chosen_idx is None:
            continue

        row_mr = df_musicroom.loc[chosen_idx]

        price_ac = float(row_ac['PRICE']) if pd.notna(row_ac['PRICE']) and row_ac['PRICE'] > 0 else 0
        price_mr = float(row_mr['PRICE']) if pd.notna(row_mr['PRICE']) and row_mr['PRICE'] > 0 else 0
        price_diff = safe_price_diff(price_ac, price_mr)

        model_matches.append({
            'matching_style': 'Model',
            'product_name_ac': row_ac['NAME'],
            'product_name_mr': row_mr['NAME'],
            'price_ac': price_ac,
            'price_mr': price_mr,
            'price_diff': price_diff,
            'link_ac': row_ac['LINK'],
            'link_mr': row_mr['LINK']
        })

        matched_musicroom_indices.add(chosen_idx)
        matched_acoustic_indices.add(idx_ac)
    
    print(f"   Found {len(model_matches)} model-based matches")
    model_matches_df = pd.DataFrame(model_matches)
    
    # Step 2: Fuzzy matching for remaining products
    print("\n📌 Step 2: Fuzzy matching for remaining products...")
    
    # Get products that didn't match by model number
    acoustic_unmatched = df_acoustic[~df_acoustic.index.isin(matched_acoustic_indices)].copy()
    musicroom_unmatched = df_musicroom[~df_musicroom.index.isin(matched_musicroom_indices)].copy()
    
    print(f"   Acoustic unmatched: {len(acoustic_unmatched)}")
    print(f"   Musicroom unmatched: {len(musicroom_unmatched)}")
    
    # Apply limit for testing if specified
    if fuzzy_limit:
        acoustic_unmatched = acoustic_unmatched.head(fuzzy_limit)
        print(f"   ⚠️  Testing mode: Limiting to first {fuzzy_limit} Acoustic products")
    
    # Create search names for fuzzy matching
    print("   Creating search names...")
    acoustic_unmatched['search_name'] = acoustic_unmatched['NAME'].apply(create_search_name)
    musicroom_unmatched['search_name'] = musicroom_unmatched['NAME'].apply(create_search_name)
    print("   Done")
    
    # Create a list of Musicroom search names for fast lookup
    musicroom_search_names = musicroom_unmatched['search_name'].tolist()
    musicroom_indices = musicroom_unmatched.index.tolist()
    
    # Perform fuzzy matching using process.extractOne with batched processing
    fuzzy_matches = []
    similarity_threshold = 85  # High threshold for quality matches
    matched_musicroom_indices = set()  # Track matched indices to avoid duplicates
    
    total_acoustic = len(acoustic_unmatched)
    print(f"   Starting fuzzy matching for {total_acoustic} products (batch size: {batch_size})...")
    
    # Initialize output file with model matches
    all_matches = model_matches_df.copy() if len(model_matches_df) > 0 else pd.DataFrame(columns=['matching_style', 'product_name_ac', 'product_name_mr', 'price_ac', 'price_mr', 'price_diff', 'link_ac', 'link_mr'])
    
    for i, (idx_ac, row_ac) in enumerate(acoustic_unmatched.iterrows(), 1):
        # Progress counter
        if i % 50 == 0 or i == total_acoustic:
            print(f"   Processing item {i}/{total_acoustic}...")
        
        # Use process.extractOne for fast fuzzy matching
        result = process.extractOne(
            row_ac['search_name'],
            musicroom_search_names,
            scorer=fuzz.ratio,
            score_cutoff=similarity_threshold
        )
        
        if result:
            # Handle both (match, score) and (match, score, index) return formats
            if len(result) == 2:
                best_match_name, best_score = result
                # Find index manually
                best_idx = musicroom_search_names.index(best_match_name)
            else:
                best_match_name, best_score, best_idx = result
            
            original_idx = musicroom_indices[best_idx]
            
            # Check if this Musicroom product was already matched
            if original_idx not in matched_musicroom_indices:
                best_match_row = musicroom_unmatched.loc[original_idx]
                price_ac = float(row_ac['PRICE']) if pd.notna(row_ac['PRICE']) and row_ac['PRICE'] > 0 else 0
                price_mr = float(best_match_row['PRICE']) if pd.notna(best_match_row['PRICE']) and best_match_row['PRICE'] > 0 else 0
                price_diff = safe_price_diff(price_ac, price_mr)
                
                fuzzy_matches.append({
                    'matching_style': 'Fuzzy',
                    'product_name_ac': row_ac['NAME'],
                    'product_name_mr': best_match_row['NAME'],
                    'price_ac': price_ac,
                    'price_mr': price_mr,
                    'price_diff': price_diff,
                    'link_ac': row_ac['LINK'],
                    'link_mr': best_match_row['LINK']
                })
                matched_musicroom_indices.add(original_idx)
        
        # Save progress in batches
        if i % batch_size == 0 or i == total_acoustic:
            fuzzy_matches_df = pd.DataFrame(fuzzy_matches)
            batch_matches = pd.concat([all_matches, fuzzy_matches_df], ignore_index=True)
            try:
                batch_matches.to_excel(output_file, index=False)
                print(f"   💾 Saved progress ({len(batch_matches)} total matches)")
            except PermissionError:
                print(f"   ⚠️  Could not save progress - file may be open")
    
    fuzzy_matches_df = pd.DataFrame(fuzzy_matches)
    
    if len(fuzzy_matches_df) > 0:
        print(f"   Found {len(fuzzy_matches_df)} fuzzy matches")
    else:
        print(f"   No fuzzy matches found")
        fuzzy_matches_df = pd.DataFrame(columns=['matching_style', 'product_name_ac', 'product_name_mr', 
                                                   'price_ac', 'price_mr', 'price_diff', 'link_ac', 'link_mr'])
    
    # Combine all matches
    all_matches = pd.concat([model_matches_df, fuzzy_matches_df], ignore_index=True)
    
    print(f"\n📊 Total matches: {len(all_matches)}")
    print(f"   - Model matches: {len(model_matches_df)}")
    print(f"   - Fuzzy matches: {len(fuzzy_matches_df)}")
    
    # Save to Excel
    try:
        all_matches.to_excel(output_file, index=False)
        print(f"\n✅ Saved merged report to {output_file}")
        print(f"   Columns: {list(all_matches.columns)}")
        return True
    except PermissionError:
        print(f"\n❌ PLEASE CLOSE THE EXCEL FILE BEFORE RUNNING!")
        return False
    except Exception as e:
        print(f"\n❌ Error saving merged report: {e}")
        return False

if __name__ == "__main__":
    import sys
    
    # Check for limit parameter from command line
    fuzzy_limit = None
    batch_size = 100
    if len(sys.argv) > 1:
        try:
            fuzzy_limit = int(sys.argv[1])
            print(f"🧪 Testing mode: Limiting fuzzy matching to {fuzzy_limit} items")
        except ValueError:
            pass
    if len(sys.argv) > 2:
        try:
            batch_size = int(sys.argv[2])
            print(f"📦 Batch size set to {batch_size}")
        except ValueError:
            pass
    
    success = merge_datasets(fuzzy_limit=fuzzy_limit, batch_size=batch_size)
    
    if success:
        print("\n🎉 ACMR data merger completed successfully!")
    else:
        print("\n❌ ACMR data merger failed!")
