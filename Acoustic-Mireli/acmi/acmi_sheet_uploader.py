import time
import pandas as pd
import json
import requests
import gspread
from google.oauth2 import service_account
from datetime import datetime, timedelta
import os
import sys
import urllib.parse
from gspread_formatting import CellFormat, Color, TextFormat, format_cell_range, conditionalFormatRule, BooleanRule, BooleanCondition, get_conditional_format_rules, GridRange, Border, Borders

# Telegram Configuration
TELEGRAM_TOKEN = "8835894573:AAGkC2YHR8DnSvmII-bA3fvtO1GaW5CcHFA"
CHAT_ID = "-1003712689651"
PRICE_COLUMNS = ['Price_AC', 'Price_MIR']
STORE_NAMES = {
    'Price_AC': 'Acoustic',
    'Price_MIR': 'Mireli',
}
MERGED_FILE_MAX_AGE_SECONDS = 24 * 60 * 60


def _abort_critical(message):
    """Log a CRITICAL pipeline error and abort the process immediately."""
    banner = "=" * 60
    print(banner, flush=True)
    print(f"CRITICAL: {message}", flush=True)
    print("ABORTING pipeline - uploader will NOT proceed with stale or missing merged data.", flush=True)
    print(banner, flush=True)
    sys.exit(1)


def _ensure_recent_merged_file(merged_file):
    """Require the merged Excel file to exist and be less than 24 hours old."""
    if not os.path.exists(merged_file):
        _abort_critical(
            f"Merged Excel file not found: {merged_file}. "
            "Run the merger before starting the uploader."
        )

    file_mtime = os.path.getmtime(merged_file)
    age_seconds = datetime.now().timestamp() - file_mtime
    if age_seconds > MERGED_FILE_MAX_AGE_SECONDS:
        modified_at = datetime.fromtimestamp(file_mtime).strftime("%Y-%m-%d %H:%M:%S")
        age_hours = age_seconds / 3600
        _abort_critical(
            f"Merged Excel file is older than 24 hours: {merged_file} "
            f"(modified {modified_at}, age {age_hours:.2f} hours)."
        )

    modified_at = datetime.fromtimestamp(file_mtime).strftime("%Y-%m-%d %H:%M:%S")
    age_hours = max(age_seconds, 0) / 3600
    print(
        f"✅ Freshness check passed: merged Excel modified at {modified_at} "
        f"({age_hours:.2f} hours old)."
    )

def load_blacklist(blacklist_file):
    """Load blacklist from JSON file."""
    if os.path.exists(blacklist_file):
        with open(blacklist_file, 'r', encoding='utf-8') as f:
            content = f.read()
            if content.strip():
                return json.loads(content)
    return []

def save_blacklist(blacklist, blacklist_file):
    """Save blacklist to JSON file."""
    os.makedirs(os.path.dirname(blacklist_file), exist_ok=True)
    with open(blacklist_file, 'w', encoding='utf-8') as f:
        json.dump(blacklist, f, indent=2, ensure_ascii=False)

def encode_links_in_df(df):
    """Encode Georgian characters in Mireli links for Google Sheets compatibility."""
    print("Encoding links for Google Sheets compatibility...")
    
    # Find link columns
    link_columns = []
    for col in df.columns:
        if 'LINK' in col.upper() or 'URL' in col.upper():
            link_columns.append(col)
    
    print(f"Found link columns: {link_columns}")
    
    # Encode links in each link column
    for col in link_columns:
        if col in df.columns:
            for idx, link in df[col].items():
                if pd.notna(link) and isinstance(link, str):
                    # Acoustic links: leave as plain text
                    if 'AC' in col.upper():
                        continue  # Don't modify Acoustic links
                    
                    # Mireli links: encode only the path after domain
                    if 'MIR' in col.upper():
                        # Check if it's a Mireli URL
                        if 'mireli.ge' in link.lower():
                            # Strict URL split using 'mireli.ge/'
                            parts = link.split('mireli.ge/')
                            
                            if len(parts) >= 2:
                                # Take the second part (the path)
                                path = parts[1]
                                
                                # Clean the path: remove leading slash if present
                                path = path.lstrip('/')
                                
                                # Encode only this cleaned path
                                encoded_path = urllib.parse.quote(path)
                                
                                # Rejoin with hardcoded single slash
                                final_url = f"https://mireli.ge/{encoded_path}"
                                df.at[idx, col] = final_url
    
    print("Link encoding completed.")
    return df

