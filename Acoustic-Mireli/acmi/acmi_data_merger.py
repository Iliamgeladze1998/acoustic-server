import pandas as pd
import re
import os
from rapidfuzz import fuzz, process
from datetime import datetime
import pytz

def clean_name_for_matching(text):
    """Clean product names for fuzzy matching."""
    if pd.isna(text):
        return ''
    
    # Remove common noise
    text = str(text)
    text = re.sub(r'In Stock|Out of Stock|მარაგშია|არ არის მარაგში', '', text, flags=re.IGNORECASE)
    text = re.sub(r'[–\-—_]', ' ', text)
    text = re.sub(r'\s+', ' ', text)
    text = text.strip()
    
    return text

def clean_id(text):
    """Clean ID for matching - remove all non-alphanumeric characters."""
    if pd.isna(text):
        return ''
    text = str(text).lower()
    # Remove all non-alphanumeric characters (only keep letters and numbers)
    text = re.sub(r'[^a-z0-9]', '', text)
    return text

def extract_model_number(text):
    """Extract model numbers from product name."""
    if pd.isna(text):
        return ''
    
    # Common patterns for model numbers
    patterns = [
        r'\b[A-Z]{1,4}\d{1,4}\b',  # MG10, MG12, etc.
        r'\b\d{1,4}[A-Z]{1,4}\b',  # 10MG, etc.
        r'\b[A-Z]{2,5}\d{2,4}\b',  # YAMAHA123, etc.
        r'\b\d{2,4}[A-Z]{2,5}\b',  # 123YAMAHA, etc.
    ]
    
    text = str(text).upper()
    for pattern in patterns:
        matches = re.findall(pattern, text)
        if matches:
            # Return the first match (most likely the main model number)
            return matches[0]
    
    return ''

def check_model_compatibility(ac_name, mir_name):
    """Check if model numbers are compatible (must be exact match)."""
    ac_model = extract_model_number(ac_name)
    mir_model = extract_model_number(mir_name)
    
    # If both have model numbers, they must match exactly
    if ac_model and mir_model:
        return ac_model == mir_model
    
    # If only one has a model number, it's not a good match
    if ac_model or mir_model:
        return False
    
    # If neither has a clear model number, allow the match (but will be scored lower)
    return True

def check_brand_compatibility(ac_name, mir_name):
    """Check if brands are compatible (absolute check for Yamaha and first word)."""
    ac_name_upper = str(ac_name).upper()
    mir_name_upper = str(mir_name).upper()
    
    # ABSOLUTE Yamaha check - if one has Yamaha and the other doesn't, reject
    ac_has_yamaha = 'YAMAHA' in ac_name_upper
    mir_has_yamaha = 'YAMAHA' in mir_name_upper
    
    if ac_has_yamaha != mir_has_yamaha:
        return False
    
    # First word (brand name) check - enhanced for 100% accuracy
    ac_words = str(ac_name).strip().split()
    mir_words = str(mir_name).strip().split()
    
    if ac_words and mir_words:
        ac_brand = ac_words[0].upper()
        mir_brand = mir_words[0].upper()
        
        # If first words don't match, reject
        if ac_brand != mir_brand:
            return False
        
        # Additional check: if first word is too generic, check second word
        generic_words = {'USED', 'NEW', 'CLASSICAL', 'ACOUSTIC', 'ELECTRIC', 'DIGITAL', 'ANALOG'}
        if ac_brand in generic_words and len(ac_words) > 1 and len(mir_words) > 1:
            ac_second = ac_words[1].upper()
            mir_second = mir_words[1].upper()
            if ac_second != mir_second:
                return False
    
    # Add other absolute brand checks if needed
    # For now, only Yamaha and first word matching are critical - no exceptions
    return True

