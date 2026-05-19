import pandas as pd
import json
import requests
import gspread
from google.oauth2 import service_account
from datetime import datetime
import os
import sys
import urllib.parse
from gspread_formatting import CellFormat, Color, TextFormat, format_cell_range, conditionalFormatRule, BooleanRule, BooleanCondition, get_conditional_format_rules, GridRange, Border, Borders

# Telegram Configuration
TELEGRAM_TOKEN = "8835894573:AAGkC2YHR8DnSvmII-bA3fvtO1GaW5CcHFA"
CHAT_ID = "-5276225529"
PRICE_COLUMNS = ['price_ac', 'price_mi']
STORE_NAMES = {
    'price_ac': 'Acoustic',
    'price_mi': 'Mireli',
}

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

def apply_standard_sheet_formatting(worksheet, headers, row_count):
    print("   Applying standardized sheet formatting...")
    if not headers or row_count < 1:
        return
    end_col = column_letter(len(headers))
    full_range = f'A1:{end_col}{row_count}'
    data_range = f'A2:{end_col}{max(row_count, 2)}'
    header_range = f'A1:{end_col}1'
    soft_border = Border('SOLID', Color(0.85, 0.85, 0.85))

    format_cell_range(worksheet, full_range, CellFormat(
        backgroundColor=Color(1, 1, 1),
        textFormat=TextFormat(foregroundColor=Color(0, 0, 0), fontSize=10),
        horizontalAlignment='LEFT',
        borders=Borders(top=soft_border, bottom=soft_border, left=soft_border, right=soft_border)
    ))
    format_cell_range(worksheet, header_range, CellFormat(
        backgroundColor=Color(0.122, 0.306, 0.471),
        textFormat=TextFormat(foregroundColor=Color(1, 1, 1), bold=True, fontSize=10),
        horizontalAlignment='CENTER',
        borders=Borders(top=soft_border, bottom=soft_border, left=soft_border, right=soft_border)
    ))

    for idx, header in enumerate(headers, start=1):
        col = column_letter(idx)
        if header in ['Price_AC', 'Price_MS', 'Price_MIR', 'Price_MR', 'Price_Diff']:
            format_cell_range(worksheet, f'{col}2:{col}{row_count}', CellFormat(horizontalAlignment='RIGHT'))
        elif 'Product_Name' in header or 'Link_' in header:
            format_cell_range(worksheet, f'{col}2:{col}{row_count}', CellFormat(horizontalAlignment='LEFT'))

    target_range = GridRange.from_a1_range(data_range, worksheet)
    id_rule = conditionalFormatRule(
        ranges=[target_range],
        booleanRule=BooleanRule(
            condition=BooleanCondition('CUSTOM_FORMULA', values=[{'userEnteredValue': '=$A2="ID"'}]),
            format=CellFormat(backgroundColor=Color(1.0, 0.949, 0.8))
        )
    )
    model_rule = conditionalFormatRule(
        ranges=[target_range],
        booleanRule=BooleanRule(
            condition=BooleanCondition('CUSTOM_FORMULA', values=[{'userEnteredValue': '=OR($A2="Model",$A2="Fuzzy")'}]),
            format=CellFormat(backgroundColor=Color(0.851, 0.918, 0.827))
        )
    )
    rules = get_conditional_format_rules(worksheet)
    rules.clear()
    rules.append(id_rule)
    rules.append(model_rule)
    rules.save()
    worksheet.freeze(rows=1)
    print("   Standardized formatting applied.")

def upload_to_sheet(df, sheet, sh):
    """Upload data to Google Sheets with formatting."""
    print("Step 3: Uploading filtered data to sheet...")
    
    # Clear existing data
    sheet.clear()
    
    # Remove Match_Score column
    if 'Match_Score' in df.columns:
        df = df.drop(columns=['Match_Score'])
    
    # Encode links for Google Sheets compatibility
    df = encode_links_in_df(df)
    
    # Add empty Feedback column
    df['Feedback'] = ''
    
    # Convert to list of lists (including header)
    data = [df.columns.tolist()] + df.values.tolist()
    
    # Upload data
    sheet.update(data, value_input_option='USER_ENTERED')
    
    # Format header row (bold)
    sheet.format('1:1', {
        'textFormat': {'bold': True},
        'backgroundColor': {'red': 0.9, 'green': 0.9, 'blue': 0.9}
    })
    
    # Set background color of entire data range to Light Yellow 3 (#FFF2CC)
    data_range = f'A1:{chr(64 + len(df.columns))}{len(df) + 1}'
    sheet.format(data_range, {
        'backgroundColor': {'red': 1.0, 'green': 0.95, 'blue': 0.8}
    })
    
    # Re-format header row to override yellow
    sheet.format('1:1', {
        'textFormat': {'bold': True},
        'backgroundColor': {'red': 0.9, 'green': 0.9, 'blue': 0.9}
    })
    
    # Freeze first row
    sheet.freeze(1)
    
    # Add data validation for Feedback column
    feedback_col_index = df.columns.get_loc('Feedback') + 1  # 1-based index
    feedback_col_letter = chr(64 + feedback_col_index)
    feedback_range = f'{feedback_col_letter}2:{feedback_col_letter}{len(df) + 1}'
    
    # Use batch_update to set data validation
    body = {
        'requests': [
            {
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
            }
        ]
    }
    
    sh.batch_update(body)
    apply_standard_sheet_formatting(sheet, df.columns.tolist(), len(df) + 1)
    
    print(f"Successfully uploaded {len(df)} rows to sheet.")
    print("Data validation dropdown added to Feedback column.")

