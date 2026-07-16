#!/bin/bash

# ── Logging setup ────────────────────────────────────────────────────────
LOG_FILE="/root/scrapers_detailed.log"
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Starting run_scrapers.sh script"
log "Current directory: $(pwd)"
log "Current user: $(whoami)"
log "Current time: $(date)"
log "Memory: $(free -h | grep Mem | awk '{print $3 "/" $2}')"

# ── Signal trap — ლოგირება თუ სკრიპტს მოკლავენ ───────────────────────────
trap 'log "WARNING: Received SIGTERM — script was killed externally"' SIGTERM
trap 'log "WARNING: Received SIGHUP — terminal closed or disconnected"' SIGHUP
trap 'log "WARNING: Received SIGINT — Ctrl+C pressed"' SIGINT

# ── Error logger — თუ სკრიპტი გაჩერდება, ჩაიწეროს მიზეზი ──────────────────
log_error_and_exit() {
    local exit_code=$1
    local project=$2
    log "CRITICAL: $project FAILED with exit code $exit_code"
    log "Memory at failure: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
    log "Running processes at failure:"
    ps aux | grep -E 'python|chromium|camoufox|playwright' | grep -v grep >> "$LOG_FILE" 2>&1
    log "=== Script stopped at $(date) ==="
    exit $exit_code
}

# ── Memory-safe sleep — არ დაუშვებს OOM-ს sleep-ის დროს ─────────────────────
safe_sleep() {
    local total_seconds=$1
    local elapsed=0
    while [ $elapsed -lt $total_seconds ]; do
        sleep 60
        elapsed=$((elapsed + 60))
        # თუ მეხსიერება ძალიან დაბალია, მოკვდება leftover პროცესები
        local avail=$(free -m | grep Mem | awk '{print $7}')
        if [ "$avail" -lt 500 ] 2>/dev/null; then
            log "WARNING: Low memory during sleep (${avail}MB available). Killing leftover browsers."
            pkill -f "chromium" 2>/dev/null || true
            pkill -f "camoufox" 2>/dev/null || true
            pkill -f "firefox" 2>/dev/null || true
            sleep 5
            log "Memory after cleanup: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
        fi
    done
}