def update_blacklist_from_sheet(sheet, blacklist_file):
    """Fetch current sheet data and update blacklist based on Feedback column."""
    print("Step 1: Fetching current sheet data and updating blacklist...")
    
    # Fetch all data from sheet
    all_data = sheet.get_all_records()
    
    if not all_data:
        print("No existing data in sheet.")
        return load_blacklist(blacklist_file)
    
    # Load existing blacklist
    blacklist = load_blacklist(blacklist_file)
    
    # Create set of existing link pairs to avoid duplicates
    existing_pairs = {(item['link_ac'], item['link_mir']) for item in blacklist}
    
    # Check for 'Wrong' in Feedback column
    new_blacklist_entries = []
    for row in all_data:
        if 'Feedback' in row and row['Feedback'] == 'Wrong':
            link_ac = row.get('Link_AC', '')
            link_mir = row.get('Link_MIR', '')
            
            # Avoid duplicates
            if (link_ac, link_mir) not in existing_pairs:
                entry = {
                    'link_ac': link_ac,
                    'link_mir': link_mir,
                    'reason': 'User marked as Wrong',
                    'timestamp': datetime.now().isoformat()
                }
                new_blacklist_entries.append(entry)
                existing_pairs.add((link_ac, link_mir))
    
    # Add new entries to blacklist
    if new_blacklist_entries:
        blacklist.extend(new_blacklist_entries)
        save_blacklist(blacklist, blacklist_file)
        print(f"Added {len(new_blacklist_entries)} entries to blacklist.")
    else:
        print("No new blacklist entries found.")
    
    return blacklist

def filter_data_against_blacklist(df, blacklist):
    """Filter out data that is in blacklist."""
    print("Step 2: Filtering new data against blacklist...")
    
    # Create set of blacklisted link pairs
    blacklisted_pairs = {(item['link_ac'], item['link_mir']) for item in blacklist}
    
    # Filter dataframe
    filtered_df = df[~df.apply(
        lambda row: (row['Link_AC'], row['Link_MIR']) in blacklisted_pairs,
        axis=1
    )]
    
    print(f"Filtered from {len(df)} to {len(filtered_df)} rows after blacklist check.")
    return filtered_df

def column_letter(index):
    result = ''
    while index > 0:
        index, remainder = divmod(index - 1, 26)
        result = chr(65 + remainder) + result
    return result

def update_timestamp(sheet, row_count, col_letter):
    """Write the current timestamp into every data row of the Last_Updated column."""
    now = (datetime.utcnow() + timedelta(hours=4)).strftime('%Y-%m-%d %H:%M:%S')
    print(f"DEBUG: Current timestamp is {now}")
    values = [[now]] * row_count
    sheet.update(values=values, range_name=f'{col_letter}2:{col_letter}{row_count + 1}')
    print(f"   Timestamp written to {row_count} rows in column {col_letter}.")


def upload_to_sheet(df, sheet, sh):
    """Upload data to Google Sheets."""
    # Remove Match_Score column
    if 'Match_Score' in df.columns:
        df = df.drop(columns=['Match_Score'])

    # Encode links for Google Sheets compatibility
    df = encode_links_in_df(df)

    # Add Last_Updated and Feedback columns
    now = (datetime.utcnow() + timedelta(hours=4)).strftime('%Y-%m-%d %H:%M:%S')
    print(f"DEBUG: Current timestamp is {now}")
    df['Last_Updated'] = now
    df['Feedback'] = ''

    # Force-clear the sheet before writing
    print("   Clearing sheet...")
    sheet.clear()
    print("   Sheet cleared.")

    # Build upload payload: headers + all rows
    headers = df.columns.tolist()
    values = df.values.tolist()
    data = [headers] + values
    print(f"Step 3: Uploading {len(values)} rows to sheet starting at A1...")
    sheet.update(values=data, range_name='A1')

    # Freeze header row
    sheet.freeze(1)

    # Add data validation dropdown for Feedback column
    feedback_col_index = df.columns.get_loc('Feedback') + 1
    body = {
        'requests': [{
            'setDataValidation': {
                'range': {
                    'sheetId': sheet.id,
                    'startRowIndex': 1,
                    'endRowIndex': len(df) + 1,
                    'startColumnIndex': feedback_col_index - 1,
                    'endColumnIndex': feedback_col_index
                },
                'rule': {
                    'condition': {
                        'type': 'ONE_OF_LIST',
                        'values': [
                            {'userEnteredValue': 'Correct'},
                            {'userEnteredValue': 'Needs Review'},
                            {'userEnteredValue': 'Wrong'}
                        ]
                    },
                    'showCustomUi': True,
                    'strict': True
                }
            }
        }]
    }
    try:
        sh.batch_update(body)
        print("   Data validation dropdown added to Feedback column.")
    except Exception as e:
        print(f"   Warning: Could not apply data validation: {e}")

    print(f"Successfully uploaded {len(df)} rows to sheet.")

