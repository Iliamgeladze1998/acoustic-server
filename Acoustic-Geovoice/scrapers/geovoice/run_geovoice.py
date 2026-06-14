import subprocess
import sys
import os
import pandas as pd
import numpy as np
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from datetime import datetime
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("geovoice_automation.log"),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Get the directory where this script is located
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Configuration
CONFIG = {
    'SPREADSHEET_ID': "1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94",
    'CREDENTIALS_FILE': os.path.join(SCRIPT_DIR, "credentials.json"),
    'GEOVOICE_TAB': "Geovoice"
}

def run_script(script_name):
    """Run a Python script with absolute path and correct working directory."""
    script_path = os.path.join(SCRIPT_DIR, script_name)
    logger.info(f"Executing: {script_path}")
    try:
        result = subprocess.run(
            [sys.executable, script_path],
            check=True,
            capture_output=False,
            text=True,
            cwd=SCRIPT_DIR
        )
        logger.info(f"SUCCESS: {script_name} completed")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"ERROR in {script_name}: Exit code {e.returncode}")
        return False
    except subprocess.TimeoutExpired:
        logger.error(f"TIMEOUT: {script_name} exceeded 1 hour")
        return False
    except Exception as e:
        logger.error(f"FATAL ERROR in {script_name}: {e}")
        return False

def upload_to_geovoice_tab(file_path):
    """Upload report specifically to Geovoice tab with clean formatting."""
    try:
        logger.info(f"Uploading to Geovoice tab: {file_path}")
        
        # Authenticate with Google Sheets
        scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
        creds = ServiceAccountCredentials.from_json_keyfile_name(CONFIG['CREDENTIALS_FILE'], scope)
        client = gspread.authorize(creds)
        
        # Open spreadsheet and get Geovoice tab
        spreadsheet = client.open_by_key(CONFIG['SPREADSHEET_ID'])
        
        # Try to get Geovoice tab, with safety check
        try:
            worksheet = spreadsheet.worksheet(CONFIG['GEOVOICE_TAB'])
            logger.info(f"SUCCESS: Found existing Geovoice tab: {CONFIG['GEOVOICE_TAB']}")
        except gspread.WorksheetNotFound:
            logger.error(f"ERROR: Geovoice tab '{CONFIG['GEOVOICE_TAB']}' not found!")
            logger.error("Please create the 'Geovoice' tab manually in Google Sheets first.")
            logger.error("DO NOT proceed - this prevents accidental overwriting of wrong tab.")
            return False
        
        # Read the report file
        if file_path.endswith('.xlsx'):
            df = pd.read_excel(file_path)
        else:
            df = pd.read_csv(file_path)
        
        # Handle NaN values for JSON compliance
        df = df.replace({np.nan: None, pd.NaT: None})
        df = df.where(pd.notnull(df), None)
        
        # Convert DataFrame to list for upload
        data_to_upload = [df.columns.values.tolist()]
        
        for _, row in df.iterrows():
            row_data = []
            for value in row:
                if pd.isna(value) or value != value:
                    row_data.append(None)
                else:
                    row_data.append(value)
            data_to_upload.append(row_data)
        
        # COMPLETELY RESET Geovoice tab formatting
        logger.info("Resetting Geovoice tab (clearing formatting, filters, and data)...")
        
        # Clear all formatting, filters, and data from Geovoice tab
        worksheet.batch_clear(["A1:Z2000"])
        
        # Remove any active filters
        try:
            worksheet.clear_basic_filter()
            logger.info("SUCCESS: Cleared basic filters on Geovoice tab")
        except:
            logger.info("INFO: No filters to clear on Geovoice tab")
        
        # Complete formatting reset - remove all background colors, styles, etc.
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
            logger.info("SUCCESS: Completely reset all formatting on Geovoice tab (colors, styles, etc.)")
        except Exception as format_error:
            logger.info(f"WARNING: Could not reset all formatting on Geovoice tab: {format_error}")
        
        # Upload fresh data to Geovoice tab
        logger.info("Uploading data to Geovoice tab...")
        worksheet.update(data_to_upload)
        
        # Add timestamp to cell K1 of Geovoice tab
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        try:
            worksheet.update_acell('K1', f'Last Update: {timestamp}')
            logger.info(f"SUCCESS: Timestamp added to Geovoice tab cell K1: Last Update: {timestamp}")
        except Exception as timestamp_error:
            logger.info(f"WARNING: Could not update timestamp on Geovoice tab: {timestamp_error}")
            logger.info("SUCCESS: Data upload to Geovoice tab still successful!")
        
        logger.info(f"SUCCESS: Geovoice tab updated successfully ({len(df)} rows)")
        return True
        
    except Exception as e:
        logger.error(f"Failed to upload to Geovoice tab: {e}")
        return False

def main():
    """Main orchestration for Geovoice workflow - independent pipeline mirroring Acoustic structure."""
    logger.info("="*60)
    logger.info("GEOVOICE AUTOMATION CYCLE STARTED")
    logger.info("="*60)
    
    # Generate session timestamp
    session_ts = datetime.now().strftime("%Y%m%d_%H%M")
    
    logger.info(f"Session timestamp: {session_ts}")
    
    execution_log = {}
    
    # Step 1: Geovoice Link Collection (category pagination)
    print("\n==================== STEP 1: Geovoice Category Link Collection ====================", flush=True)
    execution_log['geovoice_links'] = run_script("geovoice_links.py")
    if not execution_log['geovoice_links']:
        logger.error("Failed to get Geovoice category links. Aborting.")
        return False
    
    # Step 2: Geovoice Product Link Collection (extract product links from categories)
    print("\n==================== STEP 2: Geovoice Product Link Collection ====================", flush=True)
    execution_log['geovoice_product_links'] = run_script("geovoice_all_links.py")
    if not execution_log['geovoice_product_links']:
        logger.error("Failed to get Geovoice product links. Aborting.")
        return False
    
    # Step 3: Geovoice Data Scraping (extract product details)
    print("\n==================== STEP 3: Geovoice Data Scraping ====================", flush=True)
    execution_log['geovoice_scrape'] = run_script("geovoice_scraper.py")
    if not execution_log['geovoice_scrape']:
        logger.error("Geovoice scraping failed. Aborting.")
        return False
    
    # Step 4: Geovoice Data Transformation (clean and standardize)
    print("\n==================== STEP 4: Geovoice Data Transformation ====================", flush=True)
    execution_log['geovoice_transform'] = run_script("transform.py")
    if not execution_log['geovoice_transform']:
        logger.error("Geovoice transformation failed. Aborting.")
        return False
    
    # Final Summary
    end_time = datetime.now()
    
    logger.info("\n" + "="*60)
    logger.info("GEOVOICE EXECUTION SUMMARY:")
    logger.info(f"   Geovoice Category Links: {'OK' if execution_log.get('geovoice_links') else 'FAIL'}")
    logger.info(f"   Geovoice Product Links: {'OK' if execution_log.get('geovoice_product_links') else 'FAIL'}")
    logger.info(f"   Geovoice Scraping: {'OK' if execution_log.get('geovoice_scrape') else 'FAIL'}")
    logger.info(f"   Geovoice Transformation: {'OK' if execution_log.get('geovoice_transform') else 'FAIL'}")
    logger.info(f"\nGEOVOICE CYCLE FINISHED")
    logger.info(f"   End Time: {end_time.strftime('%Y-%m-%d %H:%M:%S')}")
    logger.info("="*60 + "\n")
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except Exception as e:
        logger.critical(f"CRITICAL ERROR: {e}", exc_info=True)
        sys.exit(1)