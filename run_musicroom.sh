#!/bin/bash

# Musicroom standalone pipeline runner
# Runs the full acmr_main.py pipeline in an infinite loop with 8-hour sleeps.

LOG_FILE="/root/musicroom_loop.log"
PROJECT_DIR="/root/Acoustic-Musicroom"

echo "[DEBUG] Starting run_musicroom.sh script" | tee -a "$LOG_FILE"
echo "[DEBUG] Current directory: $(pwd)" | tee -a "$LOG_FILE"
echo "[DEBUG] Current user: $(whoami)" | tee -a "$LOG_FILE"
echo "[DEBUG] Current time: $(date)" | tee -a "$LOG_FILE"

while true; do
    echo "==========================================================" | tee -a "$LOG_FILE"
    echo "--- ახალი Musicroom ციკლის დასაწყისი: $(date) ---" | tee -a "$LOG_FILE"
    echo "==========================================================" | tee -a "$LOG_FILE"

    echo "[DEBUG] Changing directory to $PROJECT_DIR" | tee -a "$LOG_FILE"
    cd "$PROJECT_DIR" || exit

    echo "[DEBUG] Current directory: $(pwd)" | tee -a "$LOG_FILE"
    echo "ვირტუალური გარემოს აქტივაცია..." | tee -a "$LOG_FILE"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Musicroom..." | tee -a "$LOG_FILE"
    pip install --upgrade pip | tee -a "$LOG_FILE"
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib beautifulsoup4 | tee -a "$LOG_FILE"
    playwright install chromium | tee -a "$LOG_FILE"

    echo "[DEBUG] Virtual environment activated" | tee -a "$LOG_FILE"
    echo "[DEBUG] Python version: $(python --version)" | tee -a "$LOG_FILE"
    echo "[DEBUG] Python path: $(which python)" | tee -a "$LOG_FILE"

    echo "Setting Playwright browsers path for Musicroom..." | tee -a "$LOG_FILE"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musicroom/pw-browsers
    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH" | tee -a "$LOG_FILE"

    echo "ვუშვებ Musicroom სკრიპტს..." | tee -a "$LOG_FILE"
    echo "[DEBUG] Executing: python acmr/acmr_main.py" | tee -a "$LOG_FILE"
    python acmr/acmr_main.py 2>&1 | tee -a "$LOG_FILE"
    MUSICROOM_EXIT_CODE=${PIPESTATUS[0]}

    echo "[DEBUG] Musicroom script exit code: $MUSICROOM_EXIT_CODE" | tee -a "$LOG_FILE"
    echo "გარემოს დეაქტივაცია..." | tee -a "$LOG_FILE"
    deactivate

    if [ $MUSICROOM_EXIT_CODE -ne 0 ]; then
        echo "CRITICAL: MUSICROOM_UPDATE_FAILED - Exit code: $MUSICROOM_EXIT_CODE" | tee -a "$LOG_FILE"
        echo "Waiting 8 hours before retrying..." | tee -a "$LOG_FILE"
    else
        echo "[DEBUG] Musicroom completed successfully" | tee -a "$LOG_FILE"
        echo "Musicroom პროექტი დასრულდა." | tee -a "$LOG_FILE"
    fi

    echo "----------------------------------------------------------" | tee -a "$LOG_FILE"
    echo "--- Musicroom დასრულდა. ვისვენებ 8 საათი... ($(date)) ---" | tee -a "$LOG_FILE"
    echo "[DEBUG] Sleeping for 28800 seconds (8 hours)" | tee -a "$LOG_FILE"
    sleep 28800
    echo "[DEBUG] 8-hour sleep done, starting next cycle ($(date))" | tee -a "$LOG_FILE"
    cd ~
    echo "[DEBUG] Changed directory to: $(pwd)" | tee -a "$LOG_FILE"
done
