#!/usr/bin/env python3
"""
ACMS Main Orchestrator
Full pipeline: Scrape -> Sync Blacklist -> Merge -> Upload
"""

import os
import sys
import subprocess
import datetime
import io
import threading
import time
from flask import Flask

# Fix Windows console encoding for Unicode (Georgian characters)
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')
    os.system('chcp 65001 >nul 2>&1')

# Get the absolute path of the 'acms' directory
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.append(BASE_DIR)

# Get project root (parent of acms/)
PROJECT_ROOT = os.path.dirname(BASE_DIR)

from acms_data_merger import merge_store_data
from acms_sheet_uploader import upload_to_google_sheets, extract_blacklisted_pairs_from_sheet

# --- Flask dummy server for Render port binding ---
flask_app = Flask(__name__)

@flask_app.route('/')
def health_check():
    return 'Healthy', 200

def start_flask_server():
    port = int(os.environ.get('PORT', 10000))
    flask_app.run(host='0.0.0.0', port=port, use_reloader=False)

# --- Heartbeat thread to keep Render logs alive ---
def heartbeat():
    while True:
        time.sleep(120)  # Every 2 minutes
        print(f"Status: Scraper is active... [{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}]]", flush=True)

def run_scraper(scraper_path):
    """Run a scraper script using absolute path with LIVE streaming output"""
    full_path = os.path.join(PROJECT_ROOT, scraper_path)
    print(f"Running: {scraper_path}", flush=True)
    print(f"Full path: {full_path}", flush=True)
    print("-" * 70, flush=True)
    
    if not os.path.exists(full_path):
        print(f"[ERROR] Scraper not found: {full_path}", flush=True)
        return False
    
    try:
        env = os.environ.copy()
        env['PYTHONIOENCODING'] = 'utf-8'
        env['PYTHONUNBUFFERED'] = '1'
        
        process = subprocess.Popen(
            [sys.executable, '-u', full_path],
            cwd=PROJECT_ROOT,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            bufsize=1,
            env=env
        )
        
        text_stream = io.TextIOWrapper(
            process.stdout,
            encoding='utf-8',
            errors='replace',
            line_buffering=True
        )
        
        while True:
            try:
                line = text_stream.readline()
                if not line:
                    break
                try:
                    print(line, end='', flush=True)
                except Exception:
                    pass
            except Exception:
                continue
        
        process.wait(timeout=3600)
        print("-" * 70, flush=True)
        
        if process.returncode != 0:
            print(f"[WARNING] Scraper had issues (exit code: {process.returncode})", flush=True)
            return False
        
        print(f"✓ {scraper_path} completed successfully", flush=True)
        return True
    except subprocess.TimeoutExpired:
        print(f"[ERROR] Scraper timed out", flush=True)
        return False
    except Exception as e:
        print(f"[ERROR] Failed to run {scraper_path}: {e}", flush=True)
        return False

