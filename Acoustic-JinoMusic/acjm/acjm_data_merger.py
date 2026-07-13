import pandas as pd
import re
import os
import sys
from rapidfuzz import fuzz, process
from datetime import datetime
import pytz


def clean_name_for_matching(text):
    """Clean product names for fuzzy matching."""
    if pd.isna(text):
        return ''
    text = str(text)
    text = re.sub(r'In Stock|Out of Stock|მარაგშია|არ არის მარაგში', '', text, flags=re.IGNORECASE)
    text = re.sub(r'\(copy\)', '', text, flags=re.IGNORECASE)
    text = re.sub(r'[–\-—_]', ' ', text)
    text = re.sub(r'\s+', ' ', text)
    text = text.strip()
    return text


def extract_model_number(text):
    """Extract model numbers from product name."""
    if pd.isna(text):
        return ''
    patterns = [
        r'\b[A-Z]{1,4}\d{1,4}\b',
        r'\b\d{1,4}[A-Z]{1,4}\b',
        r'\b[A-Z]{2,5}\d{2,4}\b',
        r'\b\d{2,4}[A-Z]{2,5}\b',
    ]
    text = str(text).upper()
    for pattern in patterns:
        matches = re.findall(pattern, text)
        if matches:
            return matches[0]
    return ''


def check_model_compatibility(ac_name, jm_name):
    """Check if model numbers are compatible (must be exact match)."""
    ac_model = extract_model_number(ac_name)
    jm_model = extract_model_number(jm_name)
    if ac_model and jm_model:
        return ac_model == jm_model
    if ac_model or jm_model:
        return False
    return True


def check_brand_compatibility(ac_name, jm_name):
    """Check if brands are compatible."""
    ac_name_upper = str(ac_name).upper()
    jm_name_upper = str(jm_name).upper()

    ac_has_yamaha = 'YAMAHA' in ac_name_upper
    jm_has_yamaha = 'YAMAHA' in jm_name_upper
    if ac_has_yamaha != jm_has_yamaha:
        return False

    ac_words = str(ac_name).strip().split()
    jm_words = str(jm_name).strip().split()

    if ac_words and jm_words:
        ac_brand = ac_words[0].upper()
        jm_brand = jm_words[0].upper()
        if ac_brand != jm_brand:
            return False
        generic_words = {'USED', 'NEW', 'CLASSICAL', 'ACOUSTIC', 'ELECTRIC', 'DIGITAL', 'ANALOG'}
        if ac_brand in generic_words and len(ac_words) > 1 and len(jm_words) > 1:
            ac_second = ac_words[1].upper()
            jm_second = jm_words[1].upper()
            if ac_second != jm_second:
                return False
    return True


