#!/usr/bin/env python3
"""
Google Sheets Uploader for Acoustic & Geovoice Price Comparison
Uploads comparison data to Geovoice tab with self-learning blacklist logic
"""

import os
import sys
import json
import pandas as pd
import numpy as np
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from datetime import datetime
import pytz

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

def save_blacklist(blacklist):
    """Save blacklisted pairs to JSON file"""
    blacklist_file = os.path.join(os.path.dirname(__file__), 'data', 'blacklist.json')
    os.makedirs(os.path.dirname(blacklist_file), exist_ok=True)
    
    with open(blacklist_file, 'w', encoding='utf-8') as f:
        json.dump(blacklist, f, indent=2, ensure_ascii=False)

def is_pair_blacklisted(link_ac, link_gv, blacklist):
    """Check if a pair of links is blacklisted"""
    return any(
        item["link_ac"] == link_ac and item["link_gv"] == link_gv 
        for item in blacklist
    )

def upload_to_geovoice_tab():
    """Upload comparison data to Geovoice tab with self-learning logic"""
    
    print("=== GEOVOICE TAB UPLOADER ===")
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Configuration
    script_dir = os.path.dirname(__file__)
    credentials_file = os.path.join(script_dir, '..', 'credentials.json')
    spreadsheet_id = "1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
    tab_name = "Geovoice"
    comparison_file = os.path.join(script_dir, '..', 'reports', 'acoustic_geovoice_comparison.xlsx')
    
    # Step 1: Load existing blacklist
    print("\n1. Loading blacklist...")
    blacklist = load_blacklist()
    print(f"   Loaded {len(blacklist)} blacklisted pairs")
    
    # Step 2: Load comparison data
    print("\n2. Loading comparison data...")
    try:
        df = pd.read_excel(comparison_file)
        print(f"   Loaded {len(df)} comparison rows")
    except Exception as e:
        print(f"   ERROR: Failed to load comparison file: {e}")
        return False
    
    # Step 3: Authenticate with Google Sheets
    print("\n3. Authenticating with Google Sheets...")
    try:
        client = gspread.service_account(filename=credentials_file)
        print("   Authentication successful")
    except Exception as e:
        print(f"   ERROR: Authentication failed: {e}")
        return False
    
    # Step 4: Open spreadsheet and get Geovoice tab
    print("\n4. Opening spreadsheet...")
    try:
        spreadsheet = client.open_by_key(spreadsheet_id)
        worksheet = spreadsheet.worksheet(tab_name)
        print(f"   Found '{tab_name}' tab")
    except gspread.WorksheetNotFound:
        print(f"   ERROR: Tab '{tab_name}' not found!")
        print("   Please create the tab manually in Google Sheets first.")
        return False
    except Exception as e:
        print(f"   ERROR: Failed to open spreadsheet: {e}")
        return False
    
    # Step 5: Read existing data to learn from Feedback column
    print("\n5. Reading existing data for self-learning...")
    try:
        existing_data = worksheet.get_all_records()
        print(f"   Read {len(existing_data)} existing rows")
        
        # Check for 'Wrong' feedback and add to blacklist
        new_blacklist_entries = []
        for row in existing_data:
            feedback = row.get('Feedback', '')
            if feedback and str(feedback).strip().lower() == 'wrong':
                link_ac = row.get('Link_AC', '')
                link_gv = row.get('Link_GV', '')
                
                if link_ac and link_gv and not is_pair_blacklisted(link_ac, link_gv, blacklist):
                    new_blacklist_entries.append({
                        "link_ac": link_ac,
                        "link_gv": link_gv,
                        "reason": "Feedback marked as Wrong",
                        "timestamp": datetime.now(pytz.timezone('Asia/Tbilisi')).strftime('%Y-%m-%d %H:%M:%S')
                    })
        
        if new_blacklist_entries:
            blacklist.extend(new_blacklist_entries)
            save_blacklist(blacklist)
            print(f"   Added {len(new_blacklist_entries)} new entries to blacklist")
        else:
            print("   No new blacklist entries found")
            
    except Exception as e:
        print(f"   WARNING: Could not read existing data: {e}")
        print("   Continuing without self-learning update")
    
    # Step 6: Filter new data against blacklist
    print("\n6. Filtering new data against blacklist...")
    original_count = len(df)
    
    if blacklist:
        df_filtered = df[~df.apply(
            lambda row: is_pair_blacklisted(
                row.get('Link_AC', ''), 
                row.get('Link_GV', ''), 
                blacklist
            ), axis=1
        )]
        filtered_count = original_count - len(df_filtered)
        print(f"   Filtered out {filtered_count} blacklisted pairs")
        df = df_filtered
    else:
        print("   No blacklist filtering needed")
    
    # Step 7: Prepare data for upload
    print("\n7. Preparing data for upload...")
    
    # Ensure required columns exist
    required_columns = [
        'Matching_Style', 'Match_Key', 'Product_Name_AC', 'Product_Name_GV',
        'Price_AC', 'Price_GV', 'Price_Diff', 'Link_AC', 'Link_GV',
        'Last_Updated', 'Feedback'
    ]
    
    # Add missing columns with empty values
    for col in required_columns:
        if col not in df.columns:
            df[col] = ''
    
    # Set row-level timestamps with Tbilisi timezone
    tbilisi_time = datetime.now(pytz.timezone('Asia/Tbilisi')).strftime('%Y-%m-%d %H:%M:%S')
    df['Last_Updated'] = tbilisi_time
    
    # Select only required columns in correct order
    df_upload = df[required_columns].copy()
    
    # Handle NaN values for JSON compliance
    df_upload = df_upload.replace({np.nan: None, pd.NaT: None})
    df_upload = df_upload.where(pd.notnull(df_upload), None)
    
    # Convert DataFrame to list for upload
    data_to_upload = [required_columns]
    
    for _, row in df_upload.iterrows():
        row_data = []
        for value in row:
            if pd.isna(value) or value != value:
                row_data.append(None)
            else:
                row_data.append(value)
        data_to_upload.append(row_data)
    
    print(f"   Prepared {len(data_to_upload) - 1} rows for upload")
    
    # Step 8: Clear and reset Geovoice tab
    print("\n8. Clearing and resetting Geovoice tab...")
    try:
        # Clear all data and formatting
        worksheet.batch_clear(["A1:Z2000"])
        
        # Remove any active filters
        try:
            worksheet.clear_basic_filter()
            print("   Cleared basic filters")
        except:
            print("   No filters to clear")
        
        # Reset formatting
        try:
            worksheet_id = worksheet._properties['sheetId']
            body = {
                "requests": [
                    {
                        "updateCells": {
                            "range": {"sheetId": worksheet_id},
                            "fields": "userEnteredFormat"
                        }
                    }
                ]
            }
            spreadsheet.batch_update(body)
            print("   Reset all formatting")
        except Exception as format_error:
            print(f"   WARNING: Could not reset formatting: {format_error}")
            
    except Exception as e:
        print(f"   WARNING: Could not clear tab: {e}")
    
    # Step 9: Upload fresh data
    print("\n9. Uploading data to Geovoice tab...")
    try:
        worksheet.update(data_to_upload)
        print(f"   Successfully uploaded {len(df_upload)} rows")
    except Exception as e:
        print(f"   ERROR: Upload failed: {e}")
        return False
    
    # Step 10: Add visual enhancements
    print("\n10. Adding visual enhancements...")
    worksheet_id = worksheet._properties['sheetId']
    num_rows = min(len(df_upload) + 1, 300)  # Cap at 300 for safety
    
    # 1. Global background: Light Yellow for entire used range
    print("   Applying Light Yellow background...")
    try:
        body = {
            "requests": [{
                "repeatCell": {
                    "range": {
                        "sheetId": worksheet_id,
                        "startRowIndex": 0,
                        "endRowIndex": num_rows,
                        "startColumnIndex": 0,
                        "endColumnIndex": 12
                    },
                    "cell": {
                        "userEnteredFormat": {
                            "backgroundColor": {
                                "red": 1.0,
                                "green": 1.0,
                                "blue": 0.8  # Light Yellow
                            }
                        }
                    },
                    "fields": "userEnteredFormat(backgroundColor)"
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Light Yellow background applied")
    except Exception as e:
        print(f"   ✗ Failed to apply Light Yellow background: {e}")
    
    # 2. Conditional formatting: Light Green for rows where Price_AC > 0 and Price_GV > 0
    print("   Applying conditional formatting...")
    try:
        body = {
            "requests": [{
                "addConditionalFormatRule": {
                    "rule": {
                        "ranges": [{
                            "sheetId": worksheet_id,
                            "startRowIndex": 1,  # Skip header
                            "endRowIndex": num_rows,
                            "startColumnIndex": 0,
                            "endColumnIndex": 11  # Columns A-K
                        }],
                        "booleanRule": {
                            "condition": {
                                "type": "CUSTOM_FORMULA",
                                "formula": "=AND($E2>0, $F2>0)"
                            },
                            "format": {
                                "backgroundColor": {
                                    "red": 0.85,
                                    "green": 0.92,
                                    "blue": 0.83  # Light Green
                                }
                            }
                        }
                    },
                    "index": 0
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Conditional formatting applied")
    except Exception as e:
        print(f"   ✗ Failed to apply conditional formatting: {e}")
    
    # 3. Data validation for Feedback column (Column K)
    print("   Adding dropdown validation...")
    try:
        body = {
            "requests": [{
                "setDataValidation": {
                    "range": {
                        "sheetId": worksheet_id,
                        "startRowIndex": 1,  # Skip header
                        "endRowIndex": num_rows,
                        "startColumnIndex": 10,  # Column K (0-indexed)
                        "endColumnIndex": 11
                    },
                    "rule": {
                        "condition": {
                            "type": "ONE_OF_LIST",
                            "values": [
                                {"userEnteredValue": "Correct"},
                                {"userEnteredValue": "Needs Review"},
                                {"userEnteredValue": "Wrong"}
                            ]
                        },
                        "strict": True,
                        "showCustomUi": True
                    }
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Dropdown validation applied")
    except Exception as e:
        print(f"   ✗ Failed to apply dropdown validation: {e}")
    
    # 4. Freeze first row
    print("   Freezing header row...")
    try:
        body = {
            "requests": [{
                "updateSheetProperties": {
                    "properties": {
                        "sheetId": worksheet_id,
                        "gridProperties": {
                            "frozenRowCount": 1
                        }
                    },
                    "fields": "gridProperties.frozenRowCount"
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Header row frozen")
    except Exception as e:
        print(f"   ✗ Failed to freeze header row: {e}")
    
    # 5. Distinct header color for Feedback column (Column K, row 1)
    print("   Coloring Feedback header...")
    try:
        body = {
            "requests": [{
                "updateCells": {
                    "range": {
                        "sheetId": worksheet_id,
                        "startRowIndex": 0,
                        "endRowIndex": 1,
                        "startColumnIndex": 10,
                        "endColumnIndex": 11
                    },
                    "rows": [{
                        "values": [{
                            "userEnteredFormat": {
                                "backgroundColor": {
                                    "red": 0.6,
                                    "green": 0.6,
                                    "blue": 1.0  # Light Blue/Purple for Feedback header
                                },
                                "textFormat": {
                                    "bold": True
                                }
                            }
                        }]
                    }],
                    "fields": "userEnteredFormat"
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Feedback header colored")
    except Exception as e:
        print(f"   ✗ Failed to color Feedback header: {e}")
    
    # Step 11: Add timestamp
    print("\n11. Adding timestamp...")
    try:
        timestamp = datetime.now(pytz.timezone('Asia/Tbilisi')).strftime("%Y-%m-%d %H:%M:%S")
        worksheet.update_acell('L1', f'Last Update: {timestamp}')
        print(f"   Timestamp added: {timestamp}")
    except Exception as e:
        print(f"   WARNING: Could not add timestamp: {e}")
    
    print("\n=== UPLOAD COMPLETED SUCCESSFULLY ===")
    print(f"   Total rows uploaded: {len(df_upload)}")
    print(f"   Blacklist size: {len(blacklist)}")
    print(f"   Timestamp: {datetime.now(pytz.timezone('Asia/Tbilisi')).strftime('%Y-%m-%d %H:%M:%S')}")
    
    return True

if __name__ == "__main__":
    success = upload_to_geovoice_tab()
    sys.exit(0 if success else 1)
