#!/usr/bin/env python3
"""
Browser-Use Agent — ready-to-use browser automation agent.
Uses Google Gemini for LLM and headless Chrome via CDP.

Usage:
  python browser_agent.py "Go to acoustic.ge and find all keyboards under 500 GEL"

The script automatically:
1. Launches headless Chrome with remote debugging
2. Connects browser-use agent via CDP
3. Runs the task
4. Cleans up Chrome on exit
"""

import asyncio
import subprocess
import sys
import os
import signal
import time

CHROME_PATH = "/root/.cache/ms-playwright/chromium-1228/chrome-linux64/chrome"
CDP_PORT = 9222
GEMINI_API_KEY = os.environ.get("GOOGLE_API_KEY", "AIzaSyBIK5j7j0wiOhmHMCadmeTWlMwhZgp0qH4")


def launch_chrome():
    """Launch headless Chrome with remote debugging enabled."""
    proc = subprocess.Popen(
        [
            CHROME_PATH,
            "--headless=new",
            "--no-sandbox",
            "--disable-gpu",
            "--disable-dev-shm-usage",
            f"--remote-debugging-port={CDP_PORT}",
            "about:blank",
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    # Wait for CDP to be ready
    import urllib.request
    for _ in range(10):
        try:
            urllib.request.urlopen(f"http://127.0.0.1:{CDP_PORT}/json/version", timeout=2)
            print(f"✅ Chrome CDP ready on port {CDP_PORT} (PID {proc.pid})")
            return proc
        except Exception:
            time.sleep(1)
    print("❌ Chrome CDP failed to start")
    proc.kill()
    return None


async def run_agent(task: str, max_steps: int = 30):
    """Run a browser-use agent task."""
    from browser_use import Agent, BrowserProfile, BrowserSession
    from browser_use.llm.google import ChatGoogle

    llm = ChatGoogle(model="gemini-2.0-flash", api_key=GEMINI_API_KEY)

    profile = BrowserProfile(
        headless=True,
        cdp_url=f"http://127.0.0.1:{CDP_PORT}",
    )
    session = BrowserSession(browser_profile=profile)

    agent = Agent(
        task=task,
        llm=llm,
        browser_session=session,
    )

    print(f"🤖 Agent task: {task}")
    print(f"   Max steps: {max_steps}")
    print("   Running...\n")

    result = await agent.run(max_steps=max_steps)

    print(f"\n{'='*60}")
    print(f"✅ Agent finished!")
    print(f"   Steps taken: {len(result.history)}")
    if result.final_result:
        print(f"   Result: {result.final_result}")
    print(f"{'='*60}")

    return result


def main():
    if len(sys.argv) < 2:
        print("Usage: python browser_agent.py \"<task description>\"")
        print('Example: python browser_agent.py "Go to google.com and search for cats"')
        sys.exit(1)

    task = sys.argv[1]
    max_steps = int(sys.argv[2]) if len(sys.argv) > 2 else 30

    chrome_proc = launch_chrome()
    if not chrome_proc:
        sys.exit(1)

    try:
        asyncio.run(run_agent(task, max_steps=max_steps))
    except KeyboardInterrupt:
        print("\n⚠️  Interrupted by user")
    finally:
        chrome_proc.terminate()
        chrome_proc.wait(timeout=5)
        print("🧹 Chrome cleaned up.")


if __name__ == "__main__":
    main()
