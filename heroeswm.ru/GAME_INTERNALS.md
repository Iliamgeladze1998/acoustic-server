# HeroesWM.ru — Complete Game Internals

## Account
- Login: ARMORED (oxygenous_music)
- ID: 8777586
- Combat level: 1
- Gold: ~3,404
- PHPSESSID: 8356c909f3f0a190aeeba8040c0c637f
- PL_JS_SIGN: 3d84b5f3a5310eee48141276fdafe3dd

---

## 1. MAP SYSTEM (map.php)

### Map Structure
- 25 sectors (24 accessible, East Island locked)
- Movement: 120s horizontal/vertical, 169s diagonal
- Move URL: `move_sector.php?id=<sectorid>`
- Sector IDs: 1=Empire Capital, 2=East River, ... 24=Ungovernable Steppe

### Hunt Mechanics (CRITICAL)
- **Hunt cooldown**: 40 min day (08:00-00:00), 20 min night (00:00-08:00)
- **Beginners (level 1-2)**: 5 min cooldown, 2.5 min night
- **Licenses**: Hunter (-35% time), Master Hunter (-60%), Abu-Bakir charm (-30%)
- **Max efficiency**: 14 min day, 7 min night (Master Hunter + Abu-Bakir)
- **Instant hunt**: 0.1 diamonds
- **Guild level 6**: Two monsters appear, pick one

### Hunt URLs (from map_functions.js)
```
Attack monster:  map.php?action=attack&js_output=1&rand=<random>
Attack with auto: map.php?action=attack&auto=1&sign=<PL_JS_SIGN>&js_output=1&rand=<random>
Skip monster:    map.php?action=skip&js_output=1&rand=<random>
```

### Hunt Response Format
- Server returns: `MAP_CSS_GOOD_JS_ANSWER_PREFIX|map_hunt_block_div|<html_content>|<delta_seconds>`
- `MapHunterDelta` = seconds until next hunt
- When delta < 0, page auto-refreshes to map.php

### Hunt Buttons (3 buttons in map_hunt_block_div)
1. `hunt_but_1` — Attack (Напасть) → `hwm_map_send_attack_request(this, '', 0)`
2. `hunt_but_2` — Call help (Позвать на помощь) → disabled for low levels
3. `hunt_but_3` — Pass (Пройти мимо) → `hwm_map_send_hunt_cancel_request(event)`

### Monster Info
- Monster shown as animation (e.g. "goblinani" for goblins)
- `show_info_init_array` contains monster display data
- `neut_monster_block` = neutral monster block element ID

### Work Objects on Map
- Objects listed in table with: Name, Clan, Resource count, Pay rate
- Object types: Mining (mn), Manufacturing (fc), Production (sh), Houses (hs)
- Object URL: `object-info.php?id=<id>`
- Work filter URLs: `map.php?cx=50&cy=50&st=<type>`

---

## 2. WORK SYSTEM (object-info.php)

### Work Application
- Object page has work code/captcha system
- `work_code_data` collects browser fingerprint (screen, navigator, etc.)
- Captcha input field: `id="code"`
- Work requires captcha after first 5 free jobs per day
- Work submission via AJAX with: `obj_id`, `res_id`, `count`, `check_code`, `sign`
- Pay rate shown in gold per hour

### Resource Selling
- Objects allow buying/selling resources
- Form class: `obj-sell-res-form` with `data-res-id`
- AJAX post: `ajax_post: "create", obj_id, res_id, count, check_code, sign`

---

## 3. BATTLE SYSTEM (war.php)

### Battle Engine
- Canvas-based rendering (Konva.js for map, custom engine for battles)
- `enginep.js` (204KB) = main battle engine
- `battle-damage-tooltip.js` (166KB) = community battle overlay script

### Battle Globals
- `stage.pole.obj` — array of all unit objects
- `stage.pole.obj_array` — array of unit indices
- `activeobj` — index of currently active unit
- `wmap2` — pathfinding map for active unit (1D array, y*defxn+x)
- `defxn`, `defyn` — battlefield dimensions (typically 11x8 or 15x11)
- `mapobj` — occupancy map (y*defxn+x = unit index)
- `magic` — array of active spell effects per unit
- `heroes` — array of hero unit indices
- `umelka` — faction skill array
- `my_side` — player's side (not always defined)
- `lastturn` — current turn number
- `btype` — battle type
- `gtype` — game type
- `plid2` — player ID (or -2 for neutral hunt)