def escape_md(text):
    """Escape special characters for Telegram MarkdownV2."""
    special_chars = r'\_*[]()~`>#+-=|{}.!'
    return ''.join(f'\\{c}' if c in special_chars else c for c in str(text))


def send_telegram_message(token, chat_id, message):
    """Send a formatted message via Telegram Bot API using MarkdownV2."""
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": message,
        "parse_mode": "MarkdownV2",
        "disable_web_page_preview": False,
    }
    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()
        print("   ✅ Telegram message sent successfully")
    except requests.exceptions.RequestException as e:
        print(f"   ⚠️  Failed to send Telegram message: {e}")


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
    """Compare old and new DataFrames by product ID and send Telegram alerts for price changes."""
    id_col = 'product_name_ac'
    if id_col not in df_old.columns or id_col not in df_new.columns:
        print(f"⚠️  '{id_col}' column not found in sheet data, skipping alerts")
        return

    name_col = None
    for col in df_new.columns:
        if 'product_name' in col.lower():
            name_col = col
            break

    link_cols = [col for col in df_new.columns if 'link' in col.lower()]
    price_cols = [c for c in PRICE_COLUMNS if c in df_old.columns and c in df_new.columns]

    if not price_cols:
        print("⚠️  No price columns found for comparison, skipping alerts")
        return

    df_old_indexed = df_old.set_index(id_col)
    changes_found = 0

    for _, new_row in df_new.iterrows():
        product_id = str(new_row.get(id_col, '')).strip()
        if not product_id or product_id not in df_old_indexed.index:
            continue

        old_row = df_old_indexed.loc[product_id]
        if isinstance(old_row, pd.DataFrame):
            old_row = old_row.iloc[0]

        for price_col in price_cols:
            old_val = str(old_row.get(price_col, '')).strip()
            new_val = str(new_row.get(price_col, '')).strip()

            old_val = '' if old_val in ('', 'nan', 'None', '-', 'N/A') else old_val
            new_val = '' if new_val in ('', 'nan', 'None', '-', 'N/A') else new_val

            if old_val == new_val:
                continue

            product_name = str(new_row.get(name_col, product_id)) if name_col else product_id
            store_name = STORE_NAMES.get(price_col, price_col)
            old_display = old_val if old_val else 'N/A'
            new_display = new_val if new_val else 'N/A'

            links_lines = ''
            for lc in link_cols:
                link_val = str(new_row.get(lc, '')).strip()
                if link_val and link_val not in ('nan', 'None', ''):
                    links_lines += f'\n  \\- {escape_md(lc)}: {escape_md(link_val)}'
            if not links_lines:
                links_lines = '\n  \\- N/A'

            message = (
                "🚨 *ფასის ცვლილება დეტექტირებულია\\!* 🚨\n"
                f"📦 *პროდუქტი:* {escape_md(product_name)}\n"
                f"🏦 *მაღაზია:* {escape_md(store_name)}\n"
                f"💰 *ცვლილება:* {escape_md(old_display)} ₾ ➡️ {escape_md(new_display)} ₾\n"
                f"🔗 *ბმულები:*{links_lines}"
            )

            send_telegram_message(token, chat_id, message)
            changes_found += 1

    if changes_found == 0:
        print("✅ No price changes detected")
    else:
        print(f"📨 Sent {changes_found} Telegram alert(s) for price changes")

    # Detect new products: in df_new but absent from df_old
    old_ids = set(df_old_indexed.index.astype(str).str.strip())
    new_ids = set(df_new[id_col].astype(str).str.strip())
    new_products = new_ids - old_ids
    new_products.discard('')
    new_count = len(new_products)

    if new_count > 0:
        print(f"🆕 {new_count} new product(s) detected, sending consolidated alert...")
        message = (
            "✨ *ბაზაში დაემატა ახალი პროდუქცია\\!* ✨\n"
            f"📦 სულ დაემატა: {new_count} ახალი პროდუქტი\\.\n"
            "📢 *გთხოვთ, ფასების სხვაობა და დეტალები გუგლ შითში გადაამოწმოთ\\.*"
        )
        send_telegram_message(token, chat_id, message)
    else:
        print("✅ No new products detected")


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
            return
        
        # Step 3: Upload to sheet
        upload_to_sheet(filtered_df, worksheet, sh)

        # Telegram price change alerts
        if df_old is not None:
            print("\n📊 Checking for price changes...")
            detect_and_alert_price_changes(df_old, filtered_df, TELEGRAM_TOKEN, CHAT_ID)

        print("\n" + "=" * 80)
        print("SYNC COMPLETED SUCCESSFULLY")
        print("=" * 80)
        print(f"Blacklist entries: {len(blacklist)}")
        print(f"Rows uploaded: {len(filtered_df)}")
        
    except FileNotFoundError as e:
        print(f"Error: {e}")
        print("Please ensure the source file and credentials exist.")
    except Exception as e:
        print(f"An error occurred: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
