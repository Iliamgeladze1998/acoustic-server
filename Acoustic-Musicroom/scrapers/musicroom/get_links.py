import asyncio
from pathlib import Path
from playwright.async_api import async_playwright

BASE_URL = "https://musicroom.ge/"
TARGET_CATEGORIES = {
    "გიტარა",
    "დასარტყამი",
    "აუდიო",
    "განათება",
    "DJ & სტუდია",
    "საორკესტრო",
}

# Partial match keywords for keyboard instruments
KEYWORD_MATCHES = ["კლავიშ", "klavish"]

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"


async def fetch_category_links():
    playwright = await async_playwright().start()
    browser = await playwright.chromium.launch(headless=True)
    context = await browser.new_context(
        user_agent=USER_AGENT,
        viewport={"width": 1920, "height": 1080},
        ignore_https_errors=True
    )
    page = await context.new_page()
    
    # Block only images to speed up loading (keep CSS for menu rendering)
    await page.route("**/*.{png,jpg,jpeg,gif,webp}", lambda route: route.abort())
    
    try:
        await page.goto(BASE_URL, wait_until="commit", timeout=90000)
        
        # Wait a bit for the page to render since we're using commit
        await asyncio.sleep(2)
        
        # Try to find and hover/click on 'პროდუქცია' menu to reveal categories
        try:
            product_menu = page.get_by_text("პროდუქცია")
            if await product_menu.count() > 0:
                await product_menu.first.hover()
                await asyncio.sleep(0.5)  # Wait for menu to expand
        except:
            pass  # Menu might already be visible or not needed
        
        # Look for the product menu (Woodmart theme)
        menu = page.locator("ul.menu-product-menu")
        if await menu.count() == 0:
            # Fallback: search for woodmart nav links
            links = page.locator("a.woodmart-nav-link")
        else:
            links = menu.locator("a.woodmart-nav-link")
        
        # Track first occurrence of each category to avoid duplicates
        category_urls = {}
        link_count = await links.count()
        
        for i in range(link_count):
            link = links.nth(i)
            text = await link.inner_text()
            href = await link.get_attribute("href")
            
            # Check for exact match
            if text.strip() in TARGET_CATEGORIES and text.strip() not in category_urls:
                if href:
                    # Ensure absolute URL
                    if not href.startswith("http"):
                        href = BASE_URL.rstrip("/") + href
                    category_urls[text.strip()] = href.strip()
            
            # Check for partial match for keyboard instruments
            for keyword in KEYWORD_MATCHES:
                if keyword.lower() in text.lower() and "კლავიშებიანი ინსტრუმენტები" not in category_urls:
                    if href:
                        # Ensure absolute URL
                        if not href.startswith("http"):
                            href = BASE_URL.rstrip("/") + href
                        category_urls["კლავიშებიანი ინსტრუმენტები"] = href.strip()
        
        return list(category_urls.values())
        
    finally:
        await page.close()
        await context.close()
        await browser.close()
        await playwright.stop()


async def main():
    urls = await fetch_category_links()
    
    # Check for empty list before opening file
    if not urls:
        print("❌ No category links found. File not written.")
        return
    
    # Use strict pathing relative to script location
    output_file = Path(__file__).parent / "get_main_category_links.txt"
    
    with open(output_file, "w", encoding="utf-8") as f:
        for url in urls:
            f.write(url + "\n")
            f.flush()  # Immediate flush
    
    print(f"Extracted {len(urls)} category links to {output_file}")
    for url in urls:
        print(f"  {url}")


if __name__ == "__main__":
    asyncio.run(main())