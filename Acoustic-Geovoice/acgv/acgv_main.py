#!/usr/bin/env python3
"""
Master Orchestrator for Acoustic & Geovoice Pipeline
Automates the entire workflow from scraping to uploading
"""

import subprocess
import sys
import os
from datetime import datetime

def run_script(script_name, stage_name):
    """Run a Python script with error handling and logging"""
    print(f"\n{'='*60}")
    print(f"--- Stage: {stage_name} Started ---")
    print(f"{'='*60}")
    print(f"Script: {script_name}")
    print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"HEADLESS mode: {os.getenv('HEADLESS', 'true')}")
    
    try:
        result = subprocess.run(
            [sys.executable, script_name],
            check=True,
            capture_output=False,
            text=True,
            cwd=os.path.dirname(script_name),
            env=os.environ  # Pass environment variables (including HEADLESS)
        )
        print(f"\n✓ {stage_name} Completed Successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"\n✗ {stage_name} Failed")
        print(f"Exit Code: {e.returncode}")
        return False
    except Exception as e:
        print(f"\n✗ {stage_name} Failed with Exception: {e}")
        return False

def main():
    """Main pipeline orchestration"""
    print("="*60)
    print("ACOUSTIC & GEOVOICE PIPELINE ORCHESTRATOR")
    print("="*60)
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Define scripts to run in order
    scripts = [
        {
            'path': os.path.join(script_dir, '..', 'scrapers', 'acoustic', 'run_acoustic.py'),
            'name': 'Acoustic Scraping',
            'stage': 1
        },
        {
            'path': os.path.join(script_dir, '..', 'scrapers', 'geovoice', 'run_geovoice.py'),
            'name': 'Geovoice Scraping',
            'stage': 2
        },
        {
            'path': os.path.join(script_dir, 'acgv_data_merger.py'),
            'name': 'Data Merging & Comparison',
            'stage': 3
        },
        {
            'path': os.path.join(script_dir, 'acgv_sheet_uploader.py'),
            'name': 'Google Sheets Upload',
            'stage': 4
        }
    ]
    
    execution_log = {}
    
    # Run each script in sequence
    for script_info in scripts:
        script_path = script_info['path']
        stage_name = script_info['name']
        stage_num = script_info['stage']
        
        # Verify script exists
        if not os.path.exists(script_path):
            print(f"\n✗ Stage {stage_num} Failed: Script not found at {script_path}")
            print("Aborting pipeline...")
            return False
        
        # Run the script
        success = run_script(script_path, stage_name)
        execution_log[stage_name] = success
        
        # Stop if script failed
        if not success:
            print(f"\n{'='*60}")
            print("PIPELINE ABORTED DUE TO FAILURE")
            print(f"{'='*60}")
            return False
    
    # Final Summary
    end_time = datetime.now()
    
    print(f"\n{'='*60}")
    print("PIPELINE EXECUTION SUMMARY:")
    print(f"{'='*60}")
    
    for script_info in scripts:
        stage_name = script_info['name']
        status = "✓ SUCCESS" if execution_log[stage_name] else "✗ FAILED"
        print(f"   {stage_name}: {status}")
    
    print(f"\n{'='*60}")
    print("PIPELINE COMPLETED SUCCESSFULLY")
    print(f"{'='*60}")
    print(f"End Time: {end_time.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Duration: {str(end_time - datetime.strptime(end_time.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S'))}")
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\nPipeline interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n\nCRITICAL ERROR: {e}")
        sys.exit(1)