### Unit Properties (from stage.pole.obj)
```
obj_index, nametxt, filename, nownumber, maxnumber, nowhealth, maxhealth,
attack, attackaddon, defence, defenceaddon, ragedefence, defencemodifier,
speed, ragespeed, speedaddon, speedmodifier, init, nowinit,
x, y, side, owner, hero, shooter, flyer, big, bigx, bigy,
shots, mindam, maxdam, damageaddon, mindamaddon, maxdamaddon, ragedamage,
rock, boss, undead, alive, mechanical, armoured, organicarmor, immaterial,
building, stone, siegewalls, caster, maxmanna, nowmanna,
shadowattack, teleport, range, nopenalty, rangepenalty, warmachine,
dodge, brittle, lshield, hollowbones, diamondarmor, shielded, unprotectedtarget,
giantkiller, pygmykiller, stormstrike, undeadkiller, pirate,
cruelty, morecruelty, oppressionofweak, fearofstrong, sorcererslayer,
ridercharge, jousting, blindingcharge, charge, shieldwall,
safeposition, agilesteed, viciousstrike, deathstrike, vorpalsword, bladeofslaughter,
leap, crashingleap, preciseshot, forcearrow, armorpiercing, ignoredefence, ignoreattack,
festeringaura, defensivestance, agility, spirit, rageagainsttheliving,
stormstrike, skycontrol, aimedshot, omnipresentgaze, sacredweapon,
shroudofdarkness, tasteofdarkness, cruelingleadership, perseverancem
```

### Damage Formula (from battle-damage-tooltip.js attackmonster function)
```
monatt = attack + attackaddon + rageattack
mondef = (defence + defenceaddon + defadd + ragedefence) * defencemodifier

if monatt > mondef:
  AttackDefenseModifier = 1 + (monatt - mondef) * 0.05
else:
  AttackDefenseModifier = 1 / (1 + (mondef - monatt) * 0.05)

mindam = mindam + damageaddon + (maxdam - mindam) * mindamaddon + ragedamage
maxdam = maxdam + damageaddon - (maxdam - mindam) * maxdamaddon + ragedamage

PhysicalDamage = nownumber * mindam * AttackDefenseModifier * PhysicalModifiers * UmelkaModifiers
PhysicalDamage2 = nownumber * maxdam * AttackDefenseModifier * PhysicalModifiers * UmelkaModifiers
```

### Physical Modifiers (multiplicative)
- Shooter blocked (adjacent enemy): ×0.5
- Range penalty (beyond range): ×0.5
- Wall obstruction: ×0.5
- Melee: dodge ×0.5, brittle ×1.25
- Archer perks: Archery ×1.2, Evasion ×0.8
- Shield effects: lshield ×0.5, diamondarmor ×0.1, shielded ×0.75
- Creature abilities: giantkiller ×2, stormstrike ×2, undeadkiller ×1.5
- Charge bonuses: ridercharge reduces def, jousting +5%/move, charge +10%/move
- Morale/retaliation/faction modifiers
- Perks: Attack I/II/III ×1.1/1.2/1.3, Defense I/II/III ×0.9/0.8/0.7

### Speed/Movement
```
spd = round((speed + ragespeed + speedaddon) * speedmodifier)
```
- `wmap2[y*defxn+x]` = distance from active unit to (x,y)
- Entangled (magic[attacker]['ent']): spd = 0
- Flyers ignore terrain
- Big units (2x2) have adjusted coordinates

### Auto Battle
- Keyboard key 'A' (keyCode 65) triggers `fastbut_onRelease2()`
- Auto placement: key 'R' (keyCode 82) triggers `make_ins_but()`
- Start battle: key 'B' (keyCode 66)
- These are in-game functions, not URL-based

