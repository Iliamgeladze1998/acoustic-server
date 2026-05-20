#!/bin/bash
#
# Strict, gate-kept, ZERO-OVERLAP serial pipeline.
#
# Order (one cycle):
#   [Musicroom: scrape + sheet upload] -> FINISH -> wait 60s ->
#   [Mireli:    scrape + sheet upload] -> FINISH -> wait 60s ->
#   [MusicHouse:scrape + sheet upload] -> FINISH -> wait 60s ->
#   sleep 10 min -> next cycle
#
# Guarantees:
#   1. Only one scraper process can be alive at a time. The orchestrator
#      launches the next stage ONLY after the previous stage's process
#      has fully exited and `wait` has returned.
#   2. The gatekeeper refuses to start stage N+1 unless stage N exited
#      with code 0. Any non-zero exit aborts the entire pipeline.
#   3. Each stage's START and FINISH timestamps (with duration) are
#      written to pipeline.log so overlap can be ruled out by inspection.
#   4. Each project has its own log file. Logs are never interleaved.

set -u
set -o pipefail

LOG_DIR="$HOME/scraper_logs"
mkdir -p "$LOG_DIR"

MUSICROOM_LOG="$LOG_DIR/musicroom.log"
MIRELI_LOG="$LOG_DIR/mireli.log"
MUSIC_HOUSE_LOG="$LOG_DIR/music_house.log"
PIPELINE_LOG="$LOG_DIR/pipeline.log"

COOLDOWN_SECONDS=60
CYCLE_REST_SECONDS=600

# Gatekeeper state. Initialized to 0 so the very first stage is allowed.
# After each stage runs, this is set to that stage's real exit code.
# `gate_check` refuses to proceed unless this is exactly 0.
LAST_STAGE_RC=0
LAST_STAGE_NAME="<none>"
LAST_STAGE_PID=""

# ---------- helpers ----------

ts() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
    # Pipeline-level log: console + pipeline.log
    local msg
    msg="[$(ts)] $*"
    echo "$msg"
    echo "$msg" >> "$PIPELINE_LOG"
}

fail() {
    # $1 = stage name, $2 = exit code, $3 = log file
    log "CRITICAL: STAGE FAILED -> '$1' (exit code: $2)"
    log "See log for details: $3"
    log "Gatekeeper: pipeline aborted. No further stages will run."
    exit 1
}

# Refuses to proceed if the previous stage didn't exit cleanly OR if its
# PID is somehow still alive. This is the explicit "gatekeeper" check
# requested: the next stage cannot start while the previous one is
# 'running' or in a failed state.
gate_check() {
    local next_stage="$1"

    if [ -n "$LAST_STAGE_PID" ] && kill -0 "$LAST_STAGE_PID" 2>/dev/null; then
        log "GATEKEEPER BLOCK: previous stage '$LAST_STAGE_NAME' (pid $LAST_STAGE_PID) is still alive."
        log "Refusing to start '$next_stage'. Aborting pipeline to prevent overlap."
        exit 2
    fi

    if [ "$LAST_STAGE_RC" -ne 0 ]; then
        log "GATEKEEPER BLOCK: previous stage '$LAST_STAGE_NAME' did not exit 0 (rc=$LAST_STAGE_RC)."
        log "Refusing to start '$next_stage'."
        exit 3
    fi

    log "GATEKEEPER OK: previous stage '$LAST_STAGE_NAME' finished cleanly. Cleared to start '$next_stage'."
}

cooldown() {
    log "Cool-down: sleeping ${COOLDOWN_SECONDS}s so Google Sheets API releases locks..."
    sleep "$COOLDOWN_SECONDS"
    log "Cool-down complete."
}

