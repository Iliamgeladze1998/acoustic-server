#!/bin/bash
# Stop all scraper screen sessions and kill related processes.

SCRAPERS="largo jinomusic musichouse musicroom geovoice mireli"

echo "Stopping all scrapers..."

for s in $SCRAPERS; do
    screen -X -S "scraper-$s" quit 2>/dev/null || true
    echo "  Stopped: scraper-$s"
done

# Kill any leftover browser processes
pkill -f "camoufox" 2>/dev/null || true
pkill -f "chromium" 2>/dev/null || true
pkill -f "playwright" 2>/dev/null || true
pkill -f "run_single_scraper" 2>/dev/null || true

sleep 2
echo ""
echo "Remaining screen sessions:"
screen -ls 2>/dev/null || echo "(none)"
echo ""
echo "Remaining python processes:"
ps aux | grep python | grep -v grep || echo "(none)"
