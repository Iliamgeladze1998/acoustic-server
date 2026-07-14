#!/usr/bin/env python3
"""
Run script for Largo scraper.
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from largo_scraper import scrape_all_products

if __name__ == "__main__":
    success = scrape_all_products()
    sys.exit(0 if success else 1)