### Magic System
- Spells: magicarrow, lighting, firearrow, icebolt, implosion, poison, meteor,
  chainlighting, fireball, stormcaller, firewall, circle_of_winter, stonespikes,
  magicfist, angerofhorde, swarm, divinev, blind, raisedead
- Spell damage: `eff = effmain + effmult * pow(nownumber, 0.7)` (for non-hero)
- Hero spell: `eff = effmain + effmult * spellpower`
- Elements: air, fire, water, earth
- Faction modifier: `1 - umelka[defender][faction] * 0.03`

---

## 4. MERCENARY GUILD (mercenary_guild.php)

### Requirements
- Combat level 5+ (account is level 1 — LOCKED)

### Quest Types
- ID 2: Invaders
- ID 3: Brigands
- ID 4: Monster
- ID 5: Raid
- ID 7: Vanguard
- ID 9: Army
- ID 10: Conspirators

### Mercenary URLs
```
Accept quest:  mercenary_guild.php?action=accept_merc<ID>&sign=<PL_JS_SIGN>
Skip quest:    mercenary_guild.php?action=skip&sign=<PL_JS_SIGN>
Instant (diamond): mercenary_guild.php?action=instant_merc&sign=<PL_JS_SIGN>
Instant (gold):   mercenary_guild.php?action=instant_merc&gold_price=100&sign=<PL_JS_SIGN>
```

### Quest Flow
1. Get quest at mercenary guild office (sectors 2, 6, 16, 21)
2. Travel to quest location on map
3. Click "Autobattle" or fight manually
4. Return to guild office for reward

---

## 5. HUNTER GUILD (hunter_guild.php)

### Hunt Rewards
- Gold per hunt
- Hunter guild points (proportional to damage dealt)
- Artifact chance: [3 + HG level]% 
- Artifacts: Hunter set (lvl 3+), Master Hunter (lvl 5+), Great Hunter (lvl 6+), Beastbane (lvl 6+)
- HG level 2+: Can call friend for help (same sector, LVL±2)
- HG level 6+: Two monsters appear, pick one

### Hunt gives less than PvP
- 2x less faction points
- 5x less combat experience

---

## 6. ECONOMY

### Money Sources
1. **Work**: Passive income, ~165 gold/hour at level 1
2. **Hunt**: Gold + artifacts + HG points
3. **Mercenary quests**: Gold + faction points (requires level 5)
4. **Roulette**: 35:1 straight bet, 5-min intervals
5. **Auction**: Buy low, sell high
6. **Craft**: Resource processing
7. **PvP battles**: Victory bounty
8. **Tavern card game**: Strategic

### Resource Types
- Gold, Wood, Ore, Mercury, Sulfur, Crystals, Gems, Diamonds

---

## 7. URL ENDPOINT MAP

### Core Pages
| URL | Purpose |
|-----|---------|
| `home.php` | Character home, stats, tasks |
| `map.php` | World map, hunt, work objects |
| `inventory.php` | Equipment management |
| `shop.php` | Buy items |
| `auction.php` | Player marketplace |
| `pl_info.php?id=<id>` | Player profile |
| `skillwheel.php` | Skill tree |
| `castle.php` | Faction castle |
| `tavern.php` | Card game |
| `roulette.php` | Roulette |
| `frames.php?room=<n>` | Chat rooms |

### Action Endpoints
| URL | Purpose |
|-----|---------|
| `map.php?action=attack` | Attack hunt monster |
| `map.php?action=attack&auto=1&sign=<sign>` | Auto-attack hunt |
| `map.php?action=skip` | Skip hunt monster |
| `map.php?cx=<x>&cy=<y>&st=<type>` | Filter work objects |
| `move_sector.php?id=<id>` | Move to sector |
| `object-info.php?id=<id>` | View work object |
| `mercenary_guild.php?action=accept_merc<ID>&sign=<sign>` | Accept merc quest |
| `mercenary_guild.php?action=skip&sign=<sign>` | Skip merc quest |
| `mercenary_guild.php?action=instant_merc&sign=<sign>` | Instant new quest (diamonds) |
| `buy_res.php` | Buy resource from object |
| `war.php` | Battle page |
| `hunter_guild.php` | Hunter guild info |
| `leader_guild.php` | Leader guild |
| `task_guild.php` | Guard guild |
| `bselect.php` | Battle selection |
| `one_to_one.php` | Duels |
| `group_wars.php` | Group battles |
| `pvp_guild.php` | Tactics guild |
| `mapwars.php` | Territory wars |