def main():
    # Use BASE_DIR for cross-platform compatibility
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tbilisi_tz = pytz.timezone('Asia/Tbilisi')
    last_updated = datetime.now(tbilisi_tz).strftime('%Y-%m-%d %H:%M:%S')
    
    acoustic_file = os.path.join(BASE_DIR, 'scrapers', 'acoustic', 'acoustic_cleaned_models.xlsx')
    mireli_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_cleaned_models.xlsx')
    output_file = os.path.join(BASE_DIR, 'reports', 'acoustic_vs_mireli.xlsx')
    
    try:
        # Load data
        print("Loading data...")
        df_ac = pd.read_excel(acoustic_file, engine='openpyxl')
        df_mir = pd.read_excel(mireli_file, engine='openpyxl')
        
        print(f"Loaded {len(df_ac)} Acoustic products")
        print(f"Loaded {len(df_mir)} Mireli products")
        
        # Ensure required columns exist
        required_cols_ac = ['UNIQUE_ID', 'NAME', 'PRICE', 'LINK']
        required_cols_mir = ['UNIQUE_ID', 'NAME', 'PRICE', 'LINK']
        
        for col in required_cols_ac:
            if col not in df_ac.columns:
                print(f"Warning: Column '{col}' not found in Acoustic data. Using empty values.")
                df_ac[col] = ''
        
        for col in required_cols_mir:
            if col not in df_mir.columns:
                print(f"Warning: Column '{col}' not found in Mireli data. Using empty values.")
                df_mir[col] = ''
        
        # Clean names for matching
        print("Cleaning names for matching...")
        df_ac['CLEANED_NAME'] = df_ac['NAME'].apply(clean_name_for_matching)
        df_mir['CLEANED_NAME'] = df_mir['NAME'].apply(clean_name_for_matching)
        
        df_ac['CLEANED_ID'] = df_ac['UNIQUE_ID'].apply(clean_id)
        df_mir['CLEANED_ID'] = df_mir['UNIQUE_ID'].apply(clean_id)
        
        # Stage 1: ID Matching
        print("Stage 1: ID Matching...")
        matches = []
        matched_ac_indices = set()
        matched_mir_indices = set()
        
        # Create ID lookup for Mireli
        mir_id_to_index = {row['CLEANED_ID']: idx for idx, row in df_mir.iterrows() if row['CLEANED_ID']}
        
        for ac_idx, ac_row in df_ac.iterrows():
            ac_id = ac_row['CLEANED_ID']
            if ac_id and ac_id in mir_id_to_index:
                mir_idx = mir_id_to_index[ac_id]
                mir_row = df_mir.loc[mir_idx]
                
                matches.append({
                    'Matching_Style': 'ID',
                    'Match_Score': 100,
                    'Product_Name_AC': ac_row['NAME'],
                    'Product_Name_MIR': mir_row['NAME'],
                    'Price_AC': ac_row['PRICE'],
                    'Price_MIR': mir_row['PRICE'],
                    'Price_Diff': mir_row['PRICE'] - ac_row['PRICE'],
                    'Link_AC': ac_row['LINK'],
                    'Link_MIR': mir_row['LINK'],
                    'Last_Updated': last_updated
                })
                matched_ac_indices.add(ac_idx)
                matched_mir_indices.add(mir_idx)
        
        print(f"Found {len(matches)} ID matches")
        
        # Stage 2: Fuzzy Matching for remaining items
        print("Stage 2: Fuzzy Matching...")
        threshold = 95  # High accuracy threshold to clean up fuzzy results
        
        # Pre-calculate cleaned names for unmatched Mireli products
        mir_cleaned_names = []
        mir_indices = []
        for mir_idx, mir_row in df_mir.iterrows():
            if mir_idx not in matched_mir_indices:
                mir_clean_name = mir_row['CLEANED_NAME']
                if mir_clean_name and len(mir_clean_name) >= 3:
                    mir_cleaned_names.append(mir_clean_name)
                    mir_indices.append(mir_idx)
        
        # Create a mapping from cleaned name to original index
        mir_name_to_index = {name: idx for name, idx in zip(mir_cleaned_names, mir_indices)}
        
        for ac_idx, ac_row in df_ac.iterrows():
            if ac_idx in matched_ac_indices:
                continue
            
            ac_clean_name = ac_row['CLEANED_NAME']
            if not ac_clean_name or len(ac_clean_name) < 3:
                continue
            
            # Use process.extractOne for faster fuzzy matching
            result = process.extractOne(
                ac_clean_name,
                mir_cleaned_names,
                scorer=fuzz.token_set_ratio,
                score_cutoff=threshold
            )
            
            if result:
                best_match_name, score, best_match_idx_in_list = result
                mir_idx = mir_indices[best_match_idx_in_list]
                mir_row = df_mir.loc[mir_idx]
                
                # Additional model number compatibility check
                if not check_model_compatibility(ac_row['NAME'], mir_row['NAME']):
                    print(f"Rejected match due to incompatible model numbers: {ac_row['NAME']} vs {mir_row['NAME']}")
                    continue
                
                # Additional brand compatibility check
                if not check_brand_compatibility(ac_row['NAME'], mir_row['NAME']):
                    print(f"Rejected match due to incompatible brands: {ac_row['NAME']} vs {mir_row['NAME']}")
                    continue
                
                matches.append({
                    'Matching_Style': 'Fuzzy',
                    'Match_Score': score,
                    'Product_Name_AC': ac_row['NAME'],
                    'Product_Name_MIR': mir_row['NAME'],
                    'Price_AC': ac_row['PRICE'],
                    'Price_MIR': mir_row['PRICE'],
                    'Price_Diff': mir_row['PRICE'] - ac_row['PRICE'],
                    'Link_AC': ac_row['LINK'],
                    'Link_MIR': mir_row['LINK'],
                    'Last_Updated': last_updated
                })
                matched_ac_indices.add(ac_idx)
                matched_mir_indices.add(mir_idx)
                # Remove matched item from list to prevent re-matching
                mir_cleaned_names.pop(best_match_idx_in_list)
                mir_indices.pop(best_match_idx_in_list)
        
        print(f"Found {len(matches) - len([m for m in matches if m['Matching_Style'] == 'ID'])} fuzzy matches")
        
        # Create DataFrame
        df_result = pd.DataFrame(matches)
        
        # Reorder columns
        column_order = ['Matching_Style', 'Match_Score', 'Product_Name_AC', 'Product_Name_MIR', 
                        'Price_AC', 'Price_MIR', 'Price_Diff', 'Link_AC', 'Link_MIR', 'Last_Updated']
        df_result = df_result[column_order]
        
        # Sort by Match_Score descending
        df_result = df_result.sort_values('Match_Score', ascending=False)
        
        # Save to Excel
        df_result.to_excel(output_file, index=False, engine='openpyxl')
        print(f"\nSuccessfully saved {len(df_result)} matches to {output_file}")
        
        # Print summary
        id_matches = len([m for m in matches if m['Matching_Style'] == 'ID'])
        fuzzy_matches = len([m for m in matches if m['Matching_Style'] == 'Fuzzy'])
        print(f"\nSummary:")
        print(f"  ID Matches: {id_matches}")
        print(f"  Fuzzy Matches: {fuzzy_matches}")
        print(f"  Total Matches: {len(df_result)}")
        
    except FileNotFoundError as e:
        print(f"Error: {e}")
        print("Please ensure both acoustic_cleaned_models.xlsx and mireli_cleaned_models.xlsx exist.")
    except Exception as e:
        print(f"An error occurred: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
