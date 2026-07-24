#!/usr/bin/env python3
"""Auto-sync wrapper for music-compare.

Runs a full sync from the scraper Excel files and then fetches missing images.
Designed to be run from cron on a schedule.
"""

import os
import sys
import time
import sqlite3
from datetime import datetime

from sync_service import sync_all, DB_PATH


def lock_or_exit():
    """Simple file-based lock to prevent overlapping runs."""
    lock_path = os.path.join(os.path.dirname(DB_PATH), ".auto_sync.lock")
    if os.path.exists(lock_path):
        try:
            with open(lock_path) as f:
                pid = int(f.read().strip())
            if os.path.exists(f"/proc/{pid}"):
                print(f"[{datetime.now().isoformat()}] Another auto_sync is already running (PID {pid}). Exiting.")
                return False
        except (ValueError, OSError):
            pass
        try:
            os.remove(lock_path)
        except OSError:
            pass
    with open(lock_path, "w") as f:
        f.write(str(os.getpid()))
    return True


def unlock():
    lock_path = os.path.join(os.path.dirname(DB_PATH), ".auto_sync.lock")
    try:
        os.remove(lock_path)
    except OSError:
        pass


def report_counts():
    try:
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute("SELECT COUNT(*) FROM product_groups")
        total_groups = c.fetchone()[0]
        c.execute("SELECT COUNT(*) FROM product_groups WHERE image_url != '' AND image_url IS NOT NULL")
        with_image = c.fetchone()[0]
        c.execute("SELECT COUNT(*) FROM listings")
        total_listings = c.fetchone()[0]
        conn.close()
        print(f"[{datetime.now().isoformat()}] DB status: {with_image}/{total_groups} groups have images, {total_listings} listings")
    except Exception as e:
        print(f"[{datetime.now().isoformat()}] Could not report counts: {e}")


def main():
    if not lock_or_exit():
        return 1

    try:
        started = datetime.now()
        print(f"\n{'='*60}")
        print(f"AUTO SYNC started at {started.isoformat()}")
        print(f"{'='*60}")

        # Default to 200 images per run. A larger limit can be passed for backfill.
        try:
            image_limit = int(sys.argv[1]) if len(sys.argv) > 1 else 200
        except ValueError:
            image_limit = 200

        sync_all(image_limit=image_limit)
        report_counts()

        elapsed = (datetime.now() - started).total_seconds()
        print(f"[{datetime.now().isoformat()}] Auto-sync finished in {elapsed:.0f}s")
    finally:
        unlock()

    return 0


if __name__ == "__main__":
    sys.exit(main())