def escape_md(text):
    """Escape special characters for Telegram MarkdownV2."""
    special_chars = r'\_*[]()~`>#+-=|{}.!'
    return ''.join(f'\\{c}' if c in special_chars else c for c in str(text))


def parse_price(val):
    """Normalize any price value to float. Returns 0.0 for empty, N/A, nan, or invalid."""
    try:
        return float(str(val).strip().replace(',', '').replace(' ', ''))
    except (ValueError, TypeError):
        return 0.0


def send_telegram_message(token, chat_id, message):
    """Send a formatted message via Telegram Bot API using MarkdownV2."""
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": message,
        "parse_mode": "MarkdownV2",
        "disable_web_page_preview": False,
    }
    time.sleep(1.5)
    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()
        print("   ✅ Telegram message sent successfully")
        return True
    except requests.exceptions.HTTPError as e:
        if e.response is not None and e.response.status_code == 429:
            print("   ⚠️  Rate limit hit, pausing...")
            time.sleep(10)
            try:
                response = requests.post(url, json=payload, timeout=10)
                response.raise_for_status()
                print("   ✅ Telegram message sent successfully (after retry)")
                return True
            except requests.exceptions.RequestException as retry_err:
                print(f"   ⚠️  Failed after retry: {retry_err}")
                return False
        else:
            print(f"   ⚠️  Failed to send Telegram message: {e}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"   ⚠️  Failed to send Telegram message: {e}")
        return False


def fetch_sheet_as_dataframe(worksheet):
    """Fetch current Google Sheet data into a pandas DataFrame. Returns None if empty."""
    try:
        all_values = worksheet.get_all_values()
        if len(all_values) < 2:
            return None
        headers = all_values[0]
        rows = all_values[1:]
        return pd.DataFrame(rows, columns=headers)
    except Exception as e:
        print(f"⚠️  Could not fetch sheet data for comparison: {e}")
        return None


def detect_and_alert_price_changes(df_old, df_new, token, chat_id):
    """Compare old and new DataFrames by Product_Name_AC and send Telegram alerts for price changes."""
    print(f"\n📊 Comparison baseline: df_old={len(df_old)} rows, df_new={len(df_new)} rows")

    if len(df_new) == 0:
        print("⚠️  Comparison failed: df_new is empty")
        return False
    if len(df_old) == 0:
        print("ℹ️  Comparison skipped: sheet baseline is empty")
        return True
    row_diff_pct = abs(len(df_old) - len(df_new)) / max(len(df_new), 1)
    if row_diff_pct > 0.10:
        print(f"⚠️  Comparison skipped due to data mismatch: df_old={len(df_old)} vs df_new={len(df_new)} ({row_diff_pct:.1%} difference — threshold 10%)")
        return False

    id_col = 'Product_Name_AC'
    if id_col not in df_old.columns or id_col not in df_new.columns:
        print(f"⚠️  '{id_col}' column not found in sheet data, skipping alerts")
        return False

    # Normalise identifier to stripped string
    df_old[id_col] = df_old[id_col].astype(str).str.strip()
    df_new[id_col] = df_new[id_col].astype(str).str.strip()

    # Force numeric conversion for all tracked price columns
    for pc in PRICE_COLUMNS:
        if pc in df_old.columns:
            df_old[pc] = pd.to_numeric(df_old[pc], errors='coerce').fillna(0)
        if pc in df_new.columns:
            df_new[pc] = pd.to_numeric(df_new[pc], errors='coerce').fillna(0)

    # Deduplicate on Product_Name_AC (keeps last occurrence if duplicates exist)
    df_old = df_old.drop_duplicates(subset=[id_col], keep='last')
    df_new = df_new.drop_duplicates(subset=[id_col], keep='last')

    print(f"DEBUG: Comparing {len(df_new)} products by name.")

    link_cols = [col for col in df_new.columns if 'link' in col.lower()]
    pending_alerts = []

    # Build price lookup dicts from df_old keyed by product name
    old_price_maps = {}
    for pc in PRICE_COLUMNS:
        if pc in df_old.columns:
            old_price_maps[pc] = dict(zip(df_old[id_col], df_old[pc]))

    old_names = set(df_old[id_col])
    new_names = set(df_new[id_col])

    for _, row in df_new.iterrows():
        name = row[id_col]
        if not name or name == 'nan':
            continue

        for price_col in PRICE_COLUMNS:
            if price_col not in df_new.columns:
                continue
            new_price = round(float(row.get(price_col, 0) or 0), 2)
            old_price = round(float(old_price_maps.get(price_col, {}).get(name, 0) or 0), 2)

            print(f"DEBUG: Comparing {name} | col={price_col} | Old: {old_price} | New: {new_price}")

            if new_price == 0.0:
                print(f"  → Skip (out-of-stock)")
                continue
            if abs(old_price - new_price) < 0.01:
                print(f"  → Skip (same price)")
                continue

            print(f"  → ALERT: price changed {old_price} → {new_price}")

            store_name = STORE_NAMES.get(price_col, price_col)
            old_display = f"{old_price:.2f}" if old_price != 0.0 else 'N/A'
            new_display = f"{new_price:.2f}"

            links_lines = ''
            for lc in link_cols:
                link_val = str(row.get(lc, '')).strip()
                if link_val and link_val not in ('nan', 'None', ''):
                    links_lines += f'\n  \\- {escape_md(lc)}: {escape_md(link_val)}'
            if not links_lines:
                links_lines = '\n  \\- N/A'

            pending_alerts.append((
                "🚨 *ფასის ცვლილება დეტექტირებულია\\!* 🚨\n"
                f"📦 *პროდუქტი:* {escape_md(name)}\n"
                f"🏦 *მაღაზია:* {escape_md(store_name)}\n"
                f"💰 *ცვლილება:* {escape_md(old_display)} ₾ ➡️ {escape_md(new_display)} ₾\n"
                f"🔗 *ბმულები:*{links_lines}"
            ))

    # Safety cap: > 5 pending alerts → send one consolidated message instead
    alert_count = len(pending_alerts)
    if alert_count == 0:
        print("✅ No price changes detected")
    elif alert_count > 5:
        print(f"⚠️  {alert_count} alerts queued — exceeds safety cap of 5, sending single consolidated notification")
        consolidated = (
            "🚨 *ფასის ცვლილება დეტექტირებულია\\!* 🚨\n"
            f"📦 სულ {escape_md(str(alert_count))} პროდუქტის ფასი შეიცვალა\\.\n"
            "📢 *გთხოვთ, ფასების სხვაობა გუგლ შითში გადაამოწმოთ\\.*"
        )
        if not send_telegram_message(token, chat_id, consolidated):
            return False
        print(f"📨 Sent 1 consolidated alert covering {alert_count} price changes")
    else:
        for msg in pending_alerts:
            if not send_telegram_message(token, chat_id, msg):
                return False
        print(f"📨 Sent {alert_count} Telegram alert(s) for price changes")

    # Detect new products: in df_new but absent from df_old
    new_products = new_names - old_names
    new_products.discard('')
    new_products.discard('nan')
    new_count = len(new_products)

    if new_count > 0:
        print(f"🆕 {new_count} new product(s) detected, sending consolidated alert...")
        message = (
            "✨ *ბაზაში დაემატა ახალი პროდუქცია\\!* ✨\n"
            f"📦 სულ დაემატა: {new_count} ახალი პროდუქცია\\.\n"
            "📢 *გთხოვთ, ფასების სხვაობა და დეტალები გუგლ შითში გადაამოწმოთ\\.*"
        )
        if not send_telegram_message(token, chat_id, message):
            return False
    else:
        print("✅ No new products detected")

    return True


def main():
    # Configuration
    # Use BASE_DIR for cross-platform compatibility
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    source_file = os.path.join(BASE_DIR, 'reports', 'acoustic_vs_mireli.xlsx')
    blacklist_file = os.path.join(script_dir, 'data', 'blacklist.json')
    credentials_file = os.path.join(BASE_DIR, 'credentials.json')
    spreadsheet_id = '1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94'
    tab_name = 'Mireli'

    _ensure_recent_merged_file(source_file)
    
    try:
        # Authenticate with Google Sheets
        print(f"Authenticating with Google Sheets...")
        print(f"Credentials file path: {credentials_file}")
        print(f"Credentials file exists: {os.path.exists(credentials_file)}")
        
        if not os.path.exists(credentials_file):
            raise FileNotFoundError(f"Credentials file not found at: {credentials_file}")
        
        # Load credentials and fix formatting
        with open(credentials_file, 'r') as f:
            info = json.load(f)
            print(f"private_key_id: {info['private_key_id']}")
            print(f"First 10 chars of private_key_id: {info['private_key_id'][:10]}")
            info['private_key'] = info['private_key'].replace('\\n', '\n')
        
        # Authenticate using service_account.Credentials
        scopes = ['https://www.googleapis.com/auth/spreadsheets']
        credentials = service_account.Credentials.from_service_account_info(info, scopes=scopes)
        gc = gspread.authorize(credentials)
        sh = gc.open_by_key(spreadsheet_id)
        
        # Find worksheet by listing all (more reliable than worksheet() method)
        worksheets = sh.worksheets()
        print(f"Available worksheets: {[ws.title for ws in worksheets]}")
        worksheet = None
        for ws in worksheets:
            if ws.title == tab_name:
                worksheet = ws
                print(f"Found existing worksheet '{tab_name}'")
                break
        
        if worksheet is None:
            print(f"Worksheet '{tab_name}' not found, creating it...")
            worksheet = sh.add_worksheet(title=tab_name, rows=1000, cols=20)
            print(f"Created worksheet '{tab_name}'")
        
        # Fetch baseline for Telegram price change comparison
        print("📊 Fetching baseline data for price change comparison...")
        df_old = fetch_sheet_as_dataframe(worksheet)
        if df_old is None:
            print("ℹ️  Sheet is empty or new — skipping price comparison for this run.")

        # Step 1: Update blacklist from sheet
        blacklist = update_blacklist_from_sheet(worksheet, blacklist_file)
        
        # Step 2: Load and filter new data
        print(f"\nLoading new data from {source_file}...")
        df = pd.read_excel(source_file, engine='openpyxl')
        print(f"Loaded {len(df)} rows from Excel file.")
        
        filtered_df = filter_data_against_blacklist(df, blacklist)
        
        if len(filtered_df) == 0:
            print("No data to upload after filtering.")
            return False
        
        # Telegram price change alerts must run before the sheet is overwritten.
        if df_old is not None:
            print("\n📊 Checking for price changes before updating Google Sheets...")
            if not detect_and_alert_price_changes(df_old, filtered_df, TELEGRAM_TOKEN, CHAT_ID):
                print("❌ Comparison/alert checkpoint failed. Aborting before Google Sheet update.")
                return False

        # Step 3: Upload to sheet only after alerts are sent
        upload_to_sheet(filtered_df, worksheet, sh)

        print("\n" + "=" * 80)
        print("SYNC COMPLETED SUCCESSFULLY")
        print("=" * 80)
        print(f"Blacklist entries: {len(blacklist)}")
        print(f"Rows uploaded: {len(filtered_df)}")
        return True
        
    except FileNotFoundError as e:
        print(f"Error: {e}")
        print("Please ensure the source file and credentials exist.")
        return False
    except Exception as e:
        print(f"An error occurred: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    sys.exit(0 if main() else 1)
