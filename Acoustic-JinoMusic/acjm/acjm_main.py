import subprocess
import sys
import os


def run_script(script_path, stage_name, base_dir, required_output_files=None):
    print(f"[DEBUG] --- Starting Stage: {stage_name} ---")
    print(f"[DEBUG] Script path: {script_path}")
    print(f"[DEBUG] Working directory: {base_dir}")
    print(f"[DEBUG] Python executable: {sys.executable}")

    try:
        print(f"[DEBUG] Executing subprocess...")
        result = subprocess.run(
            [sys.executable, script_path],
            check=True,
            cwd=base_dir,
            capture_output=False,
            text=True
        )

        print(f"[DEBUG] Subprocess completed with exit code: {result.returncode}")

        if result.returncode != 0:
            print(f"[ERROR] Stage '{stage_name}' returned non-zero exit code: {result.returncode}")
            return False

        print(f"[DEBUG] Exit code validation passed")

        if required_output_files:
            print(f"[DEBUG] Validating {len(required_output_files)} required output files...")
            for output_file in required_output_files:
                full_path = os.path.join(base_dir, output_file)
                print(f"[DEBUG] Checking file: {output_file}")
                print(f"[DEBUG] Full path: {full_path}")

                if not os.path.exists(full_path):
                    print(f"[ERROR] Required output file not found: {output_file}")
                    return False
                file_size = os.path.getsize(full_path)
                print(f"[DEBUG] File exists, size: {file_size} bytes")

                if file_size == 0:
                    print(f"[ERROR] Required output file is empty: {output_file}")
                    return False
                print(f"[DEBUG] ✓ Output file validated: {output_file} ({file_size} bytes)")

        print(f"[DEBUG] --- Completed Stage: {stage_name} ---")
        return True
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Stage '{stage_name}' failed with exit code {e.returncode}")
        print(f"[ERROR] STDERR: {e.stderr if e.stderr else 'None'}")
        print(f"[ERROR] STDOUT: {e.stdout if e.stdout else 'None'}")
        return False
    except Exception as e:
        print(f"[ERROR] Unexpected error in stage '{stage_name}': {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    print("=" * 80)
    print("ACJM DATA PIPELINE ORCHESTRATOR")
    print("=" * 80)
    print()

    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    print(f"Project root: {BASE_DIR}")
    print()

    stages = [
        ('scrapers/acoustic/run_acoustic.py', 'Scraping Acoustic Data',
         ['scrapers/acoustic/acoustic_final_stock.xlsx', 'scrapers/acoustic/acoustic_cleaned_models.xlsx']),
        ('scrapers/jinomusic/run_jinomusic.py', 'Scraping JinoMusic Data',
         ['scrapers/jinomusic/jinomusic_results.xlsx', 'scrapers/jinomusic/jinomusic_cleaned.xlsx']),
        ('acjm/acjm_data_merger.py', 'Merging Acoustic and JinoMusic Data',
         ['reports/acoustic_vs_jinomusic.xlsx']),
        ('acjm/acjm_sheet_uploader.py', 'Uploading to Google Sheets',
         None)
    ]

    for script_path, stage_name, required_files in stages:
        print(f"\n{'='*80}")
        print(f"STAGE: {stage_name}")
        print(f"{'='*80}")

        if not run_script(script_path, stage_name, BASE_DIR, required_files):
            print()
            print("=" * 80)
            print("PIPELINE FAILED - SCRIPT STOPPED")
            print("=" * 80)
            print(f"Failed at stage: {stage_name}")
            print("This script will NOT continue to the next stage.")
            print("Fix the error and run again.")
            sys.exit(1)
        print()

    print("=" * 80)
    print("PIPELINE COMPLETED SUCCESSFULLY")
    print("=" * 80)
    print()
    print("All stages completed successfully!")
    print()


if __name__ == "__main__":
    main()