### JavaScript Files
| File | Size | Purpose |
|------|------|---------|
| `enginep.js` | 204KB | Battle engine |
| `map_functions.js` | 32KB | Map/hunt functions |
| `konva_map.js` | 555KB | Map rendering (Konva.js) |
| `hwm_basic.js` | 17KB | UI utilities, topline |
| `hwm_hints.js` | 8KB | Tooltips |
| `topline_scripts2020.js` | 9KB | Top bar scripts |
| `show_info.js` | ? | Monster animation display |
| `sweetalert.min.js` | ? | Dialog library |

---

## 8. KEY JAVASCRIPT FUNCTIONS

### Map/Hunt (map_functions.js)
- `hwm_map_send_attack_request(event, nt, auto)` — Attack monster
- `hwm_map_send_hunt_cancel_request(event)` — Skip monster
- `hwm_map_send_obj_block_request(event, cx, cy, st)` — Filter work type
- `map_html_handle_data()` — Process AJAX response
- `map_hunt_refresh()` — Countdown timer
- `print_hunt_time_new(t)` — Display hunt timer

### Battle (battle-damage-tooltip.js / enginep.js)
- `attackmonster(attacker, ax, ay, x, y, defender, ...)` — Full damage calc
- `stage.pole.calcmagic_script(...)` — Magic damage calc
- `stage.pole.attackmagic(...)` — Apply magic damage
- `fastbut_onRelease2()` — Auto battle button
- `make_ins_but()` — Auto placement
- `battle_is_it_perk(unitIdx, perkId)` — Check if unit has perk
- `stage.pole.getmorale(unitIdx)` — Get morale
- `stage.pole.checkmembrane(defender)` — Shield guard check
- `stage.pole.magicmod(attacker, defender, fire, air, water, earth, 0.1)` — Elemental modifier

---

## 9. BATTLE AI INTEGRATION POINTS

### Active Unit Detection
- `activeobj` global → `stage.pole.obj[activeobj]`
- Fallback: highest `nowinit` in `obj_array`

### Side Detection
- `side` property: 1 = player (red), -1 = enemy (blue)
- `owner` property: player index (1 or 2)
- Player is always side 1 (hardcoded in battle_ai_v6.js)

### Pathfinding
- `wmap2[y*defxn+x]` = distance from active unit
- Only valid for active unit's movement
- Others: use Chebyshev distance: `max(abs(dx), abs(dy))`

### Shooter Blocking
- Check 8 adjacent + diagonal cells for enemy units
- If enemy adjacent → shooter blocked → melee damage ×0.5

---

## 10. AUTOMATION STRATEGY (for level 1 account)

### Available Now
1. **Hunt**: `map.php?action=attack` — 5 min cooldown (level 1-2)
2. **Work**: Apply at objects via `object-info.php` — needs captcha after 5/day
3. **Roulette**: `roulette.php` — 100 gold min bet

### Locked (need level 5+)
- Mercenary guild quests
- PvP battles (need armed character)

### Best Auto-Hunt Flow
1. Fetch `map.php` 
2. Check if `map_hunt_block_div` contains attack button (not `home_disabled`)
3. If available: GET `map.php?action=attack&js_output=1&rand=<random>`
4. Parse response for battle redirect or delta time
5. If battle started: navigate to `war.php` page (manual fight needed)
6. After battle: return to `map.php` and wait for cooldown
7. Cooldown for level 1: 5 minutes (300 seconds)

### Auto-Work Flow
1. Fetch `map.php` to get object list
2. For each object: fetch `object-info.php?id=<id>`
3. Check for work availability and captcha
4. If no captcha: submit work form with sign
5. If captcha: open page for manual entry
6. Work lasts 1 hour, then need to reapply