def main():
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tbilisi_tz = pytz.timezone('Asia/Tbilisi')
    last_updated = datetime.now(tbilisi_tz).strftime('%Y-%m-%d %H:%M:%S')

    acoustic_file = os.path.join(BASE_DIR, 'scrapers', 'acoustic', 'acoustic_cleaned_models.xlsx')
    jinomusic_file = os.path.join(BASE_DIR, 'scrapers', 'jinomusic', 'jinomusic_cleaned.xlsx')
    output_file = os.path.join(BASE_DIR, 'reports', 'acoustic_vs_jinomusic.xlsx')
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    if os.path.exists(output_file):
        try:
            os.remove(output_file)
            print(f"🗑️  Removed previous merged report: {output_file}")
        except Exception as e:
            print(f"Could not remove previous merged report: {e}")
            return False

    try:
        print("Loading data...")
        df_ac = pd.read_excel(acoustic_file, engine='openpyxl')
        df_jm = pd.read_excel(jinomusic_file, engine='openpyxl')

        print(f"   Loaded {len(df_ac)} Acoustic products")
        print(f"   Loaded {len(df_jm)} JinoMusic products")

        required_cols_ac = ['UNIQUE_ID', 'NAME', 'PRICE', 'LINK']
        required_cols_jm = ['NAME', 'PRICE', 'LINK']

        for col in required_cols_ac:
            if col not in df_ac.columns:
                print(f"Warning: Column '{col}' not found in Acoustic data. Using empty values.")
                df_ac[col] = ''

        for col in required_cols_jm:
            if col not in df_jm.columns:
                print(f"Warning: Column '{col}' not found in JinoMusic data. Using empty values.")
                df_jm[col] = ''

        print("Cleaning names for matching...")
        df_ac['CLEANED_NAME'] = df_ac['NAME'].apply(clean_name_for_matching)
        df_jm['CLEANED_NAME'] = df_jm['NAME'].apply(clean_name_for_matching)

        # JinoMusic has no reliable IDs for matching — use fuzzy matching only
        print("Stage 1: Fuzzy Matching (brand + model + name similarity)...")
        threshold = 90
        matches = []
        matched_ac_indices = set()
        matched_jm_indices = set()

        jm_cleaned_names = []
        jm_indices = []
        for jm_idx, jm_row in df_jm.iterrows():
            jm_clean_name = jm_row['CLEANED_NAME']
            if jm_clean_name and len(jm_clean_name) >= 3:
                jm_cleaned_names.append(jm_clean_name)
                jm_indices.append(jm_idx)

        for ac_idx, ac_row in df_ac.iterrows():
            ac_clean_name = ac_row['CLEANED_NAME']
            if not ac_clean_name or len(ac_clean_name) < 3:
                continue

            result = process.extractOne(
                ac_clean_name,
                jm_cleaned_names,
                scorer=fuzz.token_set_ratio,
                score_cutoff=threshold
            )

            if result:
                best_match_name, score, best_match_idx_in_list = result
                jm_idx = jm_indices[best_match_idx_in_list]
                jm_row = df_jm.loc[jm_idx]

                if not check_model_compatibility(ac_row['NAME'], jm_row['NAME']):
                    continue

                if not check_brand_compatibility(ac_row['NAME'], jm_row['NAME']):
                    continue

                matches.append({
                    'Matching_Style': 'Fuzzy',
                    'Match_Score': score,
                    'Product_Name_AC': ac_row['NAME'],
                    'Product_Name_JM': jm_row['NAME'],
                    'Price_AC': ac_row['PRICE'],
                    'Price_JM': jm_row['PRICE'],
                    'Price_Diff': jm_row['PRICE'] - ac_row['PRICE'],
                    'Link_AC': ac_row['LINK'],
                    'Link_JM': jm_row['LINK'],
                    'Last_Updated': last_updated
                })
                matched_ac_indices.add(ac_idx)
                matched_jm_indices.add(jm_idx)
                jm_cleaned_names.pop(best_match_idx_in_list)
                jm_indices.pop(best_match_idx_in_list)

        print(f"Found {len(matches)} fuzzy matches")

        df_result = pd.DataFrame(matches)

        column_order = ['Matching_Style', 'Match_Score', 'Product_Name_AC', 'Product_Name_JM',
                        'Price_AC', 'Price_JM', 'Price_Diff', 'Link_AC', 'Link_JM', 'Last_Updated']

        if len(df_result) > 0:
            df_result = df_result[column_order]
            df_result = df_result.sort_values('Match_Score', ascending=False)
        else:
            df_result = pd.DataFrame(columns=column_order)

        df_result.to_excel(output_file, index=False, engine='openpyxl')
        print(f"\n6. Results saved to: {output_file}")

        print(f"\nSummary:")
        print(f"  Fuzzy Matches: {len(matches)}")
        print(f"  Acoustic unmatched: {len(df_ac) - len(matched_ac_indices)}")
        print(f"  JinoMusic unmatched: {len(df_jm) - len(matched_jm_indices)}")
        return True

    except FileNotFoundError as e:
        print(f"Error: {e}")
        print("Please ensure both acoustic_cleaned_models.xlsx and jinomusic_cleaned.xlsx exist.")
        return False
    except Exception as e:
        print(f"An error occurred: {e}")
        import traceback
        traceback.print_exc()
        return False


if __name__ == "__main__":
    sys.exit(0 if main() else 1)
