#!/usr/bin/env python3
"""
Roulette race condition tester.
Checks if inforoul.php shows the result before betting closes.
"""
import urllib.request
import time
import re

COOKIE = "PHPSESSID=8356c909f3f0a190aeeba8040c0c637f; pl_id=8777586"
BASE = "https://www.heroeswm.ru/"

def fetch(url):
    req = urllib.request.Request(url)
    req.add_header("Cookie", COOKIE)
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = resp.read()
            return data.decode("windows-1251", errors="replace")
    except Exception as e:
        return f"ERROR: {e}"

def get_current_game():
    html = fetch(BASE + "roulette.php")
    m = re.search(r"parlay_dec.*?value='(\d+)'", html)
    game_id = m.group(1) if m else None
    m2 = re.search(r"H = (\d+); var M = (\d+); var S = (\d+)", html)
    if m2:
        h, mi, s = int(m2.group(1)), int(m2.group(2)), int(m2.group(3))
        total_sec = h * 3600 + mi * 60 + s
        # Next spin is at next 5-min boundary
        next_spin = ((total_sec // 300) + 1) * 300
        wait = next_spin - total_sec
        return game_id, wait, f"{h}:{mi:02d}:{s:02d}"
    return game_id, 999, "?"

def check_result(game_id):
    html = fetch(f"{BASE}inforoul.php?id={game_id}")
    m = re.search(r"Выпало число.*?<b>(\d+)", html, re.DOTALL)
    if m:
        return int(m.group(1))
    return None

print("=== Roulette Race Condition Test ===")
print("Checking if result is visible before betting closes...\n")

game_id, wait, time_str = get_current_game()
print(f"Current game: {game_id}, time: {time_str}, wait for spin: {wait}s")

if wait > 300:
    print("Too far from next spin, aborting.")
    exit()

# Check every second in the last 10 seconds before spin
target_wait = max(0, wait - 10)
print(f"Waiting {target_wait}s until 10 seconds before spin...")
time.sleep(target_wait)

print(f"\nStarting checks 10 seconds before spin:")
for i in range(15):
    result = check_result(game_id)
    _, _, t = get_current_game()
    if result is not None:
        print(f"  [{t}] Game {game_id}: RESULT LEAKED = {result} !!!")
    else:
        print(f"  [{t}] Game {game_id}: no result yet")
    time.sleep(1)

# Final check
print("\nFinal check after spin:")
time.sleep(2)
result = check_result(game_id)
print(f"  Game {game_id}: final result = {result}")
