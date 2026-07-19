#!/bin/bash
# Start all 6 scrapers in separate screen sessions.
# Each scraper loops independently: run -> sleep 8h -> run again.
#
# Usage: bash /root/start_all_scrapers.sh
# To stop all: bash /root/stop_all_scrapers.sh

SCRAPERS="largo jinomusic musichouse musicroom geovoice mireli"

echo "Starting all scrapers in separate screen sessions..."

for s in $SCRAPERS; do
    # Kill existing session if any
    screen -X -S "scraper-$s" quit 2>/dev/null || true
    sleep 1
    # Start new session
    screen -dmS "scraper-$s" bash /root/run_single_scraper.sh "$s"
    echo "  Started: scraper-$s"
    sleep 2
done

echo ""
echo "All scrapers started. Active screen sessions:"
screen -ls
echo ""
echo "To attach to a scraper:  screen -r scraper-<name>"
echo "To detach:               Ctrl+A then D"
echo "To stop all:             bash /root/stop_all_scrapers.sh"
echo "To view logs:            tail -f /root/scraper_logs/<name>.log"
