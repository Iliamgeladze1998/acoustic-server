import pandas as pd
import re
import os
import sys
from rapidfuzz import fuzz, process
from datetime import datetime
import pytz


# Known brands found on both sites
KNOWN_BRANDS = [
    'IBANEZ', 'TAKAMINE', 'YAMAHA', 'FENDER', 'MARSHALL', 'KORG', 'CASIO',
    'ROLAND', 'NUX', 'RCF', 'DEVISER', 'KOZMOS', 'SQUIER', 'GIBSON',
    'EPIPHONE', 'CORT', 'WASHBURN', 'ALHAMBRA', 'VALENCIA', 'ARIA',
    'STAGG', 'BEHRINGER', 'SHURE', 'SENNHEISER', 'AKG', 'BOSS', 'ZOOM',
    'DUNLOP', 'ERNIE', 'DADDARIO', "D'ADDARIO", 'ELIXIR', 'MARTIN',
    'ORTEGA', 'KRAMER', 'JACKSON', 'ESP', 'LTD', 'SCHECTER', 'GRETSCH',
    'TAYLOR', 'SEAGULL', 'KAWAI', 'NORD', 'KURZWEIL', 'MEDELI', 'RINGWAY',
    'MAX', 'MUSEDO', 'FINKS', 'BLANTH', 'HOHNER', 'SUZUKI', 'PEARL',
    'TAMA', 'MAPEX', 'SABIAN', 'ZILDJIAN', 'PAISTE', 'MEINL', 'REMO',
    'EVANS', 'VIC', 'PROMARK', 'LANEY', 'ORANGE', 'VOX', 'PEAVEY',
    'HARTKE', 'AMPEG', 'GALLIEN', 'MACKIE', 'SOUNDCRAFT', 'ALLEN',
    'DYNACORD', 'ELECTRO', 'JBL', 'QSC', 'ALTO', 'WHARFEDALE',
]


def extract_brand(text):
    """Extract brand from product name."""
    if pd.isna(text):
        return ''
    text_upper = str(text).upper()
    for brand in KNOWN_BRANDS:
        if brand in text_upper:
            return brand
    return ''


def normalize_token(token):
    """Normalize a model token: uppercase, remove separators."""
    return re.sub(r'[\-_/\.]', '', token.upper())


def extract_model_codes(text):
    """Extract all candidate model codes from a product name.
    A model code is a latin token containing both letters and digits,
    normalized by removing separators (FK-310 -> FK310, GRX70QA_TRB -> GRX70QATRB)."""
    if pd.isna(text):
        return set()
    text = str(text).upper()
    # Split on whitespace, keep latin/digit tokens
    tokens = re.findall(r'[A-Z0-9][A-Z0-9\-_/\.]*[A-Z0-9]|[A-Z0-9]', text)
    codes = set()
    for tok in tokens:
        norm = normalize_token(tok)
        # Must contain at least one letter AND one digit, length >= 3
        if len(norm) >= 3 and re.search(r'[A-Z]', norm) and re.search(r'\d', norm):
            # Skip pure measurement patterns like 4/4, 1/2, sizes
            if re.fullmatch(r'\d+[/X]\d+', norm):
                continue
            codes.add(norm)
    return codes


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

        print("Extracting brands and model codes...")
        df_ac['BRAND_X'] = df_ac['NAME'].apply(extract_brand)
        df_jm['BRAND_X'] = df_jm['NAME'].apply(extract_brand)
        df_ac['MODEL_CODES'] = df_ac['NAME'].apply(extract_model_codes)
        df_jm['MODEL_CODES'] = df_jm['NAME'].apply(extract_model_codes)

        print(f"   Acoustic with model codes: {(df_ac['MODEL_CODES'].apply(len) > 0).sum()}")
        print(f"   JinoMusic with model codes: {(df_jm['MODEL_CODES'].apply(len) > 0).sum()}")

        print("Stage 1: Brand + Model code matching...")
        matches = []
        matched_ac_indices = set()
        matched_jm_indices = set()

        # Build index: model_code -> list of ac indices
        ac_code_index = {}
        for ac_idx, ac_row in df_ac.iterrows():
            for code in ac_row['MODEL_CODES']:
                ac_code_index.setdefault(code, []).append(ac_idx)

        for jm_idx, jm_row in df_jm.iterrows():
            jm_codes = jm_row['MODEL_CODES']
            jm_brand = jm_row['BRAND_X']
            if not jm_codes:
                continue

            best_ac_idx = None
            best_score = 0
            best_code = ''

            for code in jm_codes:
                for ac_idx in ac_code_index.get(code, []):
                    if ac_idx in matched_ac_indices:
                        continue
                    ac_row = df_ac.loc[ac_idx]
                    ac_brand = ac_row['BRAND_X']

                    # Brand check: if both have brands, they must match
                    if jm_brand and ac_brand and jm_brand != ac_brand:
                        continue

                    # Score: prefer longer model codes (more specific) and matching brands
                    score = len(code) * 10
                    if jm_brand and ac_brand and jm_brand == ac_brand:
                        score += 50

                    if score > best_score:
                        best_score = score
                        best_ac_idx = ac_idx
                        best_code = code

            if best_ac_idx is not None:
                ac_row = df_ac.loc[best_ac_idx]
                matches.append({
                    'Matching_Style': 'Brand+Model',
                    'Match_Score': best_score,
                    'Match_Key': best_code,
                    'Product_Name_AC': ac_row['NAME'],
                    'Product_Name_JM': jm_row['NAME'],
                    'Price_AC': ac_row['PRICE'],
                    'Price_JM': jm_row['PRICE'],
                    'Price_Diff': jm_row['PRICE'] - ac_row['PRICE'],
                    'Link_AC': ac_row['LINK'],
                    'Link_JM': jm_row['LINK'],
                    'Last_Updated': last_updated
                })
                matched_ac_indices.add(best_ac_idx)
                matched_jm_indices.add(jm_idx)

        print(f"Found {len(matches)} brand+model matches")

        df_result = pd.DataFrame(matches)

        column_order = ['Matching_Style', 'Match_Score', 'Match_Key', 'Product_Name_AC', 'Product_Name_JM',
                        'Price_AC', 'Price_JM', 'Price_Diff', 'Link_AC', 'Link_JM', 'Last_Updated']

        if len(df_result) > 0:
            df_result = df_result[column_order]
            df_result = df_result.sort_values('Match_Score', ascending=False)
        else:
            df_result = pd.DataFrame(columns=column_order)

        df_result.to_excel(output_file, index=False, engine='openpyxl')
        print(f"\n6. Results saved to: {output_file}")

        print(f"\nSummary:")
        print(f"  Brand+Model Matches: {len(matches)}")
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
