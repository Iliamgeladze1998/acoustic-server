#!/bin/bash

# Wrapper script — ავტომატურად განახლებს run_scrapers.sh-ს თუ მოკვდა OOM-ით
# ნამდვილ ერორზე (exit 1) არ განახლდება
# გაშვება: screen -dmS scrapers bash /root/run_scrapers_wrapper.sh

WRAPPER_LOG="/root/scrapers_wrapper.log"

log_w() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$WRAPPER_LOG"
}

log_w "=== Wrapper started ==="

while true; do
    log_w "Starting run_scrapers.sh..."
    bash /root/run_scrapers.sh
    EXIT_CODE=$?
    log_w "run_scrapers.sh exited with code $EXIT_CODE"

    if [ $EXIT_CODE -eq 0 ]; then
        log_w "Normal exit, restarting in 60 seconds..."
        sleep 60
    elif [ $EXIT_CODE -eq 1 ]; then
        log_w "REAL ERROR (exit 1) — NOT restarting automatically."
        log_w "Check /root/scrapers_detailed.log for details."
        log_w "Manual restart required: screen -r scrapers, then bash /root/run_scrapers.sh"
        # არ განახლდება — ხელით უნდა გაუშვა
        exit 1
    elif [ $EXIT_CODE -eq 137 ] || [ $EXIT_CODE -eq 139 ]; then
        log_w "OOM KILL or SEGFAULT (exit $EXIT_CODE) — restarting in 120 seconds..."
        log_w "Cleaning up leftover processes..."
        pkill -f "chromium" 2>/dev/null || true
        pkill -f "camoufox" 2>/dev/null || true
        pkill -f "firefox" 2>/dev/null || true
        pkill -f "playwright" 2>/dev/null || true
        sleep 120
    else
        log_w "Unexpected exit code $EXIT_CODE — restarting in 60 seconds..."
        sleep 60
    fi
done