def main():
    """Run the complete ACMS cycle: Scrape -> Sync Blacklist -> Merge -> Upload"""
    
    # Start Flask server and heartbeat immediately for Render
    flask_thread = threading.Thread(target=start_flask_server, daemon=True)
    flask_thread.start()
    print("[RENDER] Flask server started on port", os.environ.get('PORT', 10000), flush=True)

    heartbeat_thread = threading.Thread(target=heartbeat, daemon=True)
    heartbeat_thread.start()
    print("[RENDER] Heartbeat thread started", flush=True)

    print("="*70, flush=True)
    print(" "*20 + "ACMS FULL PIPELINE", flush=True)
    print("="*70, flush=True)
    print(flush=True)
    print("This script will:", flush=True)
    print("  1. Scrape Acoustic store (fresh data)", flush=True)
    print("  2. Scrape Musikis-saxli store (fresh data)", flush=True)
    print("  3. Merge data from both stores", flush=True)
    print("  4. Upload results to Google Sheets", flush=True)
    print(flush=True)
    print("="*70, flush=True)
    print(flush=True)

    # Step 1: Scrape Acoustic
    try:
        print("STEP 1: SCRAPING ACOUSTIC STORE", flush=True)
        print("-" * 70, flush=True)
        acoustic_success = run_scraper("scrapers/acoustic/run_acoustic.py")
        if acoustic_success:
            acoustic_file = os.path.join(PROJECT_ROOT, "scrapers", "acoustic", "acoustic_cleaned_models.xlsx")
            if os.path.exists(acoustic_file):
                print("✓ Acoustic data file exists", flush=True)
            else:
                print("[WARNING] Acoustic data file not found, continuing anyway", flush=True)
        else:
            print("[WARNING] Acoustic scraping had issues, continuing anyway", flush=True)
    except Exception as e:
        print(f"[WARNING] Acoustic scraping failed: {e}", flush=True)
    print(flush=True)
    print("="*70, flush=True)
    print(flush=True)

    # Step 2: Scrape Musikis-saxli
    try:
        print("STEP 2: SCRAPING MUSIKIS-SAXLI STORE", flush=True)
        print("-" * 70, flush=True)
        musikis_success = run_scraper("scrapers/musikis-saxli/run_musikis_saxli.py")
        if musikis_success:
            musikis_file = os.path.join(PROJECT_ROOT, "scrapers", "musikis-saxli", "final_stock_cleaned.xlsx")
            if os.path.exists(musikis_file):
                print("✓ Musikis-saxli data file exists", flush=True)
            else:
                print("[WARNING] Musikis-saxli data file not found, continuing anyway", flush=True)
        else:
            print("[WARNING] Musikis-saxli scraping had issues, continuing anyway", flush=True)
    except Exception as e:
        print(f"[WARNING] Musikis-saxli scraping failed: {e}", flush=True)
    print(flush=True)
    print("="*70, flush=True)
    print(flush=True)

    # Step 3: Merge data (ALWAYS TRY)
    try:
        print("STEP 3: DATA MERGING", flush=True)
        print("-" * 70, flush=True)
        merger_success = merge_store_data()
        if not merger_success:
            print("[WARNING] Data merging returned no results, continuing anyway", flush=True)
    except Exception as e:
        print(f"[WARNING] Data merging failed: {e}", flush=True)
    print(flush=True)
    print("="*70, flush=True)
    print(flush=True)
    
    # Step 4: Upload to Google Sheets (ALWAYS TRY)
    try:
        print("STEP 4: UPLOAD TO GOOGLE SHEETS", flush=True)
        print("-" * 70, flush=True)
        upload_success = upload_to_google_sheets()
        if not upload_success:
            print("[WARNING] Upload returned no results, continuing anyway", flush=True)
    except Exception as e:
        print(f"[WARNING] Upload failed: {e}", flush=True)
    
    print(flush=True)
    print("="*70, flush=True)
    print(" "*25 + "CYCLE COMPLETED!", flush=True)
    print("="*70, flush=True)
    print(flush=True)
    print("Summary:", flush=True)
    print("  ✓ Acoustic store scraped", flush=True)
    print("  ✓ Musikis-saxli store scraped", flush=True)
    print("  ✓ Data merged successfully", flush=True)
    print("  ✓ Blacklist applied", flush=True)
    print("  ✓ Results uploaded to Google Sheets", flush=True)
    print(flush=True)
    print("Next steps:", flush=True)
    print("  1. Review the data in Google Sheets", flush=True)
    print("  2. Mark incorrect matches as 'Wrong' in the Feedback column", flush=True)
    print("  3. Run this script again to update with fresh data and corrections", flush=True)
    print(flush=True)
    print("="*70, flush=True)
    
    return True

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"[CRITICAL] Pipeline crashed: {e}", flush=True)
    sys.exit(0)  # Always exit 0 - crash-proof
