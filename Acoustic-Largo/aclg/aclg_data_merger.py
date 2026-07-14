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
    'LINE6', 'LINE 6', 'BLACKSTAR', 'FRIEDMAN', 'ENGL', 'DIEZEL',
    'BOSSENDORFER', 'BÖSENDORFER', 'STEINBERG', 'NEUTRIK',
    'SOUNDKING', 'WINCENT', 'SMIGER',
]

# Color/finish suffixes commonly used by Yamaha and other brands
# Only include suffixes that are clearly colors/finishes, not model variants
COLOR_SUFFIXES = {
    'TBS', 'NT', 'CS', 'BL', 'BK', 'WH', 'PE', 'PM', 'PWH',
    'SAW', 'SBW', 'SDW', 'SM', 'OBB', 'CRB',
    'TB', 'PB', 'DBM', 'RM', 'HM', 'FP', 'PAW', 'KG', 'BWH',
    'CHROME', 'ENST', 'PACK',
}


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


def strip_color_suffix(code):
    """Strip color/finish suffix from a model code to get the base model.
    e.g. CLP725WH -> CLP725, F310TBS -> F310, SLG200NNT -> SLG200N"""
    for suffix in sorted(COLOR_SUFFIXES, key=len, reverse=True):
        if code.endswith(suffix) and len(code) > len(suffix) + 1:
            base = code[:-len(suffix)]
            if re.search(r'[A-Z]', base) and re.search(r'\d', base):
                return base
    return code


def extract_model_codes(text):
    """Extract all candidate model codes from a product name."""
    if pd.isna(text):
        return set()
    text = str(text).upper()
    # Remove Georgian text first
    text = re.sub(r'[\u10a0-\u10ff]+', ' ', text)
    # Try to join split model codes: "HS8 B" -> "HS8B", "CLP 725" -> "CLP725"
    # Pattern: letters+digits followed by space followed by 1-3 uppercase letters
    text = re.sub(r'([A-Z]+\d[\w]*)\s+([A-Z]{1,3})\b', r'\1\2', text)
    # Also join "CLP-725 WH" style: model followed by color suffix
    text = re.sub(r'([A-Z]+[\-]?\d[\w]*)\s+([A-Z]{1,4})\b', r'\1\2', text)
    tokens = re.findall(r'[A-Z0-9][A-Z0-9\-_/\.]*[A-Z0-9]|[A-Z0-9]', text)
    codes = set()
    for tok in tokens:
        norm = normalize_token(tok)
        if len(norm) >= 3 and re.search(r'[A-Z]', norm) and re.search(r'\d', norm):
            if re.fullmatch(r'\d+[/X]\d+', norm):
                continue
            codes.add(norm)
    return codes


def extract_base_model_codes(text):
    """Extract model codes and also their color-stripped base versions."""
    codes = extract_model_codes(text)
    result = set()
    for code in codes:
        base = strip_color_suffix(code)
        result.add(base)
        if base != code:
            result.add(code)
    return result


def clean_name_for_fuzzy(text):
    """Clean product name for fuzzy matching: remove Georgian text, keep model-relevant parts."""
    if pd.isna(text):
        return ''
    text = str(text).upper()
    # Remove Georgian characters
    text = re.sub(r'[\u10a0-\u10ff]+', ' ', text)
    # Remove common generic words
    remove_words = [
        'YAMAHA', 'GUITAR', 'PIANO', 'DIGITAL', 'CLASSICAL', 'ACOUSTIC',
        'ELECTRIC', 'KEYBOARD', 'SYNTHESIZER', 'DRUM', 'PEDAL', 'SPEAKER',
        'MONITOR', 'MIXER', 'AMP', 'AMPLIFIER', 'USED', 'CLAVINOVA', 'ARIUS',
        'PORTABLE', 'STAGEPAS', 'RECORDER', 'CLARINET', 'FLUTE', 'BASS',
        'STRINGS', 'STRING', 'CAPO', 'TUNER', 'CABLE', 'STAND', 'CASE',
        'BAG', 'PICKUP', 'EFFECTS', 'PROCESSOR', 'INTERFACE', 'AUDIO',
        'POWERED', 'CHANNEL', 'WIRELESS', 'BLUETOOTH', 'CONCERT', 'GRAND',
        'UPRIGHT', 'SILENT', 'TRANSACOUSTIC', 'GUITALELE', 'SOPRANO',
        'BANJO', 'MANDOLIN', 'UKULELE', 'VIOLIN', 'CYMBAL', 'HIHAT',
        'SNARE', 'CRASH', 'RIDE', 'SPLASH', 'CHINA', 'SHEET', 'MUSIC',
        'BOOK', 'METRONOME', 'PICK', 'STRAP', 'MUTE', 'REED', 'KEY',
        'PADS', 'VALVE', 'SLIDE', 'TUNING', 'FOR', 'WITH', 'AND', 'THE',
        'IN', 'OF', 'TO', 'A', 'AN', 'IS', 'IT', 'ON', 'AT', 'BY', 'OR',
    ]
    for word in remove_words:
        text = re.sub(r'\b' + word + r'\b', ' ', text)
    text = ' '.join(text.split())
    return text