# უსასრულო ციკლი
while true; do
    log "=========================================================="
    log "--- ახალი სრული ციკლის დასაწყისი: $(date) ---"
    log "=========================================================="

    # --- ნაწილი 1: LARGO & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 1: Largo & Acoustic (VENV) ---"
    echo "1. ვიწყებ Largo პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Largo"
    cd ~/Acoustic-Largo || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Largo..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests rapidfuzz gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib flask beautifulsoup4 pytz

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "ვუშვებ Largo სკრიპტს..."
    echo "[DEBUG] Executing: python aclg/aclg_main.py"
    python aclg/aclg_main.py
    LARGO_EXIT_CODE=$?

    echo "[DEBUG] Largo script exit code: $LARGO_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $LARGO_EXIT_CODE -ne 0 ]; then
        log_error_and_exit $LARGO_EXIT_CODE "LARGO_UPDATE_FAILED"
    fi

    log "Largo completed successfully"
    log "Largo პროექტი დასრულდა."
    log "----------------------------------------------------------"

    log "--- Largo დასრულდა. ვისვენებ 4 საათი... ($(date)) ---"
    safe_sleep 14400
    log "4-hour sleep done, starting JinoMusic ($(date))"
    log "=========================================================="

    # --- ნაწილი 2: JINOMUSIC & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 2: JinoMusic & Acoustic (VENV) ---"
    echo "2. ვიწყებ JinoMusic პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-JinoMusic"
    cd ~/Acoustic-JinoMusic || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for JinoMusic..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests rapidfuzz gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib flask beautifulsoup4 "camoufox[geoip]" pillow pytz
    python -m camoufox fetch

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Cleaning up stale Camoufox processes for JinoMusic..."
    pkill -f "camoufox.*Acoustic-JinoMusic" 2>/dev/null || true
    sleep 2
    echo "[DEBUG] Camoufox cleanup completed"

    echo "ვუშვებ JinoMusic სკრიპტს..."
    echo "[DEBUG] Executing: python acjm/acjm_main.py"
    python acjm/acjm_main.py
    JINOMUSIC_EXIT_CODE=$?

    echo "[DEBUG] JinoMusic script exit code: $JINOMUSIC_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $JINOMUSIC_EXIT_CODE -ne 0 ]; then
        log_error_and_exit $JINOMUSIC_EXIT_CODE "JINOMUSIC_UPDATE_FAILED"
    fi

    log "JinoMusic completed successfully"
    log "JinoMusic პროექტი დასრულდა."
    log "----------------------------------------------------------"

    log "--- JinoMusic დასრულდა. ვისვენებ 4 საათი... ($(date)) ---"
    safe_sleep 14400
    log "4-hour sleep done, starting Music House ($(date))"
    log "=========================================================="

    # --- ნაწილი 3: MUSIC HOUSE & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 3: Music House & Acoustic (VENV) ---"
    echo "3. ვიწყებ Music House პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Musikissaxli"
    cd ~/Acoustic-Musikissaxli || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Music House..."
    pip install --upgrade pip
    pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib flask playwright
    pip install playwright
    playwright install chromium

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Music House..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musikissaxli/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musikissaxli/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"

    echo "Cleaning up stale Playwright/Chromium processes for Music House..."
    pkill -f "/root/Acoustic-Musikissaxli/pw-browsers" 2>/dev/null || true
    pkill -f "playwright.*Acoustic-Musikissaxli" 2>/dev/null || true
    sleep 2
    echo "[DEBUG] Playwright/Chromium cleanup completed"

    echo "ვუშვებ Music House სკრიპტს..."
    echo "[DEBUG] Executing: python acms/acms_main.py"
    python acms/acms_main.py
    MUSIC_HOUSE_EXIT_CODE=$?

    echo "[DEBUG] Music House script exit code: $MUSIC_HOUSE_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $MUSIC_HOUSE_EXIT_CODE -ne 0 ]; then
        log_error_and_exit $MUSIC_HOUSE_EXIT_CODE "MUSIC_HOUSE_UPDATE_FAILED"
    fi

    log "Music House completed successfully"
    log "Music House პროექტი დასრულდა."
    log "----------------------------------------------------------"

    log "--- Music House დასრულდა. ვისვენებ 4 საათი... ($(date)) ---"
    safe_sleep 14400
    log "4-hour sleep done, starting Musicroom ($(date))"
    log "=========================================================="

    # --- ნაწილი 4: MUSICROOM & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 4: Musicroom & Acoustic (VENV) ---"
    echo "4. ვიწყებ Musicroom პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Musicroom"
    cd ~/Acoustic-Musicroom || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Musicroom..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib beautifulsoup4 "camoufox[geoip]" pillow
    playwright install chromium
    python -m camoufox fetch

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Musicroom..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musicroom/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musicroom/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"

    echo "ვუშვებ Musicroom სკრიპტს..."
    echo "[DEBUG] Executing: python acmr/acmr_main.py"
    python acmr/acmr_main.py
    MUSICROOM_EXIT_CODE=$?

    echo "[DEBUG] Musicroom script exit code: $MUSICROOM_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $MUSICROOM_EXIT_CODE -ne 0 ]; then
        log_error_and_exit $MUSICROOM_EXIT_CODE "MUSICROOM_UPDATE_FAILED"
    fi

    log "Musicroom completed successfully"
    log "Musicroom პროექტი დასრულდა."
    log "----------------------------------------------------------"

    log "--- Musicroom დასრულდა. ვისვენებ 4 საათი... ($(date)) ---"
    safe_sleep 14400
    log "4-hour sleep done, starting Geovoice ($(date))"
    log "=========================================================="

    # --- ნაწილი 5: GEOVOICE & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 5: Geovoice & Acoustic (VENV) ---"
    echo "5. ვიწყებ Geovoice პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Geovoice"
    cd ~/Acoustic-Geovoice || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Geovoice..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib cloudscraper beautifulsoup4 rapidfuzz
    playwright install chromium

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Geovoice..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Geovoice/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Geovoice/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"
    echo "ვუშვებ Geovoice სკრიპტს..."
    echo "[DEBUG] Executing: python acgv/acgv_main.py"
    python acgv/acgv_main.py
    GEOVOICE_EXIT_CODE=$?

    echo "[DEBUG] Geovoice script exit code: $GEOVOICE_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $GEOVOICE_EXIT_CODE -ne 0 ]; then
        log_error_and_exit $GEOVOICE_EXIT_CODE "GEOVOICE_UPDATE_FAILED"
    fi

    log "Geovoice completed successfully"
    log "Geovoice პროექტი დასრულდა."
    log "----------------------------------------------------------"

    log "--- Geovoice დასრულდა. ვისვენებ 4 საათი... ($(date)) ---"
    safe_sleep 14400
    log "4-hour sleep done, starting Mireli ($(date))"
    log "=========================================================="

    # --- ნაწილი 6: ACOUSTIC MIRELI (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 6: Acoustic Mireli (VENV) ---"
    echo "6. ვიწყებ Mireli-ს პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Mireli"
    cd ~/Acoustic-Mireli || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    # აქტივაცია უზრუნველყოფს, რომ ყველა ქვე-სკრიპტმა დაინახოს Playwright
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Mireli..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib
    pip install gspread-formatting
    playwright install chromium

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Mireli..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Mireli/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Mireli/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"
    echo "ვუშვებ Mireli სკრიპტს..."
    echo "[DEBUG] Executing: python acmi/acmi_main.py"
    python acmi/acmi_main.py
    MIRELI_EXIT_CODE=$?

    echo "[DEBUG] Mireli script exit code: $MIRELI_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $MIRELI_EXIT_CODE -ne 0 ]; then
        log_error_and_exit $MIRELI_EXIT_CODE "MIRELI_UPDATE_FAILED"
    fi

    log "Mireli completed successfully"
    log "Mireli პროექტი დასრულდა."
    log "----------------------------------------------------------"

    log "--- Mireli დასრულდა. ვისვენებ 4 საათი... ($(date)) ---"
    safe_sleep 14400
    log "4-hour sleep done, starting next cycle ($(date))"
    cd ~
done
