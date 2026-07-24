#!/usr/bin/env python3
"""
HeroesWM Roulette Bot - Safe 3-Step Martingale

Strategy: 3-step Martingale on RED/BLACK
- Step 1: bet 100   → win: +100
- Step 2: bet 200   → win: +100
- Step 3: bet 400   → win: +100
- Lose all 3: -700, reset

85.4% session win rate. Max loss per session: 700 gold.
7 wins recover 1 total loss. Near-zero bankruptcy risk.
"""
import urllib.request
import urllib.parse
import time
import re
import json
import os
import signal
import sys
import socket
import http.client

# === CONFIG ===
COOKIE = "PHPSESSID=8356c909f3f0a190aeeba8040c0c637f; pl_id=8777586"
HOST = "www.heroeswm.ru"
BASE = f"https://{HOST}/"

TG_TOKEN = None  # Disabled - no Telegram notifications
TG_CHAT = None

# 3-step Martingale - max loss 700, 85.4% session win rate
STEPS_NORMAL = [100, 200, 400]
STEPS_RECOVERY = [100, 200, 400]  # Same - 700 is always affordable

# Stop conditions
STOP_PROFIT = 50000   # Target gold
STOP_LOSS_PROFIT = -5000  # Stop if total profit drops below -5000

# State
STATE_FILE = "/root/heroeswm.ru/roul_bot_state.json"
LOG_FILE = "/root/heroeswm.ru/roul_bot.log"

# === FUNCTIONS ===
def log(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line)
    with open(LOG_FILE, "a") as f:
        f.write(line + "\n")

def telegram(msg):
    try:
        url = f"https://api.telegram.org/bot{TG_TOKEN}/sendMessage"
        data = urllib.parse.urlencode({"chat_id": TG_CHAT, "text": msg}).encode()
        req = urllib.request.Request(url, data=data)
        urllib.request.urlopen(req, timeout=10)
    except:
        pass

def fetch(url, data=None, timeout=10):
    if data:
        if isinstance(data, dict):
            encoded = urllib.parse.urlencode(data).encode()
        else:
            encoded = data.encode() if isinstance(data, str) else data
        req = urllib.request.Request(url, data=encoded)
    else:
        req = urllib.request.Request(url)
    req.add_header("Cookie", COOKIE)
    req.add_header("User-Agent", "Mozilla/5.0")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.read().decode("windows-1251", errors="replace")
    except Exception as e:
        return f"ERROR: {e}"

