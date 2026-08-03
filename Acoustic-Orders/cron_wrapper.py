"""Thin wrapper that runs the scraper only on the 15th and the last day of
the month, so month-end (28/29/30/31) is always handled correctly.

Intended for cron: run every day at e.g. 23:00.  On non-trigger days it
exits immediately with no output.
"""

from __future__ import annotations

import datetime as dt
import os
import subprocess
import sys

# Load credentials from the shared env file (needed when run from cron)
_env_file = "/root/.scraper_env"
if os.path.exists(_env_file):
    with open(_env_file) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, _, value = line.partition("=")
                os.environ.setdefault(key.strip(), value.strip().strip('"'))


def _last_day_of_month(today: dt.date) -> dt.date:
    next_month = today.replace(day=28) + dt.timedelta(days=4)
    return next_month - dt.timedelta(days=next_month.day)


def main() -> int:
    today = dt.date.today()

    if today.day == 15:
        date_from = today.replace(day=1).strftime("%m/%d/%Y")
        date_to = today.strftime("%m/%d/%Y")
    elif today == _last_day_of_month(today):
        date_from = today.replace(day=16).strftime("%m/%d/%Y")
        date_to = today.strftime("%m/%d/%Y")
    else:
        return 0

    print(f"Auto-run trigger: {today}  period {date_from} – {date_to}",
          flush=True)

    result = subprocess.run(
        [sys.executable, "/root/Acoustic-Orders/orders_scraper.py",
         "--from", date_from, "--to", date_to],
        cwd="/root/Acoustic-Orders",
        capture_output=False,
    )
    return result.returncode


if __name__ == "__main__":
    sys.exit(main())
