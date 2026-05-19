#!/usr/bin/env python3
"""
Stealth 'Ghost' Link Scraper for Geovoice
Advanced fingerprint spoofing and human-like behavior to bypass 403 blocks
"""

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
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/122.0.0.0 Safari/537.36',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1'
]

# Search engine referral strings for entry points
SEARCH_REFERRALS = [
    'https://www.google.com/',
    'https://www.bing.com/',
    'https://duckduckgo.com/',
    'https://www.yahoo.com/'
]

class StealthLinkCollector:
    def __init__(self):
        self.request_count = 0
        self.current_user_agent = random.choice(REAL_USER_AGENTS)
        
    def get_google_cache_url(self, original_url):
        """Convert URL to Google Cache URL for IP bypass"""
        return f"https://webcache.googleusercontent.com/search?q=cache:{original_url}"
    
    def get_random_viewport(self):
        """Randomize viewport size to avoid fingerprint detection"""
        widths = [1920, 1366, 1440, 1536, 1280, 1600]
        heights = [1080, 768, 900, 864, 720, 900]
        return {
            'width': random.choice(widths),
            'height': random.choice(heights)
        }
    
    async def simulate_mouse_jitter(self, page):
        """Simulate subtle mouse movements to appear human"""
        try:
            # Random small movements
            for _ in range(3):
                x = random.randint(100, 300)
                y = random.randint(100, 300)
                await page.mouse.move(x, y)
                await asyncio.sleep(random.uniform(0.05, 0.15))
        except:
            pass
    
    async def human_scroll_to_bottom(self, page):
        """Scroll to bottom naturally like a human reading"""
        try:
            await asyncio.sleep(random.uniform(1, 2))  # Wait for initial load
            
            # Get page height
            page_height = await page.evaluate("document.body.scrollHeight")
            
            # Scroll in chunks
            scroll_position = 0
            while scroll_position < page_height:
                scroll_amount = random.randint(300, 500)
                scroll_position += scroll_amount
                await page.evaluate(f"window.scrollTo(0, {scroll_position})")
                await asyncio.sleep(random.uniform(0.5, 1.5))
                
                # Simulate mouse jitter while scrolling
                await self.simulate_mouse_jitter(page)
            
            # Scroll back up slightly
            await page.evaluate(f"window.scrollTo(0, {scroll_position - 200})")
            await asyncio.sleep(random.uniform(0.3, 0.8))
        except:
            pass
    
    async def extract_links_with_stealth(self, page, category_url):
        """Extract product links with stealth techniques"""
        try:
            # Navigate to page
            await page.goto(category_url, wait_until="domcontentloaded", timeout=30000)
            
            # Human-like scroll to bottom
            await self.human_scroll_to_bottom(page)
            
            # Extract links
            product_links = await page.evaluate('''
                () => {
                    const links = [];
                    const containers = document.querySelectorAll('div.ty-column4');
                    containers.forEach(container => {
                        const anchors = container.querySelectorAll('a.product-title');
                        anchors.forEach(anchor => {
                            const href = anchor.getAttribute('href');
                            if (href) {
                                links.push(href);
                            }
                        });
                    });
                    return links;
                }
            ''')
            
            # Convert to absolute URLs
            full_urls = []
            for link in product_links:
                if link.startswith('http'):
                    full_urls.append(link)
                elif link.startswith('/'):
                    full_urls.append("https://geovoice.ge" + link)
                else:
                    full_urls.append(f"https://geovoice.ge/{link}")
            
            return full_urls
            
        except Exception as e:
            logger.error(f"Error extracting links from {category_url}: {e}")
            return []
    
    async def collect_with_signature_rotation(self, page, category_url, retry_count=0):
        """Collect links with signature rotation on 403"""
        self.request_count += 1
        
        # Change User-Agent every 5th request
        if self.request_count % 5 == 0:
            self.current_user_agent = random.choice(REAL_USER_AGENTS)
            logger.info(f"🔄 Rotating User-Agent (request #{self.request_count})")
        
        try:
            # Try direct access first
            links = await self.extract_links_with_stealth(page, category_url)
            if links:
                return links
            
        except Exception as e:
            error_msg = str(e).lower()
            if '403' in error_msg or 'forbidden' in error_msg:
                logger.warning(f"⚠️  403 detected at {category_url}, rotating signature...")
                
                # Close current context and create new one with different signature
                await page.context.close()
                
                # Random delay before retry
                await asyncio.sleep(random.uniform(10, 20))
                
                # Try with different entry point (search referral)
                return await self.collect_with_search_referral(category_url, retry_count + 1)
            else:
                raise
        
        return []
    
    async def collect_with_search_referral(self, category_url, retry_count=0):
        """Try accessing through search engine referral"""
        if retry_count > 2:
            logger.error(f"❌ Max retries exceeded for {category_url}")
            return []
        
        # Use different search referral
        referral = random.choice(SEARCH_REFERRALS)
        
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
            
            context = await browser.new_context(
                user_agent=random.choice(REAL_USER_AGENTS),
                viewport=self.get_random_viewport(),
                extra_http_headers={
                    'Referer': referral,
                    'Accept-Language': 'en-US,en;q=0.9',
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8'
                }
            )
            
            # Add stealth scripts
            await context.add_init_script("""
                Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                Object.defineProperty(navigator, 'languages', {get: () => ['en-US', 'en']});
            """)
            
            page = await context.new_page()
            
            try:
                links = await self.extract_links_with_stealth(page, category_url)
                await context.close()
                await browser.close()
                return links
            except Exception as e:
                await context.close()
                await browser.close()
                
                # Try Google Cache as last resort
                if retry_count == 2:
                    logger.info(f"🌐 Trying Google Cache for {category_url}")
                    return await self.collect_via_google_cache(category_url)
                
                return []
    
    async def collect_via_google_cache(self, category_url):
        """Try accessing via Google Cache"""
        cache_url = self.get_google_cache_url(category_url)
        
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True, args=['--no-sandbox'])
            context = await browser.new_context(
                user_agent=random.choice(REAL_USER_AGENTS),
                viewport=self.get_random_viewport()
            )
            page = await context.new_page()
            
            try:
                await page.goto(cache_url, wait_until="domcontentloaded", timeout=30000)
                await asyncio.sleep(2)
                
                # Extract links from cached page
                links = await page.evaluate('''
                    () => {
                        const links = [];
                        const anchors = document.querySelectorAll('a[href*="geovoice.ge"]');
                        anchors.forEach(anchor => {
                            const href = anchor.getAttribute('href');
                            if (href && href.includes('geovoice.ge') && !href.includes('webcache')) {
                                links.push(href);
                            }
                        });
                        return [...new Set(links)];
                    }
                ''')
                
                await context.close()
                await browser.close()
                return links[:20]  # Limit to avoid duplicates
            except:
                await context.close()
                await browser.close()
                return []
    
    async def collect_from_category_links(self, category_file="geovoice_category_links.txt"):
        """Collect all product links using stealth techniques"""
        # Use absolute path to ensure file is in correct location
        script_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        category_file_path = os.path.join(script_dir, "scrapers", "geovoice", category_file)
        logger.info(f"📂 Reading category page links from {category_file_path}")
        
        try:
            with open(category_file_path, 'r', encoding='utf-8') as f:
                category_page_links = [line.strip() for line in f if line.strip()]
        except Exception as e:
            logger.error(f"❌ Error reading category page links: {e}")
            return False
        
        if not category_page_links:
            logger.error("❌ No category page links found!")
            return False
        
        logger.info(f"🎯 Starting stealth collection for {len(category_page_links)} pages")
        
        all_product_links = []
        
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
            
            for i, category_url in enumerate(category_page_links, 1):
                logger.info(f"📄 [{i}/{len(category_page_links)}] Processing: {category_url}")
                
                # Create fresh context for each request (session isolation)
                context = await browser.new_context(
                    user_agent=self.current_user_agent,
                    viewport=self.get_random_viewport(),
                    extra_http_headers={
                        'Referer': random.choice(SEARCH_REFERRALS),
                        'Accept-Language': 'en-US,en;q=0.9',
                        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8'
                    }
                )
                
                # Add stealth scripts
                await context.add_init_script("""
                    Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                    Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                    Object.defineProperty(navigator, 'languages', {get: () => ['en-US', 'en']});
                    window.chrome = {runtime: {}};
                """)
                
                page = await context.new_page()
                
                try:
                    # Random delay between requests (5-15 seconds)
                    if i > 1:
                        delay = random.uniform(5, 15)
                        logger.info(f"⏱️  Waiting {delay:.1f}s before request...")
                        await asyncio.sleep(delay)
                    
                    # Collect links with signature rotation
                    links = await self.collect_with_signature_rotation(page, category_url)
                    
                    if links:
                        all_product_links.extend(links)
                        logger.info(f"✅ Extracted {len(links)} links from {category_url}")
                    else:
                        logger.warning(f"⚠️  No links extracted from {category_url}")
                    
                except Exception as e:
                    logger.error(f"❌ Error processing {category_url}: {e}")
                
                await context.close()
                
                # Progress update
                if i % 10 == 0:
                    logger.info(f"📊 Progress: {i}/{len(category_page_links)} pages, {len(all_product_links)} links collected")
            
            await browser.close()
        
        # Remove duplicates
        unique_links = list(set(all_product_links))
        logger.info(f"🎉 Total unique product links collected: {len(unique_links)}")
        
        # Save to file
        output_file = os.path.join(SCRIPT_DIR, "geovoice_product_links.txt")
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                for link in unique_links:
                    f.write(link + '\n')
            logger.info(f"💾 Saved all product links to {output_file}")
            return True
        except Exception as e:
            logger.error(f"❌ Error saving product links: {e}")
            return False

async def main():
    """Main execution for stealth Geovoice product link collection."""
    logger.info("🚀 === Stealth Geovoice Product Link Collection Started ===")
    
    collector = StealthLinkCollector()
    if await collector.collect_from_category_links():
        logger.info("✅ All Geovoice product links collected successfully!")
        
        output_file = os.path.join(SCRIPT_DIR, "geovoice_product_links.txt")
        with open(output_file, 'r', encoding='utf-8') as f:
            link_count = len([line.strip() for line in f.readlines() if line.strip()])
        
        logger.info(f"📊 Total links ready for scraping: {link_count}")
        logger.info("✅ Ready for next step: Individual product scraping")
    else:
        logger.error("❌ Failed to collect product links!")

if __name__ == "__main__":
    asyncio.run(main())
