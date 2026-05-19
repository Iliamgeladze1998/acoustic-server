#!/usr/bin/env python3
"""
ACMR Main Automation Script
Orchestrates the full pipeline: Acoustic scraper → Musicroom scraper → Data merger → Sheet uploader
"""

import os
import sys
import io
import subprocess
from datetime import datetime
from zoneinfo import ZoneInfo

# Force UTF-8 encoding for stdout to handle Georgian characters
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

def get_georgia_timestamp():
    """Get current time in Georgia (UTC+4)"""
    return datetime.now(ZoneInfo("Asia/Tbilisi")).strftime("%H:%M")

def log(message):
    """Print timestamped message"""
    timestamp = get_georgia_timestamp()
    print(f"[{timestamp}] {message}", flush=True)

def run_script(script_path, description):
    """Run a Python script and return success status"""
    log(f"Starting {description}...")
    
    try:
        result = subprocess.run(
            [sys.executable, script_path],
            stdout=sys.stdout,
            stderr=sys.stderr,
            check=True
        )
        
        log(f"✅ Finished {description}")
        return True
        
    except subprocess.CalledProcessError as e:
        log(f"❌ {description} FAILED with exit code {e.returncode}")
        return False
    except Exception as e:
        log(f"❌ {description} FAILED: {e}")
        return False

def main():
    """Main execution pipeline"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    print("=" * 70)
    log("ACMR AUTOMATION PIPELINE STARTED")
    print("=" * 70)
    
    # Define scripts in execution order
    scripts = [
        (os.path.join(project_root, "scrapers", "acoustic", "run_acoustic.py"), "Acoustic scraper"),
        (os.path.join(project_root, "scrapers", "musicroom", "run_musicroom.py"), "Musicroom scraper"),
        (os.path.join(script_dir, "acmr_data_merger.py"), "Data merger"),
        (os.path.join(script_dir, "acmr_sheet_uploader.py"), "Sheet uploader"),
    ]
    
    # Execute each script in sequence
    for script_path, description in scripts:
        if not os.path.exists(script_path):
            log(f"❌ Script not found: {script_path}")
            return 1
        
        if not run_script(script_path, description):
            log("Pipeline stopped due to error.")
            return 1
        
        print("-" * 70)
    
    print("=" * 70)
    log("🎉 ALL STAGES COMPLETED SUCCESSFULLY!")
    print("=" * 70)
    return 0

if __name__ == "__main__":
    sys.exit(main())
