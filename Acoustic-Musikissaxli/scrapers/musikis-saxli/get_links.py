import asyncio
from playwright.async_api import async_playwright
import os

# Senior-level: constants, type hints, and robust structure
CATEGORIES: list[str] = [
    "https://musikis-saxli.ge/online-exclusive",
    "https://musikis-saxli.ge/guitar",
    "https://musikis-saxli.ge/bass",
    "https://musikis-saxli.ge/drum",
    "https://musikis-saxli.ge/keyboards-instruments",
    "https://musikis-saxli.ge/music-lover",
    "https://musikis-saxli.ge/studio",
    "https://musikis-saxli.ge/sound-effects",
    "https://musikis-saxli.ge/dj",
    "https://musikis-saxli.ge/orchestral-instruments",
    "https://musikis-saxli.ge/pro-audio",
    "https://musikis-saxli.ge/lighting",
    "https://musikis-saxli.ge/commutation",
    "https://musikis-saxli.ge/others"
]

FILE_NAME: str = os.path.join(os.path.dirname(__file__), "music-store-all-links.txt")
MAX_PAGE_RETRIES: int = 3
PAGE_TIMEOUT_MS: int = 45000

async def save_links_to_file(links: set[str]) -> None:
    """Save a set of links to the file, overwriting it."""
    with open(FILE_NAME, "w", encoding="utf-8") as f:
        for link in sorted(links):
            f.write(link + "\n")
    print(f"[INFO] Saved {len(links)} unique links to {os.path.basename(FILE_NAME)}", flush=True)

async def scrape_music_store() -> None:
    """Main scraping function for all categories, starting from a clean slate."""
    all_links: set[str] = set()
    if os.path.exists(FILE_NAME):
        os.remove(FILE_NAME)
    print(f"[INIT] Starting fresh page-link collection for {os.path.basename(FILE_NAME)}", flush=True)

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True, args=['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'])
        page = await browser.new_page()

        for base_url in CATEGORIES:
            page_num = 1
            print(f"[CATEGORY] Processing: {base_url}", flush=True)

            while True:
                target_url = f"{base_url}?page={page_num}"
                print(f"[PAGE] Checking: {target_url}", flush=True)

                try:
                    for attempt in range(1, MAX_PAGE_RETRIES + 1):
                        try:
                            await page.goto(target_url, wait_until="domcontentloaded", timeout=PAGE_TIMEOUT_MS)
                            await asyncio.sleep(0.5)  # Short sleep for stability
                            break
                        except Exception as e:
                            print(f"[WARN] Attempt {attempt}/{MAX_PAGE_RETRIES} failed on {target_url}: {e}", flush=True)
                            if attempt == MAX_PAGE_RETRIES:
                                raise
                            await asyncio.sleep(attempt * 2)

                    # Save the current page URL if not already present
                    if target_url not in all_links:
                        all_links.add(target_url)
                        print(f"[LINK] Added: {target_url}", flush=True)
                    else:
                        print(f"[LINK] Skipped duplicate: {target_url}", flush=True)

                    # Check for the presence of the Next Page button
                    next_button = page.locator(".main_pagination li:last-child a")
                    has_next = False
                    if await next_button.count() > 0:
                        href_value = await next_button.get_attribute("href")
                        # If href is '#' or empty, this is the last page
                        if href_value == "#" or not href_value:
                            print(f"[END] Last page reached ({page_num}). Moving to next category.", flush=True)
                            break
                        has_next = True
                    else:
                        # If there is no pagination, only one page exists
                        print(f"[END] No navigation button. Only one page in this category.", flush=True)
                        break

                    page_num += 1
                    if not has_next:
                        break

                except Exception as e:
                    print(f"[ERROR] Exception on {target_url}: {e}", flush=True)
                    break

        await browser.close()
        if not all_links:
            print("[ERROR] No category page links collected. Aborting.", flush=True)
            raise SystemExit(1)
        await save_links_to_file(all_links)
        print(f"[DONE] All links have been updated in: {FILE_NAME}", flush=True)

def main() -> None:
    asyncio.run(scrape_music_store())

if __name__ == "__main__":
    main()