def get_roulette_info():
    html = fetch(BASE + "roulette.php")
    if not html or "ERROR" in html:
        return None, 999, 0
    # Try multiple regex patterns
    m = re.search(r"parlay_dec['\"]?\s*value=['\"](\d+)['\"]", html)
    if not m:
        m = re.search(r"name=['\"]parlay_dec['\"].*?value=['\"](\d+)['\"]", html)
    if not m:
        m = re.search(r"parlay_dec.*?(\d{6,})", html)
    game_id = m.group(1) if m else None
    m2 = re.search(r"H = (\d+); var M = (\d+); var S = (\d+)", html)
    if m2:
        h, mi, s = int(m2.group(1)), int(m2.group(2)), int(m2.group(3))
        total_sec = h * 3600 + mi * 60 + s
        next_spin = ((total_sec // 300) + 1) * 300
        wait = next_spin - total_sec
        return game_id, wait, total_sec
    return game_id, 999, 0

def check_result(game_id):
    html = fetch(f"{BASE}inforoul.php?id={game_id}", timeout=5)
    if not html or "ERROR" in html:
        return None
    # Try multiple patterns
    m = re.search(r"Выпало число.*?<b>(\d+)", html, re.DOTALL)
    if m:
        return int(m.group(1))
    m = re.search(r"Выпало.*?<b>(\d+)", html, re.DOTALL)
    if m:
        return int(m.group(1))
    # Check if our bet shows winnings (means result is known)
    m = re.search(r"8777586.*?<b>([\d,]+)</b>\s*</td>\s*</tr>", html, re.DOTALL)
    if m:
        # We have results but couldn't parse the number
        # Try to find it differently
        m2 = re.search(r"color=['\"]?\w+['\"]?><b>(\d+)", html)
        if m2:
            return int(m2.group(1))
    return None

def get_gold():
    html = fetch(BASE + "roulette.php", timeout=5)
    m = re.search(r'data-hwm-topline-resource-amount="gold">\s*([^<]+)', html)
    if m:
        return int(m.group(1).replace(",", "").strip())
    return -1

def place_bet(game_id, bet, bettype):
    data = {
        "parlay_dec": str(game_id),
        "minutes": "4",
        "seconds": "59",
        "bet": str(bet),
        "bettype": bettype,
        "cur_pl_bet": "0",
    }
    html = fetch(BASE + "parlay.php", data, timeout=10)
    # Check if bet was accepted
    gold = get_gold()
    return gold

def number_to_color(num):
    if num == 0:
        return "GREEN"
    reds = {1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36}
    return "RED" if num in reds else "BLACK"

def load_state():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE) as f:
            return json.load(f)
    return {
        "step": 0,
        "color": "RED",
        "total_profit": 0,
        "sessions_won": 0,
        "sessions_lost": 0,
        "consecutive_losses": 0,
        "start_gold": 0,
        "mode": "normal",  # normal or recovery
        "pending_bet": None,  # {"game_id": ..., "bet": ..., "color": ..., "gold_after": ...}
    }

def save_state(state):
    with open(STATE_FILE, "w") as f:
        json.dump(state, f, indent=2)

# === MAIN BOT ===
def main():
    log("=" * 60)
    log("HeroesWM Roulette Bot - Safe 3-Step Martingale")
    log("=" * 60)
    
    state = load_state()
    gold = get_gold()
    
    if state["start_gold"] == 0:
        state["start_gold"] = gold
    
    log(f"Bankroll: {gold:,} | Start: {state['start_gold']:,}")
    log(f"Profit so far: {state['total_profit']:+,}")
    log(f"Sessions: {state['sessions_won']}W / {state['sessions_lost']}L")
    log(f"Current step: {state['step']} | Mode: {state['mode']}")
    
    # Check for unresolved pending bet from previous run
    if state.get("pending_bet"):
        pb = state["pending_bet"]
        log(f"Found pending bet: game {pb['game_id']}, {pb['bet']:,} on {pb['color']}")
        result = check_result(pb["game_id"])
        if result is not None:
            result_color = number_to_color(result)
            won = (result_color == pb["color"])
            gold_final = get_gold()
            session_profit = gold_final - pb["gold_after"] + pb["bet"]
            if won:
                log(f"  ✅ Pending bet WON: {result} ({result_color}) → +{session_profit:,}")
                state["sessions_won"] += 1
                state["consecutive_losses"] = 0
                state["total_profit"] += session_profit
                state["step"] = 0
                state["color"] = "RED" if state["color"] == "BLACK" else "BLACK"
            else:
                log(f"  ❌ Pending bet LOST: {result} ({result_color}) → -{pb['bet']:,}")
                state["step"] += 1
                state["total_profit"] -= pb["bet"]
            state["pending_bet"] = None
            save_state(state)
            log(f"  Bankroll: {gold_final:,} | Total profit: {state['total_profit']:+,}")
        else:
            log(f"  Could not resolve pending bet, will retry later")
    
    
    last_game_id = None
    
    while True:
        try:
            # Get current game info
            game_id, wait, _ = get_roulette_info()
            
            if game_id == last_game_id:
                time.sleep(5)
                continue
            
            # Wait until 40 seconds before spin
            if wait > 40:
                log(f"Game {game_id}: waiting {wait-40}s...")
                time.sleep(wait - 40)
                for retry in range(3):
                    game_id, wait, _ = get_roulette_info()
                    if game_id is not None:
                        break
                    time.sleep(3)
            
            if wait > 20:
                time.sleep(wait - 20)
                # Retry getting game ID with backoff
                for retry in range(8):
                    game_id, wait, _ = get_roulette_info()
                    if game_id is not None:
                        break
                    log(f"Retry {retry+1}: no game ID, waiting 2s...")
                    time.sleep(2)
            
            # After retries, if still far from spin, wait more
            if game_id is not None:
                _, fresh_wait, _ = get_roulette_info()
                if fresh_wait > 20:
                    log(f"Game {game_id}: still {fresh_wait}s to spin, waiting {fresh_wait-20}s...")
                    time.sleep(fresh_wait - 20)
            
            # Determine bet
            if game_id is None:
                log(f"Could not get game ID, retrying...")
                time.sleep(10)
                continue
            
            gold = get_gold()
            steps = STEPS_NORMAL if state["mode"] == "normal" else STEPS_RECOVERY
            
            if state["step"] >= len(steps):
                # Lost all steps - reset
                log(f"*** TOTAL LOSS: -{sum(steps):,} ***")
                state["sessions_lost"] += 1
                state["consecutive_losses"] += 1
                state["total_profit"] -= sum(steps)
                state["step"] = 0
                
                save_state(state)
                last_game_id = game_id
                continue
            
            bet_amount = steps[state["step"]]
            
            # Check if we can afford it
            if bet_amount > gold:
                log(f"Can't afford bet {bet_amount} (gold: {gold}). Stopping.")
                break
            
            # Alternate color each session
            bet_color = state["color"]
            
            # Place bet
            log(f"Game {game_id}: Step {state['step']+1}/{len(steps)} | Bet {bet_amount:,} on {bet_color}")
            gold_after_bet = place_bet(game_id, bet_amount, bet_color)
            
            if gold_after_bet >= 0 and gold_after_bet < gold:
                log(f"  Bet accepted. Gold: {gold:,} → {gold_after_bet:,}")
                # Save state with pending bet so restart doesn't lose it
                state["pending_bet"] = {
                    "game_id": game_id,
                    "bet": bet_amount,
                    "color": bet_color,
                    "gold_after": gold_after_bet,
                }
                save_state(state)
            else:
                log(f"  Bet may have been rejected. Gold: {gold_after_bet}")
                # Try once more
                time.sleep(2)
                gold_after_bet = get_gold()
                if gold_after_bet >= gold:
                    log(f"  Bet definitely rejected. Skipping.")
                    last_game_id = game_id
                    time.sleep(5)
                    continue
            
            # Wait for result
            result = None
            poll_start = time.time()
            while result is None and (time.time() - poll_start) < 360:
                result = check_result(game_id)
                if result is None:
                    time.sleep(3)
            
            if result is None:
                # Fallback: check gold difference to determine win/loss
                log(f"  Could not parse result, checking gold...")
                gold_final = get_gold()
                # Compare with gold_after_bet, not gold_before — external income (battles) won't affect
                gold_diff = gold_final - gold_after_bet
                if gold_diff > 0:
                    # Gold went up after bet → won (roulette payout is ~2x for color bets)
                    won = True
                    result = -1
                    result_color = "UNKNOWN"
                    session_profit = gold_diff
                    log(f"  Gold went up: {gold_after_bet} → {gold_final} (+{gold_diff}), assuming WIN")
                elif gold_diff < 0:
                    # More gold lost (shouldn't happen normally)
                    won = False
                    result = -1
                    result_color = "UNKNOWN"
                    session_profit = gold_diff
                else:
                    # Gold unchanged from after bet = lost
                    won = False
                    result = -1
                    result_color = "UNKNOWN"
                    session_profit = -bet_amount
                    gold_final = gold_after_bet
            else:
                # Check if we won
                result_color = number_to_color(result)
                won = (result_color == bet_color)
                gold_final = get_gold()
                # Only count roulette profit, not external income
                # If won: payout is bet * 2 (for color bets), so profit = bet_amount
                # If lost: profit = -bet_amount
                if won:
                    session_profit = bet_amount
                else:
                    session_profit = -bet_amount
            
            if won:
                log(f"  ✅ Result: {result} ({result_color}) → WON +{session_profit:,}")
                state["sessions_won"] += 1
                state["consecutive_losses"] = 0
                state["total_profit"] += session_profit
                state["step"] = 0
                state["color"] = "RED" if state["color"] == "BLACK" else "BLACK"
                
                # Switch back to normal mode if bankroll recovered
                if state["mode"] == "recovery" and gold_final >= 5600:
                    state["mode"] = "normal"
                    log(f"  Switching back to NORMAL mode")
                
            else:
                log(f"  ❌ Result: {result} ({result_color}) → LOST {bet_amount:,}")
                state["step"] += 1
                state["total_profit"] -= bet_amount
                
                if state["step"] >= len(steps):
                    # Total loss
                    log(f"  *** TOTAL LOSS: -{sum(steps):,} ***")
                    state["sessions_lost"] += 1
                    state["consecutive_losses"] += 1
                    state["step"] = 0
                else:
                    next_bet = steps[state["step"]] if state["step"] < len(steps) else 0
                    log(f"  Next bet: {next_bet:,}")
            
            state["pending_bet"] = None
            save_state(state)
            log(f"  Bankroll: {gold_final:,} | Total profit: {state['total_profit']:+,}")
            log(f"  Sessions: {state['sessions_won']}W / {state['sessions_lost']}L")
            
            last_game_id = game_id
            
            # Check target
            if gold_final >= 50000:
                log(f"🎯 TARGET REACHED: {gold_final:,}!")
                break
            
            # Check stop loss (absolute ruin)
            if gold_final < 300:
                log(f"💀 STOP LOSS: {gold_final}")
                break
            
            # Check profit-based stop loss
            if state["total_profit"] <= STOP_LOSS_PROFIT:
                log(f"💀 PROFIT STOP LOSS: {state['total_profit']:+,}")
                break
            
            # Brief pause before next game
            time.sleep(5)
            
        except KeyboardInterrupt:
            log("Bot stopped by user")
            break
        except Exception as e:
            log(f"Error: {e}")
            time.sleep(10)

if __name__ == "__main__":
    main()
