#!/bin/bash
# Generic single-scraper loop script.
# Usage: bash run_single_scraper.sh <scraper_name>
# Each scraper runs in its own screen session, loops forever with 8h sleep between runs.
#
# Scrapers:
#   largo       -> ~/Acoustic-Largo         python aclg/aclg_main.py
#   jinomusic   -> ~/Acoustic-JinoMusic     python acjm/acjm_main.py
#   musichouse  -> ~/Acoustic-Musikissaxli  python acms/acms_main.py
#   musicroom   -> ~/Acoustic-Musicroom     python acmr/acmr_main.py
#   geovoice    -> ~/Acoustic-Geovoice      python acgv/acgv_main.py
#   mireli      -> ~/Acoustic-Mireli        python acmi/acmi_main.py

SCRAPER_NAME="$1"
if [ -z "$SCRAPER_NAME" ]; then
    echo "Usage: $0 <scraper_name>"
    echo "Available: largo, jinomusic, musichouse, musicroom, geovoice, mireli"
    exit 1
fi

LOG_DIR="/root/scraper_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/${SCRAPER_NAME}.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$SCRAPER_NAME] $*" | tee -a "$LOG_FILE"
}

# ── Config per scraper ─────────────────────────────────────────────────────
case "$SCRAPER_NAME" in
    largo)
        PROJECT_DIR="$HOME/Acoustic-Largo"
        MAIN_SCRIPT="aclg/aclg_main.py"
        EXTRA_PIP=""
        EXTRA_SETUP=""
        RUN_TIMEOUT=0  # no limit
        ;;
    jinomusic)
        PROJECT_DIR="$HOME/Acoustic-JinoMusic"
        MAIN_SCRIPT="acjm/acjm_main.py"
        EXTRA_PIP="\"camoufox[geoip]\" pillow"
        EXTRA_SETUP="python -m camoufox fetch 2>/dev/null"
        RUN_TIMEOUT=0  # no limit
        ;;
    musichouse)
        PROJECT_DIR="$HOME/Acoustic-Musikissaxli"
        MAIN_SCRIPT="acms/acms_main.py"
        EXTRA_PIP="playwright"
        EXTRA_SETUP="export PLAYWRIGHT_BROWSERS_PATH=\$PROJECT_DIR/pw-browsers; playwright install chromium 2>/dev/null"
        RUN_TIMEOUT=0  # no limit
        ;;
    musicroom)
        PROJECT_DIR="$HOME/Acoustic-Musicroom"
        MAIN_SCRIPT="acmr/acmr_main.py"
        EXTRA_PIP="\"camoufox[geoip]\" pillow playwright"
        EXTRA_SETUP="export PLAYWRIGHT_BROWSERS_PATH=\$PROJECT_DIR/pw-browsers; playwright install chromium 2>/dev/null; python -m camoufox fetch 2>/dev/null"
        RUN_TIMEOUT=0  # no limit
        ;;
    geovoice)
        PROJECT_DIR="$HOME/Acoustic-Geovoice"
        MAIN_SCRIPT="acgv/acgv_main.py"
        EXTRA_PIP="playwright cloudscraper rapidfuzz \"camoufox[geoip]\" pillow"
        EXTRA_SETUP="export PLAYWRIGHT_BROWSERS_PATH=\$PROJECT_DIR/pw-browsers; playwright install chromium 2>/dev/null; python -m camoufox fetch 2>/dev/null"
        RUN_TIMEOUT=0  # no limit
        ;;
    mireli)
        PROJECT_DIR="$HOME/Acoustic-Mireli"
        MAIN_SCRIPT="acmi/acmi_main.py"
        EXTRA_PIP="playwright"
        EXTRA_SETUP="export PLAYWRIGHT_BROWSERS_PATH=\$PROJECT_DIR/pw-browsers; playwright install chromium 2>/dev/null"
        RUN_TIMEOUT=0  # no limit
        ;;
    *)
        echo "Unknown scraper: $SCRAPER_NAME"
        echo "Available: largo, jinomusic, musichouse, musicroom, geovoice, mireli"
        exit 1
        ;;
esac

SLEEP_SECONDS=28800  # 8 hours between runs

# Stagger startup to avoid Camoufox/Playwright launch conflicts
case "$SCRAPER_NAME" in
    largo)       STARTUP_DELAY=0 ;;
    jinomusic)   STARTUP_DELAY=30 ;;   # uses Camoufox + Tor
    musichouse)  STARTUP_DELAY=10 ;;
    musicroom)   STARTUP_DELAY=60 ;;   # uses Camoufox, start after jinomusic
    geovoice)    STARTUP_DELAY=20 ;;
    mireli)      STARTUP_DELAY=40 ;;
    *)           STARTUP_DELAY=0 ;;
esac

log "=== Starting $SCRAPER_NAME scraper loop ==="
log "Project dir: $PROJECT_DIR"
log "Main script: $MAIN_SCRIPT"
log "Run timeout: ${RUN_TIMEOUT}s"
log "Sleep between runs: ${SLEEP_SECONDS}s"
log "Startup delay: ${STARTUP_DELAY}s"

if [ "$STARTUP_DELAY" -gt 0 ]; then
    log "Waiting ${STARTUP_DELAY}s before first run (staggered startup)..."
    sleep "$STARTUP_DELAY"
fi

while true; do
    log "--- New run started ---"

    # Cleanup stale browser processes for this project
    pkill -f "camoufox.*${PROJECT_DIR}" 2>/dev/null || true
    pkill -f "chromium.*${PROJECT_DIR}" 2>/dev/null || true
    pkill -f "playwright.*${PROJECT_DIR}" 2>/dev/null || true
    sleep 2

    # Run the scraper with timeout
    cd "$PROJECT_DIR" || {
        log "ERROR: Cannot cd to $PROJECT_DIR"
        sleep 60
        continue
    }

    # Activate venv
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    else
        log "WARNING: No venv found, using system python"
    fi

    # Install/update deps
    pip install --upgrade pip -q 2>/dev/null
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt -q 2>/dev/null || true
    fi
    if [ -n "$EXTRA_PIP" ]; then
        pip install $EXTRA_PIP -q 2>/dev/null || true
    fi

    # Extra setup (camoufox fetch, playwright install, etc)
    if [ -n "$EXTRA_SETUP" ]; then
        eval "$EXTRA_SETUP" 2>/dev/null || true
    fi

    # Run the scraper (no time limit)
    log "Running: python $MAIN_SCRIPT"
    PYTHONUNBUFFERED=1 python "$MAIN_SCRIPT" 2>&1 | tee -a "$LOG_FILE"
    EXIT_CODE=${PIPESTATUS[0]}

    log "Scraper exited with code $EXIT_CODE"

    # Cleanup after run
    pkill -f "camoufox.*${PROJECT_DIR}" 2>/dev/null || true
    pkill -f "chromium.*${PROJECT_DIR}" 2>/dev/null || true
    pkill -f "playwright.*${PROJECT_DIR}" 2>/dev/null || true

    # Deactivate venv
    deactivate 2>/dev/null || true

    if [ $EXIT_CODE -eq 124 ]; then
        log "WARNING: Scraper timed out after ${RUN_TIMEOUT}s"
    elif [ $EXIT_CODE -ne 0 ]; then
        log "WARNING: Scraper failed with exit code $EXIT_CODE"
    else
        log "Scraper completed successfully"
    fi

    log "--- Run finished. Sleeping ${SLEEP_SECONDS}s (8h) before next run ---"
    sleep "$SLEEP_SECONDS"
done