def main():
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tbilisi_tz = pytz.timezone('Asia/Tbilisi')
    last_updated = datetime.now(tbilisi_tz).strftime('%Y-%m-%d %H:%M:%S')

    acoustic_file = os.path.join(BASE_DIR, 'scrapers', 'acoustic', 'acoustic_cleaned_models.xlsx')
    largo_file = os.path.join(BASE_DIR, 'scrapers', 'largo', 'largo_cleaned.xlsx')
    output_file = os.path.join(BASE_DIR, 'reports', 'acoustic_vs_largo.xlsx')
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
        df_lg = pd.read_excel(largo_file, engine='openpyxl')

        print(f"   Loaded {len(df_ac)} Acoustic products")
        print(f"   Loaded {len(df_lg)} Largo products")

        required_cols_ac = ['UNIQUE_ID', 'NAME', 'PRICE', 'LINK']
        required_cols_lg = ['Product_Name', 'Price', 'Link']

        for col in required_cols_ac:
            if col not in df_ac.columns:
                df_ac[col] = ''

        for col in required_cols_lg:
            if col not in df_lg.columns:
                df_lg[col] = ''

        print("Extracting brands and model codes...")
        df_ac['BRAND_X'] = df_ac['NAME'].apply(extract_brand)
        df_lg['BRAND_X'] = df_lg['Product_Name'].apply(extract_brand)
        df_ac['MODEL_CODES'] = df_ac['NAME'].apply(extract_model_codes)
        df_lg['MODEL_CODES'] = df_lg['Product_Name'].apply(extract_model_codes)
        df_ac['BASE_CODES'] = df_ac['NAME'].apply(extract_base_model_codes)
        df_lg['BASE_CODES'] = df_lg['Product_Name'].apply(extract_base_model_codes)
        df_ac['CLEAN_NAME'] = df_ac['NAME'].apply(clean_name_for_fuzzy)
        df_lg['CLEAN_NAME'] = df_lg['Product_Name'].apply(clean_name_for_fuzzy)

        print(f"   Acoustic with model codes: {(df_ac['MODEL_CODES'].apply(len) > 0).sum()}")
        print(f"   Largo with model codes: {(df_lg['MODEL_CODES'].apply(len) > 0).sum()}")

        matches = []
        matched_ac_indices = set()
        matched_lg_indices = set()

        # ==========================================
        # Stage 1: Exact model code matching
        # ==========================================
        print("\nStage 1: Exact model code matching...")
        ac_code_index = {}
        for ac_idx, ac_row in df_ac.iterrows():
            for code in ac_row['MODEL_CODES']:
                ac_code_index.setdefault(code, []).append(ac_idx)

        for lg_idx, lg_row in df_lg.iterrows():
            lg_codes = lg_row['MODEL_CODES']
            lg_brand = lg_row['BRAND_X']
            if not lg_codes:
                continue

            best_ac_idx = None
            best_score = 0
            best_code = ''

            for code in lg_codes:
                for ac_idx in ac_code_index.get(code, []):
                    if ac_idx in matched_ac_indices:
                        continue
                    ac_row = df_ac.loc[ac_idx]
                    ac_brand = ac_row['BRAND_X']

                    if lg_brand and ac_brand and lg_brand != ac_brand:
                        continue

                    score = len(code) * 10
                    if lg_brand and ac_brand and lg_brand == ac_brand:
                        score += 50

                    # Price ratio check for exact matches too
                    ac_price = float(ac_row['PRICE']) if pd.notna(ac_row['PRICE']) else 0
                    lg_price = float(lg_row['Price']) if pd.notna(lg_row['Price']) else 0
                    if ac_price > 0 and lg_price > 0:
                        ratio = max(ac_price, lg_price) / min(ac_price, lg_price)
                        if ratio > 5:
                            continue

                    if score > best_score:
                        best_score = score
                        best_ac_idx = ac_idx
                        best_code = code

            if best_ac_idx is not None:
                ac_row = df_ac.loc[best_ac_idx]
                matches.append({
                    'Matching_Style': 'Exact_Model',
                    'Match_Score': best_score,
                    'Match_Key': best_code,
                    'Product_Name_AC': ac_row['NAME'],
                    'Product_Name_LG': lg_row['Product_Name'],
                    'Price_AC': ac_row['PRICE'],
                    'Price_LG': lg_row['Price'],
                    'Price_Diff': lg_row['Price'] - ac_row['PRICE'],
                    'Link_AC': ac_row['LINK'],
                    'Link_LG': lg_row['Link'],
                    'Last_Updated': last_updated
                })
                matched_ac_indices.add(best_ac_idx)
                matched_lg_indices.add(lg_idx)

        print(f"   Found {len(matches)} exact model matches")

        # ==========================================
        # Stage 2: Base model code matching (color-stripped)
        # ==========================================
        print("\nStage 2: Base model code matching (color-stripped)...")
        ac_base_index = {}
        for ac_idx, ac_row in df_ac.iterrows():
            if ac_idx in matched_ac_indices:
                continue
            for code in ac_row['BASE_CODES']:
                ac_base_index.setdefault(code, []).append(ac_idx)

        stage2_matches = 0
        for lg_idx, lg_row in df_lg.iterrows():
            if lg_idx in matched_lg_indices:
                continue
            lg_base_codes = lg_row['BASE_CODES']
            lg_brand = lg_row['BRAND_X']
            if not lg_base_codes:
                continue

            best_ac_idx = None
            best_score = 0
            best_code = ''

            for code in lg_base_codes:
                for ac_idx in ac_base_index.get(code, []):
                    if ac_idx in matched_ac_indices:
                        continue
                    ac_row = df_ac.loc[ac_idx]
                    ac_brand = ac_row['BRAND_X']

                    if lg_brand and ac_brand and lg_brand != ac_brand:
                        continue

                    score = len(code) * 8
                    if lg_brand and ac_brand and lg_brand == ac_brand:
                        score += 50

                    if score > best_score:
                        best_score = score
                        best_ac_idx = ac_idx
                        best_code = code

            if best_ac_idx is not None:
                ac_row = df_ac.loc[best_ac_idx]
                ac_price = float(ac_row['PRICE']) if pd.notna(ac_row['PRICE']) else 0
                lg_price = float(lg_row['Price']) if pd.notna(lg_row['Price']) else 0
                # Skip if price ratio is >5x (likely wrong match)
                if ac_price > 0 and lg_price > 0:
                    ratio = max(ac_price, lg_price) / min(ac_price, lg_price)
                    if ratio > 5:
                        continue
                matches.append({
                    'Matching_Style': 'Base_Model',
                    'Match_Score': best_score,
                    'Match_Key': best_code,
                    'Product_Name_AC': ac_row['NAME'],
                    'Product_Name_LG': lg_row['Product_Name'],
                    'Price_AC': ac_row['PRICE'],
                    'Price_LG': lg_row['Price'],
                    'Price_Diff': lg_row['Price'] - ac_row['PRICE'],
                    'Link_AC': ac_row['LINK'],
                    'Link_LG': lg_row['Link'],
                    'Last_Updated': last_updated
                })
                matched_ac_indices.add(best_ac_idx)
                matched_lg_indices.add(lg_idx)
                stage2_matches += 1

        print(f"   Found {stage2_matches} base model matches")

        # ==========================================
        # Stage 3: Fuzzy name matching
        # ==========================================
        print("\nStage 3: Fuzzy name matching...")
        unmatched_ac = df_ac[~df_ac.index.isin(matched_ac_indices)].copy()
        unmatched_lg = df_lg[~df_lg.index.isin(matched_lg_indices)].copy()

        unmatched_lg = unmatched_lg[unmatched_lg['CLEAN_NAME'].str.len() > 2]
        unmatched_ac = unmatched_ac[unmatched_ac['CLEAN_NAME'].str.len() > 2]

        print(f"   Unmatched Acoustic with clean names: {len(unmatched_ac)}")
        print(f"   Unmatched Largo with clean names: {len(unmatched_lg)}")

        ac_clean_names = unmatched_ac['CLEAN_NAME'].tolist()
        ac_indices = unmatched_ac.index.tolist()

        stage3_matches = 0
        for lg_idx, lg_row in unmatched_lg.iterrows():
            lg_clean = lg_row['CLEAN_NAME']
            lg_brand = lg_row['BRAND_X']

            if len(lg_clean) < 3:
                continue

            result = process.extractOne(
                lg_clean,
                ac_clean_names,
                scorer=fuzz.token_sort_ratio,
                score_cutoff=80
            )

            if result is None:
                continue

            best_match_name, best_score, best_list_idx = result
            best_ac_idx = ac_indices[best_list_idx]

            if best_ac_idx in matched_ac_indices:
                continue

            ac_row = df_ac.loc[best_ac_idx]
            ac_brand = ac_row['BRAND_X']

            if lg_brand and ac_brand and lg_brand != ac_brand:
                continue

            # Price ratio check for fuzzy matches
            ac_price = float(ac_row['PRICE']) if pd.notna(ac_row['PRICE']) else 0
            lg_price = float(lg_row['Price']) if pd.notna(lg_row['Price']) else 0
            if ac_price > 0 and lg_price > 0:
                ratio = max(ac_price, lg_price) / min(ac_price, lg_price)
                if ratio > 5:
                    continue

            matches.append({
                'Matching_Style': 'Fuzzy_Name',
                'Match_Score': int(best_score),
                'Match_Key': f'fuzzy:{best_score}',
                'Product_Name_AC': ac_row['NAME'],
                'Product_Name_LG': lg_row['Product_Name'],
                'Price_AC': ac_row['PRICE'],
                'Price_LG': lg_row['Price'],
                'Price_Diff': lg_row['Price'] - ac_row['PRICE'],
                'Link_AC': ac_row['LINK'],
                'Link_LG': lg_row['Link'],
                'Last_Updated': last_updated
            })
            matched_ac_indices.add(best_ac_idx)
            matched_lg_indices.add(lg_idx)
            stage3_matches += 1

        print(f"   Found {stage3_matches} fuzzy name matches")

        # ==========================================
        # Save results
        # ==========================================
        df_result = pd.DataFrame(matches)

        column_order = ['Matching_Style', 'Match_Score', 'Match_Key', 'Product_Name_AC', 'Product_Name_LG',
                        'Price_AC', 'Price_LG', 'Price_Diff', 'Link_AC', 'Link_LG', 'Last_Updated']

        if len(df_result) > 0:
            df_result = df_result[column_order]
            df_result = df_result.sort_values('Match_Score', ascending=False)
        else:
            df_result = pd.DataFrame(columns=column_order)

        df_result.to_excel(output_file, index=False, engine='openpyxl')
        print(f"\nResults saved to: {output_file}")

        print(f"\nSummary:")
        print(f"  Stage 1 - Exact Model Matches: {len([m for m in matches if m['Matching_Style'] == 'Exact_Model'])}")
        print(f"  Stage 2 - Base Model Matches:  {len([m for m in matches if m['Matching_Style'] == 'Base_Model'])}")
        print(f"  Stage 3 - Fuzzy Name Matches:  {len([m for m in matches if m['Matching_Style'] == 'Fuzzy_Name'])}")
        print(f"  Total Matches: {len(matches)}")
        print(f"  Acoustic unmatched: {len(df_ac) - len(matched_ac_indices)}")
        print(f"  Largo unmatched: {len(df_lg) - len(matched_lg_indices)}")
        return True

    except FileNotFoundError as e:
        print(f"Error: {e}")
        print("Please ensure both acoustic_cleaned_models.xlsx and largo_cleaned.xlsx exist.")
        return False
    except Exception as e:
        print(f"An error occurred: {e}")
        import traceback
        traceback.print_exc()
        return False


if __name__ == "__main__":
    sys.exit(0 if main() else 1)