# Runs ONE scraper stage. The python process is launched in the
# background only so we can capture its PID for the gatekeeper sanity
# check; `wait $pid` blocks the orchestrator until that single PID has
# exited. No other stage can be running during this window.
#
# $1 = stage label  (e.g. "Musicroom")
# $2 = project dir
# $3 = python entrypoint (relative to project dir)
# $4 = log file
# $5 = (optional) extra setup commands evaluated inside the subshell
run_stage() {
    local stage="$1"
    local dir="$2"
    local entry="$3"
    local logfile="$4"
    local extra_setup="${5:-}"

    gate_check "$stage"

    # Truncate per-stage log so each run is a clean audit trail.
    : > "$logfile"

    local start_epoch start_human
    start_epoch=$(date +%s)
    start_human=$(ts)

    log "=========================================================="
    log "STAGE START  : $stage"
    log "  started_at : $start_human"
    log "  dir        : $dir"
    log "  entry      : $entry"
    log "  log_file   : $logfile"

    {
        echo "============================================================"
        echo "[stage=$stage] START      : $start_human"
        echo "[stage=$stage] dir        : $dir"
        echo "[stage=$stage] entry      : $entry"
        echo "============================================================"
    } >> "$logfile"

    (
        set -u
        cd "$dir" || exit 90
        # shellcheck disable=SC1091
        source venv/bin/activate || exit 91

        if [ -n "$extra_setup" ]; then
            eval "$extra_setup" || exit 92
        fi

        echo "[stage=$stage] python    : $(which python) ($(python --version 2>&1))"
        echo "[stage=$stage] cwd       : $(pwd)"
        echo "[stage=$stage] pid       : $$"

        python "$entry"
        rc=$?

        deactivate >/dev/null 2>&1 || true
        exit "$rc"
    ) >> "$logfile" 2>&1 &

    local pid=$!
    LAST_STAGE_PID="$pid"
    LAST_STAGE_NAME="$stage"

    log "  pid        : $pid (orchestrator is now BLOCKED on wait; no other stage can run)"

    # Block until this exact PID exits. `wait $pid` returns that
    # process's real exit code. Nothing else runs in this script
    # between here and the next line.
    wait "$pid"
    local rc=$?

    local end_epoch end_human duration
    end_epoch=$(date +%s)
    end_human=$(ts)
    duration=$(( end_epoch - start_epoch ))

    LAST_STAGE_RC="$rc"
    LAST_STAGE_PID=""   # process is no longer alive

    {
        echo "============================================================"
        echo "[stage=$stage] FINISH     : $end_human"
        echo "[stage=$stage] exit_code  : $rc"
        echo "[stage=$stage] duration_s : $duration"
        echo "============================================================"
    } >> "$logfile"

    log "STAGE FINISH : $stage"
    log "  finished_at: $end_human"
    log "  duration   : ${duration}s"
    log "  exit_code  : $rc"
    log "=========================================================="

    if [ "$rc" -ne 0 ]; then
        fail "$stage" "$rc" "$logfile"
    fi
}

# ---------- main loop ----------

log "##########################################################"
log "Pipeline starting. Logs directory: $LOG_DIR"
log "Cool-down between stages: ${COOLDOWN_SECONDS}s"
log "Rest between cycles    : ${CYCLE_REST_SECONDS}s"
log "##########################################################"

while true; do
    # Reset gatekeeper at the top of each cycle so a successful prior
    # cycle doesn't carry stale state. (LAST_STAGE_RC=0 is the cleared
    # state — anything else would have already exited above.)
    LAST_STAGE_RC=0
    LAST_STAGE_NAME="<cycle-start>"
    LAST_STAGE_PID=""

    log "########## NEW CYCLE @ $(ts) ##########"

    # Stage 1: Musicroom (scrape + sheet update inside acmr_main.py)
    run_stage "Musicroom" \
        "$HOME/Acoustic-Musicroom" \
        "acmr/acmr_main.py" \
        "$MUSICROOM_LOG"
    cooldown

    # Stage 2: Mireli (scrape + sheet update inside acmi_main.py)
    run_stage "Mireli" \
        "$HOME/Acoustic-Mireli" \
        "acmi/acmi_main.py" \
        "$MIRELI_LOG" \
        'export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Mireli/pw-browsers'
    cooldown

    # Stage 3: Music House (scrape + sheet update inside acms_main.py)
    run_stage "MusicHouse" \
        "$HOME/scraping-project" \
        "acms/acms_main.py" \
        "$MUSIC_HOUSE_LOG"
    cooldown

    log "Cycle complete. Sleeping ${CYCLE_REST_SECONDS}s before next cycle..."
    sleep "$CYCLE_REST_SECONDS"
done
