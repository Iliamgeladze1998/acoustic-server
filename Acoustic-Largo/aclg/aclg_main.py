#!/usr/bin/env python3
"""
ACLG Main Orchestrator
Full pipeline: Scrape -> Merge -> Upload
"""

import os
import sys
import subprocess
import datetime
import ioონი 
import threading
import time
from flask import Flask

if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')
    os.system('chcp 65001 >nul 2>&1')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

flask_app = Flask(__name__)

@flask_app.route('/')
def health_check():
    return 'Healthy', 200

def start_flask_server():
    port = int(os.environ.get('PORT', 10000))
    flask_app.run(host='0.0.0.0', port=port, use_reloader=False)

def heartbeat():
    while True:
        time.sleep(120)
        print(f"Status: Scraper is active... [{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}]", flush=True)

def run_scraper(scraper_path):
    """Run a scraper script using absolute path with LIVE streaming output"""
    full_path = os.path.join(BASE_DIR, scraper_path)
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
            cwd=BASE_DIR,
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

        process.wait()
        print("-" * 70, flush=True)

        if process.returncode != 0:
            print(f"[WARNING] Scraper had issues (exit code: {process.returncode})", flush=True)
            return False

        print(f"✓ {scraper_path} completed successfully", flush=True)
        return True
    except Exception as e:
        print(f"[ERROR] Failed to run {scraper_path}: {e}", flush=True)
        return False


def validate_output_files(base_dir, required_files):
    """Check that required output files exist and are non-empty."""
    if not required_files:
        return True
    for output_file in required_files:
        full_path = os.path.join(base_dir, output_file)
        if not os.path.exists(full_path):
            print(f"[ERROR] Required output file not found: {output_file}", flush=True)
            return False
        file_size = os.path.getsize(full_path)
        if file_size == 0:
            print(f"[ERROR] Required output file is empty: {output_file}", flush=True)
            return False
        print(f"✓ Output file validated: {output_file} ({file_size} bytes)", flush=True)
    return True


def main():
    """Run the complete ACLG cycle: Scrape -> Merge -> Upload"""

    flask_thread = threading.Thread(target=start_flask_server, daemon=True)
    flask_thread.start()
    print("[RENDER] Flask server started on port", os.environ.get('PORT', 10000), flush=True)

    heartbeat_thread = threading.Thread(target=heartbeat, daemon=True)
    heartbeat_thread.start()
    print("[RENDER] Heartbeat thread started", flush=True)

    print("=" * 70, flush=True)
    print(" " * 20 + "ACLG FULL PIPELINE", flush=True)
    print("=" * 70, flush=True)
    print(flush=True)
    print("This script will:", flush=True)
    print("  1. Scrape Acoustic store (fresh data)", flush=True)
    print("  2. Scrape Largo store (fresh data)", flush=True)
    print("  3. Merge data from both stores", flush=True)
    print("  4. Upload results to Google Sheets", flush=True)
    print(flush=True)
    print("=" * 70, flush=True)
    print(flush=True)

    stages = [
        ('scrapers/acoustic/run_acoustic.py', 'SCRAPING ACOUSTIC STORE',
         ['scrapers/acoustic/acoustic_final_stock.xlsx', 'scrapers/acoustic/acoustic_cleaned_models.xlsx']),
        ('scrapers/largo/run_largo.py', 'SCRAPING LARGO STORE',
         ['scrapers/largo/largo_results.xlsx', 'scrapers/largo/largo_cleaned.xlsx']),
        ('aclg/aclg_data_merger.py', 'DATA MERGING',
         ['reports/acoustic_vs_largo.xlsx']),
        ('aclg/aclg_sheet_uploader.py', 'UPLOAD TO GOOGLE SHEETS',
         None)
    ]

    for step_num, (script_path, stage_name, required_files) in enumerate(stages, 1):
        print(f"\n{'='*70}", flush=True)
        print(f"STEP {step_num}: {stage_name}", flush=True)
        print(f"{'='*70}", flush=True)

        success = run_scraper(script_path)
        if not success:
            print(f"\n[ERROR] {stage_name} failed. Stopping pipeline.", flush=True)
            sys.exit(1)

        if not validate_output_files(BASE_DIR, required_files):
            print(f"\n[ERROR] Output validation failed for {stage_name}. Stopping pipeline.", flush=True)
            sys.exit(1)

        print(flush=True)

    print("=" * 70, flush=True)
    print(" " * 25 + "CYCLE COMPLETED!", flush=True)
    print("=" * 70, flush=True)
    print(flush=True)
    print("Summary:", flush=True)
    print("  ✓ Acoustic store scraped", flush=True)
    print("  ✓ Largo store scraped", flush=True)
    print("  ✓ Data merged successfully", flush=True)
    print("  ✓ Blacklist applied", flush=True)
    print("  ✓ Results uploaded to Google Sheets", flush=True)
    print(flush=True)
    print("=" * 70, flush=True)

    return True


if __name__ == "__main__":
    try:
        sys.exit(0 if main() else 1)
    except Exception as e:
        print(f"[CRITICAL] Pipeline crashed: {e}", flush=True)
        sys.exit(1)
