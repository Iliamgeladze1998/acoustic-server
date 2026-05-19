import asyncio
import random
import os
import logging
from playwright.async_api import async_playwright

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Get the directory where this script is located
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Real User-Agent pool (updated 2024)
REAL_USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15'
]

# Search engine referral strings
SEARCH_REFERRALS = [
    'https://www.google.com/',
    'https://www.bing.com/',
    'https://duckduckgo.com/'
]

class StealthGeovoiceLinkCollector:
    def __init__(self, debug_mode=False):
        self.request_count = 0
        self.current_user_agent = random.choice(REAL_USER_AGENTS)
        
        # Main category URLs
        self.main_categories = [
            "https://geovoice.ge/audio/",
            "https://geovoice.ge/dj-studia/", 
            "https://geovoice.ge/video-aparatura/",
            "https://geovoice.ge/sasceno-ganateba/",
            "https://geovoice.ge/komutacia/",
            "https://geovoice.ge/sadgamebi-sakidebi/",
            "https://geovoice.ge/bose-products/",
            "https://geovoice.ge/sale/"
        ]
        
        # Debug mode: only test Audio category
        if debug_mode:
            self.main_categories = ["https://geovoice.ge/audio/"]
            logger.info("DEBUG MODE: Only testing Audio category")
    
    def get_random_viewport(self):
        """Randomize viewport size to avoid fingerprint detection"""
        widths = [1920, 1366, 1440, 1536, 1280, 1600]
        heights = [1080, 768, 900, 864, 720, 900]
        return {
            'width': random.choice(widths),
            'height': random.choice(heights)
        }
    
    async def test_page_with_stealth(self, page, page_url):
        """Test if a page exists using stealth techniques and detect pagination"""
        try:
            await page.goto(page_url, wait_until="domcontentloaded", timeout=30000)
            
            # Wait a moment for content to load
            await asyncio.sleep(random.uniform(1, 2))
            
            # Check if page has content
            page_content = await page.content()
            
            # Check for Cloudflare
            if 'Just a moment' in page_content or 'Checking your browser' in page_content:
                logger.warning(f"Cloudflare detected on {page_url}")
                return None
            
            # Check if page is empty
            if len(page_content) < 1000:
                logger.info(f"Page appears empty: {page_url}")
                return None
            
            # Check for 404 indicators
            if '404' in page_content or 'Not Found' in page_content:
                logger.info(f"404 detected: {page_url}")
                return None
            
            # Try to find pagination elements at the bottom of the page
            try:
                # Look for pagination numbers in common selectors
                pagination_selectors = [
                    '.ty-pagination',
                    '.pagination',
                    '.ty-pagination__bottom',
                    'div[class*="pagination"]',
                    'nav[class*="pagination"]'
                ]
                
                pagination_text = ""
                for selector in pagination_selectors:
                    try:
                        element = await page.query_selector(selector)
                        if element:
                            pagination_text = await element.inner_text()
                            if pagination_text:
                                logger.info(f"Found pagination text: {pagination_text[:50]}...")
                                break
                    except:
                        continue
                
                # Return True if page has content (pagination check is for info only)
                return True
                
            except Exception as e:
                logger.debug(f"Could not find pagination elements: {e}")
                return True
            
        except Exception as e:
            logger.error(f"Error testing page {page_url}: {e}")
            return False
    
    async def get_all_category_pages(self):
        """Get all paginated pages for all categories using stealth with pagination detection."""
        logger.info("Starting Geovoice category pagination (Stealth Mode)...")
        
        all_category_pages = []
        
        async with async_playwright() as p:
            browser = await p.chromium.launch(
                headless=True,
                args=[
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--disable-dev-shm-usage',
                    '--disable-blink-features=AutomationControlled'
                ]
            )
            
            for category_url in self.main_categories:
                logger.info(f"Processing category: {category_url}")
                
                # First, visit the first page to detect total pages from pagination
                context = await browser.new_context(
                    user_agent=random.choice(REAL_USER_AGENTS),
                    viewport=self.get_random_viewport(),
                    extra_http_headers={
                        'Referer': random.choice(SEARCH_REFERRALS),
                        'Accept-Language': 'en-US,en;q=0.9',
                        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8'
                    }
                )
                
                await context.add_init_script("""
                    Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                    Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                    Object.defineProperty(navigator, 'languages', {get: () => ['en-US', 'en']});
                    window.chrome = {runtime: {}};
                """)
                
                first_page = await context.new_page()
                
                try:
                    await first_page.goto(category_url, wait_until="domcontentloaded", timeout=30000)
                    await asyncio.sleep(2)
                    
                    # Check if pagination exists
                    pagination_selectors = [
                        '.ty-pagination',
                        '.pagination',
                        'div[class*="pagination"]'
                    ]
                    
                    has_pagination = False
                    for selector in pagination_selectors:
                        try:
                            element = await first_page.query_selector(selector)
                            if element:
                                has_pagination = True
                                logger.info(f"Found pagination element: {selector}")
                                break
                        except:
                            continue
                    
                    # Always use incremental checking for accuracy
                    check_incrementally = True
                    logger.info(f"Using incremental checking for accuracy")
                        
                except Exception as e:
                    logger.error(f"Error detecting pagination: {e}")
                    check_incrementally = True
                finally:
                    await context.close()
                
                # Now collect all pages
                category_pages = []
                
                if check_incrementally:
                    # Sequence-based validation with 10-consecutive-404 rule
                    page = 1
                    consecutive_failures = 0
                    max_consecutive_failures = 10  # Category ends after 10 consecutive 404s
                    page_status = {}  # Track status of each page: 'valid', '404', 'error'
                    last_valid_page = 0
                    
                    while consecutive_failures < max_consecutive_failures:
                        if page == 1:
                            page_url = category_url
                        else:
                            page_url = f"{category_url}page-{page}/"
                        
                        logger.info(f"Testing page {page}: {page_url}")
                        
                        self.request_count += 1
                        if self.request_count % 5 == 0:
                            self.current_user_agent = random.choice(REAL_USER_AGENTS)
                            logger.info(f"🔄 Rotating User-Agent (request #{self.request_count})")
                        
                        context = await browser.new_context(
                            user_agent=self.current_user_agent,
                            viewport=self.get_random_viewport(),
                            extra_http_headers={
                                'Referer': random.choice(SEARCH_REFERRALS),
                                'Accept-Language': 'en-US,en;q=0.9',
                                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8'
                            }
                        )
                        
                        await context.add_init_script("""
                            Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                            Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                            Object.defineProperty(navigator, 'languages', {get: () => ['en-US', 'en']});
                            window.chrome = {runtime: {}};
                        """)
                        
                        page_obj = await context.new_page()
                        
                        try:
                            if page > 1:
                                delay = random.uniform(3, 8)
                                logger.info(f"⏱️  Waiting {delay:.1f}s before request...")
                                await asyncio.sleep(delay)
                            
                            result = await self.test_page_with_stealth(page_obj, page_url)
                            
                            if result is True:
                                page_status[page] = 'valid'
                                category_pages.append(page_url)
                                logger.info(f"✅ Page {page} is valid")
                                last_valid_page = page
                                consecutive_failures = 0  # Reset on success
                                page += 1
                            elif result is None:
                                page_status[page] = '404'
                                logger.info(f"Page {page} returned 404")
                                consecutive_failures += 1
                                logger.info(f"Consecutive 404s: {consecutive_failures}/{max_consecutive_failures}")
                                page += 1
                            else:
                                page_status[page] = 'error'
                                logger.error(f"Error accessing page {page}")
                                consecutive_failures += 1
                                logger.info(f"Consecutive failures: {consecutive_failures}/{max_consecutive_failures}")
                                page += 1
                            
                        except Exception as e:
                            logger.error(f"Unexpected error on page {page}: {e}")
                            page_status[page] = 'error'
                            consecutive_failures += 1
                            logger.info(f"Consecutive failures: {consecutive_failures}/{max_consecutive_failures}")
                            page += 1
                        finally:
                            await context.close()
                    
                    logger.info(f"Category finished after {consecutive_failures} consecutive 404s")
                    logger.info(f"Last valid page: {last_valid_page}")
                    
                    # Backfill: Any pages before last_valid_page that returned 404 are ghost pages
                    # They exist because a later page was valid
                    ghost_pages = []
                    for p in range(1, last_valid_page + 1):
                        if p not in page_status:
                            # Page wasn't checked - add it
                            ghost_pages.append(p)
                        elif page_status[p] == '404':
                            # Page returned 404 but later pages were valid - it's a ghost page
                            ghost_pages.append(p)
                    
                    if ghost_pages:
                        logger.info(f"🔍 Found {len(ghost_pages)} ghost pages to backfill: {ghost_pages}")
                        
                        for ghost_page in ghost_pages:
                            if ghost_page == 1:
                                ghost_url = category_url
                            else:
                                ghost_url = f"{category_url}page-{ghost_page}/"
                            
                            logger.info(f"🔄 Backfilling ghost page {ghost_page}: {ghost_url}")
                            
                            self.request_count += 1
                            if self.request_count % 5 == 0:
                                self.current_user_agent = random.choice(REAL_USER_AGENTS)
                                logger.info(f"🔄 Rotating User-Agent (request #{self.request_count})")
                            
                            context = await browser.new_context(
                                user_agent=self.current_user_agent,
                                viewport=self.get_random_viewport(),
                                extra_http_headers={
                                    'Referer': random.choice(SEARCH_REFERRALS),
                                    'Accept-Language': 'en-US,en;q=0.9',
                                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8'
                                }
                            )
                            
                            await context.add_init_script("""
                                Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                                Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                                Object.defineProperty(navigator, 'languages', {get: () => ['en-US', 'en']});
                                window.chrome = {runtime: {}};
                            """)
                            
                            page_obj = await context.new_page()
                            
                            try:
                                delay = random.uniform(5, 10)
                                logger.info(f"⏱️  Waiting {delay:.1f}s before backfill request...")
                                await asyncio.sleep(delay)
                                
                                result = await self.test_page_with_stealth(page_obj, ghost_url)
                                
                                if result is True:
                                    category_pages.append(ghost_url)
                                    logger.info(f"✅ Ghost page {ghost_page} backfilled successfully")
                                else:
                                    logger.warning(f"⚠️  Ghost page {ghost_page} still returns 404, but adding anyway (sequence-based validation)")
                                    category_pages.append(ghost_url)  # Add anyway based on sequence validation
                            
                            except Exception as e:
                                logger.warning(f"Error backfilling page {ghost_page}: {e}, adding anyway (sequence-based validation)")
                                category_pages.append(ghost_url)  # Add anyway based on sequence validation
                            finally:
                                await context.close()
                    
                    # Sort pages to maintain sequence
                    category_pages = sorted(category_pages, key=lambda x: int(x.split('page-')[-1].rstrip('/')) if 'page-' in x else 0)
                else:
                    # Direct collection using detected last page
                    logger.info(f"Collecting pages 1 to {last_page}")
                    for page_num in range(1, last_page + 1):
                        if page_num == 1:
                            page_url = category_url
                        else:
                            page_url = f"{category_url}page-{page_num}/"
                        
                        logger.info(f"Collecting page {page_num}/{last_page}: {page_url}")
                        
                        self.request_count += 1
                        if self.request_count % 5 == 0:
                            self.current_user_agent = random.choice(REAL_USER_AGENTS)
                            logger.info(f"🔄 Rotating User-Agent (request #{self.request_count})")
                        
                        context = await browser.new_context(
                            user_agent=self.current_user_agent,
                            viewport=self.get_random_viewport(),
                            extra_http_headers={
                                'Referer': random.choice(SEARCH_REFERRALS),
                                'Accept-Language': 'en-US,en;q=0.9',
                                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8'
                            }
                        )
                        
                        await context.add_init_script("""
                            Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                            Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                            Object.defineProperty(navigator, 'languages', {get: () => ['en-US', 'en']});
                            window.chrome = {runtime: {}};
                        """)
                        
                        page_obj = await context.new_page()
                        
                        try:
                            if page_num > 1:
                                delay = random.uniform(3, 8)
                                logger.info(f"⏱️  Waiting {delay:.1f}s before request...")
                                await asyncio.sleep(delay)
                            
                            result = await self.test_page_with_stealth(page_obj, page_url)
                            
                            if result is True:
                                category_pages.append(page_url)
                                logger.info(f"✅ Page {page_num} collected")
                            else:
                                logger.warning(f"Page {page_num} failed, but continuing based on pagination")
                                category_pages.append(page_url)  # Still add it, pagination says it exists
                            
                        except Exception as e:
                            logger.warning(f"Error on page {page_num}: {e}, but continuing based on pagination")
                            category_pages.append(page_url)
                        finally:
                            await context.close()
                
                logger.info(f"Category {category_url} has {len(category_pages)} pages")
                all_category_pages.extend(category_pages)
            
            await browser.close()
        
        logger.info(f"Total category pages collected: {len(all_category_pages)}")
        return all_category_pages
    
    def save_category_pages_to_file(self, pages, filename="scrapers/geovoice/geovoice_category_links.txt"):
        """Save all category page links to file."""
        try:
            # Use absolute path to ensure file is in correct location
            import os
            script_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
            filepath = os.path.join(script_dir, filename)
            
            with open(filepath, 'w', encoding='utf-8') as f:
                for page_url in pages:
                    f.write(page_url + '\n')
            logger.info(f"Saved {len(pages)} category page links to {filepath}")
            return True
        except Exception as e:
            logger.error(f"Error saving category page links: {e}")
            return False

async def main():
    """Main execution for Geovoice category pagination."""
    logger.info("=== Geovoice Category Pagination Started (Stealth Mode) ===")
    
    # DEBUG MODE: Set to True to test only Audio category
    DEBUG_MODE = False
    
    # Collect all category pages with pagination
    collector = StealthGeovoiceLinkCollector(debug_mode=DEBUG_MODE)
    category_pages = await collector.get_all_category_pages()
    
    if category_pages:
        if collector.save_category_pages_to_file(category_pages):
            logger.info("✅ All category page links saved successfully!")
            logger.info(f"Ready for product link collection from {len(category_pages)} pages")
        else:
            logger.error("❌ Failed to save category page links!")
    else:
        logger.error("❌ No category page links found!")

if __name__ == "__main__":
    asyncio.run(main())