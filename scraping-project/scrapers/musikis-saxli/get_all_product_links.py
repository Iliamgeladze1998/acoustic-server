import asyncio
from playwright.async_api import async_playwright
import os

INPUT_FILE: str = os.path.join(os.path.dirname(__file__), "music-store-all-links.txt")
OUTPUT_FILE: str = os.path.join(os.path.dirname(__file__), "music-store-product-links.txt")

async def load_source_links() -> list[str]:
    """Read generated page links from the input file."""
    if not os.path.exists(INPUT_FILE):
        print(f"[ERROR] File not found: {os.path.basename(INPUT_FILE)}", flush=True)
        return []
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        return [line.strip() for line in f if line.strip()]

async def save_product_links(links: list[str]) -> None:
    """Save product links to the output file, avoiding duplicates."""
    existing_links = set()
    if os.path.exists(OUTPUT_FILE):
        with open(OUTPUT_FILE, "r", encoding="utf-8") as f:
            existing_links = set(line.strip() for line in f if line.strip())

    new_links = set(links) - existing_links

    if new_links:
        with open(OUTPUT_FILE, "a", encoding="utf-8") as f:
            for link in sorted(new_links):
                f.write(link + "\n")
        print(f"[INFO] Added {len(new_links)} new products to {os.path.basename(OUTPUT_FILE)}", flush=True)

async def get_product_links() -> None:
    source_urls = await load_source_links()
    if not source_urls:
        return

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True, args=['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'])
        context = await browser.new_context()
        page = await context.new_page()

        print(f"[START] Processing {len(source_urls)} pages...", flush=True)

        for index, url in enumerate(source_urls, 1):
            print(f"[{index}/{len(source_urls)}] Processing: {url}", flush=True)
            try:
                await page.goto(url, wait_until="domcontentloaded", timeout=60000)
                await asyncio.sleep(1)  # Short pause for full load

                # Extract all links with .prod_item class
                product_links = await page.evaluate("""() => {
                    const links = Array.from(document.querySelectorAll('a.prod_item'));
                    return links.map(a => a.href);
                }""")

                if product_links:
                    await save_product_links(product_links)
                else:
                    print(f"[WARN] No products found on page: {url}", flush=True)

            except Exception as e:
                print(f"[ERROR] Exception on {url}: {e}", flush=True)
                continue

        await browser.close()
        print(f"[DONE] All product links are saved in: {OUTPUT_FILE}", flush=True)

def main() -> None:
    asyncio.run(get_product_links())

if __name__ == "__main__":
    main()