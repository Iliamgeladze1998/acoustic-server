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

# Per-project Playwright browser caches. Each project keeps its OWN local
# chromium so the three venvs cannot collide on a shared cache directory
# and so a missing system-wide install can't break us. These dirs are
# exported as PLAYWRIGHT_BROWSERS_PATH for each stage that uses Playwright.
MUSICROOM_PW_BROWSERS="$HOME/Acoustic-Musicroom/pw-browsers"
MIRELI_PW_BROWSERS="$HOME/Acoustic-Mireli/pw-browsers"
MUSIC_HOUSE_PW_BROWSERS="$HOME/scraping-project/pw-browsers"

# Bootstrap controls. Bootstrap installs Python deps + Playwright chromium
# into each project's venv exactly once per script start. It is idempotent
# (a no-op on subsequent invocations because pip and `playwright install`
# both skip already-satisfied work). Pass --skip-bootstrap to suppress it.
DO_BOOTSTRAP=1
for arg in "$@"; do
    case "$arg" in
        --skip-bootstrap) DO_BOOTSTRAP=0 ;;
        --bootstrap-only) DO_BOOTSTRAP=2 ;;   # bootstrap then exit
        -h|--help)
            cat <<EOF
Usage: $0 [--skip-bootstrap | --bootstrap-only]
  (default)         Run bootstrap once, then enter the cycle loop.
  --skip-bootstrap  Skip dependency / browser install. Use after the first run.
  --bootstrap-only  Run bootstrap only, then exit (useful for CI / setup).
EOF
            exit 0
            ;;
    esac
done

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

# ---------- bootstrap ----------

# bootstrap_project: install/repair a single project's Python deps and
# Playwright chromium into the project-local browser path. Idempotent.
# Fails the whole script if any step exits non-zero so we never enter
# the main loop with a broken environment (which is what bit us before).
#
# $1 = human label   (e.g. "Musicroom")
# $2 = project dir   (contains venv/)
# $3 = pw-browsers path to use as PLAYWRIGHT_BROWSERS_PATH
# $4 = (optional) extra pip packages, space-separated. Empty means just
#      `pip install -r requirements.txt` if requirements.txt exists.
# $5 = log file to append bootstrap output to
bootstrap_project() {
    local label="$1"
    local dir="$2"
    local pw_path="$3"
    local extra_pkgs="${4:-}"
    local logfile="$5"

    log "Bootstrap: $label  (dir=$dir, pw=$pw_path)"

    mkdir -p "$pw_path" || { log "Bootstrap FAIL: cannot mkdir $pw_path"; exit 10; }

    (
        set -u
        cd "$dir" || exit 10
        # shellcheck disable=SC1091
        source venv/bin/activate || exit 11
        export PLAYWRIGHT_BROWSERS_PATH="$pw_path"

        echo "[bootstrap=$label] python : $(which python) ($(python --version 2>&1))"
        echo "[bootstrap=$label] pw_path: $PLAYWRIGHT_BROWSERS_PATH"

        python -m pip install --upgrade pip --quiet || exit 12

        if [ -f requirements.txt ]; then
            echo "[bootstrap=$label] installing requirements.txt"
            python -m pip install -r requirements.txt --quiet || exit 13
        fi
        if [ -n "$extra_pkgs" ]; then
            echo "[bootstrap=$label] installing extra packages: $extra_pkgs"
            # shellcheck disable=SC2086
            python -m pip install --quiet $extra_pkgs || exit 14
        fi

        # Ensure Playwright Python is present (some projects don't list it
        # in requirements.txt). Cheap no-op if already installed.
        python -m pip install playwright --quiet || exit 15

        # Install / verify Chromium into the project-local browsers dir.
        # `playwright install` is idempotent: it skips if the binary
        # already exists at the target path.
        echo "[bootstrap=$label] running: playwright install chromium"
        python -m playwright install chromium || exit 16

        # Verify by actually trying to resolve the executable.
        python - <<'PY' || exit 17
import sys
from playwright.sync_api import sync_playwright
try:
    with sync_playwright() as p:
        path = p.chromium.executable_path
        print(f"[bootstrap] chromium executable_path = {path}")
        import os
        if not os.path.exists(path):
            print(f"[bootstrap] FAIL: executable does not exist at {path}", file=sys.stderr)
            sys.exit(1)
        print("[bootstrap] verified chromium binary present.")
except Exception as e:
    print(f"[bootstrap] verification failed: {e}", file=sys.stderr)
    sys.exit(1)
PY
        deactivate >/dev/null 2>&1 || true
        exit 0
    ) >> "$logfile" 2>&1

    local rc=$?
    if [ "$rc" -ne 0 ]; then
        log "Bootstrap FAILED for $label (rc=$rc). See $logfile for details."
        exit "$rc"
    fi
    log "Bootstrap OK: $label"
}

# ---------- main loop ----------

log "##########################################################"
log "Pipeline starting. Logs directory: $LOG_DIR"
log "Cool-down between stages: ${COOLDOWN_SECONDS}s"
log "Rest between cycles    : ${CYCLE_REST_SECONDS}s"
log "##########################################################"

# ----- one-time bootstrap (deps + Playwright chromium per project) -----
# Runs before entering the cycle loop. Idempotent: rerunning costs ~seconds
# once everything is already installed. Skipped if --skip-bootstrap given.
if [ "$DO_BOOTSTRAP" -ne 0 ]; then
    log "Bootstrapping project environments (use --skip-bootstrap to skip)..."
    bootstrap_project "Musicroom"  "$HOME/Acoustic-Musicroom" "$MUSICROOM_PW_BROWSERS"  ""        "$MUSICROOM_LOG"
    bootstrap_project "Mireli"     "$HOME/Acoustic-Mireli"    "$MIRELI_PW_BROWSERS"     ""        "$MIRELI_LOG"
    # MusicHouse: its requirements.txt does not include playwright, but the
    # musikis-saxli scraper imports it, so we add it as an extra package.
    bootstrap_project "MusicHouse" "$HOME/scraping-project"   "$MUSIC_HOUSE_PW_BROWSERS" "playwright" "$MUSIC_HOUSE_LOG"
    log "Bootstrap complete for all three projects."
    if [ "$DO_BOOTSTRAP" -eq 2 ]; then
        log "--bootstrap-only specified; exiting."
        exit 0
    fi
else
    log "Bootstrap SKIPPED (--skip-bootstrap)."
fi

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
        "$MUSICROOM_LOG" \
        "export PLAYWRIGHT_BROWSERS_PATH=$MUSICROOM_PW_BROWSERS"
    cooldown

    # Stage 2: Mireli (scrape + sheet update inside acmi_main.py)
    run_stage "Mireli" \
        "$HOME/Acoustic-Mireli" \
        "acmi/acmi_main.py" \
        "$MIRELI_LOG" \
        "export PLAYWRIGHT_BROWSERS_PATH=$MIRELI_PW_BROWSERS"
    cooldown

    # Stage 3: Music House (scrape + sheet update inside acms_main.py)
    run_stage "MusicHouse" \
        "$HOME/scraping-project" \
        "acms/acms_main.py" \
        "$MUSIC_HOUSE_LOG" \
        "export PLAYWRIGHT_BROWSERS_PATH=$MUSIC_HOUSE_PW_BROWSERS"
    cooldown

    log "Cycle complete. Sleeping ${CYCLE_REST_SECONDS}s before next cycle..."
    sleep "$CYCLE_REST_SECONDS"
done
