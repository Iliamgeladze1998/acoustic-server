// =====================================================
// HeroesWM Battle AI v6 - FULL ANALYSIS + DUAL VISUAL
// =====================================================
// F12 -> Console -> Paste -> Enter
// Analyzes: board, armies, turn order, best move
// Visual: DOM rings (proven to work) + hex highlight
// Console: full debug log every cycle
// =====================================================

(function() {
    if (window.__bai3) {
        clearInterval(window.__bai3.timer);
        if (window.__bai3.lastRings) for (const r of window.__bai3.lastRings) { if (r) r.remove(); }
        if (window.__bai3.lastHex) try { for (const h of window.__bai3.lastHex) { const t = shado[h.x + h.y * defxn]; if (t) { t.fill(null); set_visible(t, 0); } } } catch(e) {}
        const old = document.getElementById('__bai3_panel');
        if (old) old.remove();
    }
    window.__bai3 = { timer: null, lastRings: [], lastHex: [], cycle: 0 };
    let mySide = 1; // will be updated each analyze() call

    const s = document.createElement('style');
    s.textContent = `
    #__bai3_panel {
        position: fixed; top: 10px; right: 10px; width: 380px;
        background: rgba(0,0,0,0.93); color: #fff;
        font-family: Arial,sans-serif; font-size: 14px;
        border: 2px solid #0f0; border-radius: 10px; padding: 15px;
        z-index: 999999; box-shadow: 0 0 20px rgba(0,255,0,0.4);
        pointer-events: none; max-height: 90vh; overflow-y: auto;
    }
    #__bai3_panel .t { color: #0f0; font-size: 17px; font-weight: bold; margin-bottom: 8px; border-bottom: 1px solid #0f0; padding-bottom: 5px; }
    #__bai3_panel .act { color: #ff0; font-size: 17px; font-weight: bold; margin: 8px 0; line-height: 1.5; padding: 10px; background: rgba(255,200,50,0.12); border-radius: 6px; }
    #__bai3_panel .turnq { font-size: 11px; color: #7af; margin: 6px 0; }
    #__bai3_panel .army { font-size: 12px; margin: 4px 0; }
    #__bai3_panel .army.me { color: #7f7; }
    #__bai3_panel .army.en { color: #f77; }
    #__bai3_panel .enemy { color: #f80; font-size: 13px; margin: 6px 0; padding: 6px; background: rgba(255,140,0,0.15); border-radius: 6px; }
    #__bai3_panel .wt { color: #888; text-align: center; padding: 15px; }
    #__bai3_panel .sub { color: #aaa; font-size: 11px; margin-top: 4px; }
    .__bai3_ring {
        position: fixed; z-index: 999999; pointer-events: none;
        border-radius: 50%; border: 4px solid;
    }
    .__bai3_ring.tgt { border-color: #00ff00; box-shadow: 0 0 20px #0f0; width: 60px; height: 60px; animation: __bai3_p 0.8s infinite; }
    .__bai3_ring.atk { border-color: #ff3333; box-shadow: 0 0 20px #f00; width: 60px; height: 60px; animation: __bai3_p 0.8s infinite; }
    .__bai3_ring.mov { border-color: #00ccff; box-shadow: 0 0 20px #0cf; border-style: dashed; width: 60px; height: 60px; animation: __bai3_p 0.8s infinite; }
    .__bai3_ring.enemymov { border-color: #ff8800; box-shadow: 0 0 20px #f80; width: 55px; height: 55px; border-width: 3px; animation: __bai3_p 0.8s infinite; }
    @keyframes __bai3_p { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:0.4;transform:scale(1.15)} }
    `;
    document.head.appendChild(s);

    function clearRings() { for (const r of window.__bai3.lastRings) { if (r) r.remove(); } window.__bai3.lastRings = []; }
    function clearHex() {
        try { for (const h of window.__bai3.lastHex) { const t = shado[h.x + h.y * defxn]; if (t) { t.fill(null); set_visible(t, 0); } } } catch(e) {}
        window.__bai3.lastHex = [];
    }
    function clearAll() { clearRings(); clearHex(); }

    function highlightHex(x, y, color) {
        try {
            const t = shado[x + y * defxn];
            if (!t) return false;
            t.fill(color); set_visible(t, 1);
            window.__bai3.lastHex.push({ x, y });
            return true;
        } catch(e) { return false; }
    }

    function drawRing(scrX, scrY, type) {
        const pole = document.getElementById('pole');
        const off = pole ? pole.getBoundingClientRect() : { left: 0, top: 0 };
        const m = document.createElement('div');
        m.className = '__bai3_ring ' + type;
        m.style.position = 'fixed';
        m.style.left = (off.left + scrX - 30) + 'px';
        m.style.top = (off.top + scrY - 30) + 'px';
        document.body.appendChild(m);
        window.__bai3.lastRings.push(m);
    }

    // Draw ring using grid coords (always correct)
    function drawRingAtGrid(x, y, type) {
        const s = gridToScreen(x, y);
        drawRing(s.x, s.y, type);
    }

    // ---- Grid (x,y) to screen coords converter ----
    // Built from actual game data calibration
    function gridToScreen(x, y) {
        // Try to find a unit AT this position and use its scr_x/scr_y
        try {
            const idx = mapobj[x + y * defxn];
            if (idx !== undefined && stage.pole.obj[idx]) {
                const c = stage.pole.obj[idx];
                if (c.scr_x !== undefined) return { x: c.scr_x, y: c.scr_y };
            }
        } catch(e) {}
        // Fallback: use formula (approximate)
        // Calibrated from: x=0,y=2→78,162 | x=8,y=1→505,86 | x=8,y=7→565,544
        const scrX = 78 + x * 54.6 + (y - 2) * 10;
        const scrY = 86 + (y - 1) * 76;
        return { x: scrX, y: scrY };
    }

    // ---- Determine player's side ----
    // Player is always side 1 (red) in HeroesWM
    function getMySide() {
        return 1;
    }

    // ---- Read all units ----
    function getUnits() {
        const units = [];
        try {
            const arr = stage.pole.obj_array;
            for (let k of arr) {
                const c = stage.pole.obj[k];
                if (!c) continue;
                if (c.dead === 1 || c.nownumber <= 0) continue;
                if (!c.it_unit) continue;
                units.push({
                    idx: k, ref: c,
                    name: c.nametxt || '???',
                    count: c.nownumber || 0,
                    hp: c.nowhealth || c.maxhealth || 0,
                    maxHp: c.maxhealth || 1,
                    totalHp: (c.nownumber - 1) * (c.maxhealth || 1) + (c.nowhealth || c.maxhealth || 1),
                    atk: c.attack || 0, def: c.defence || 0,
                    speed: Math.round(((c.speed || 0) + (c.ragespeed || 0) + (c.speedaddon || 0)) * (c.speedmodifier || 1)),
                    init: c.maxinit || 0, nowinit: c.nowinit || 0,
                    x: c.x, y: c.y,
                    scrX: c.scr_x || c._x || 0, scrY: c.scr_y || c._y || 0,
                    owner: c.owner, side: c.side,
                    shooter: c.shooter === 1, flyer: c.flyer === 1, hero: c.hero === 1,
                    mindam: c.mindam || 0, maxdam: c.maxdam || 0,
                    ret: c.ret, big: c.big === 1,
                    shots: c.shots,
                    doing: c.doing || '',
                    destx: c.destx, desty: c.desty,
                });
            }
        } catch(e) { console.log('[BAI] getUnits error: ' + e.message); }
        return units;
    }

    // ---- Turn order queue (sort by nowinit descending) ----
    function getTurnQueue(units) {
        return units.filter(u => !u.hero || u.nowinit >= 0)
            .sort((a, b) => b.nowinit - a.nowinit);
    }

    // ---- Active unit = use game's activeobj if available ----
    function getActiveUnit(units) {
        // Try game's native activeobj first (most reliable)
        try {
            if (typeof activeobj !== 'undefined' && activeobj !== 0 && activeobj !== null) {
                const c = stage.pole.obj[activeobj];
                if (c && c.it_unit && c.nownumber > 0) {
                    const found = units.find(u => u.idx === activeobj);
                    if (found) return found;
                }
            }
        } catch(e) {}
        // Fallback: highest nowinit (but skip heroes with nowinit < 0)
        let best = null, bestInit = -9999;
        for (let u of units) {
            if (u.hero && u.nowinit < 0) continue;
            if (u.nowinit > bestInit) { bestInit = u.nowinit; best = u; }
        }
        if (!best) { for (let u of units) { if (u.nowinit > bestInit) { bestInit = u.nowinit; best = u; } } }
        return best;
    }

    // ---- Damage calc ----
    function calcDamage(attacker, defender) {
        const avgDmg = (attacker.mindam + attacker.maxdam) / 2;
        let mult;
        if (attacker.atk > defender.def) mult = 1 + 0.05 * (attacker.atk - defender.def);
        else if (attacker.atk < defender.def) mult = 1 / (1 + 0.05 * (defender.def - attacker.atk));
        else mult = 1;
        const totalDmg = attacker.count * avgDmg * mult;
        const minDmg = attacker.count * attacker.mindam * mult;
        const maxDmg = attacker.count * attacker.maxdam * mult;
        return {
            min: Math.round(minDmg), max: Math.round(maxDmg), avg: Math.round(totalDmg),
            minKills: Math.min(Math.floor(minDmg / defender.maxHp), defender.count),
            maxKills: Math.min(Math.floor(maxDmg / defender.maxHp), defender.count),
            avgKills: Math.min(Math.floor(totalDmg / defender.maxHp), defender.count),
        };
    }

    // ---- Distance: use wmap2 for active unit, Chebyshev for others ----
    function dist(a, b) {
        // wmap2 is only valid for the currently active unit's pathfinding
        try {
            if (typeof wmap2 !== 'undefined' && wmap2 && typeof activeobj !== 'undefined') {
                // Check if 'a' is the currently active unit
                const aRef = a.ref || a;
                const activeRef = stage.pole.obj[activeobj];
                if (activeRef && aRef === activeRef) {
                    const d = wmap2[b.y * defxn + b.x];
                    if (d !== undefined && d >= 0) return d;
                }
            }
        } catch(e) {}
        // Fallback: Chebyshev distance (8-directional movement)
        return Math.max(Math.abs(a.x - b.x), Math.abs(a.y - b.y));
    }

    // ---- Win probability estimation ----
    function calcWinProbability(myUnits, enUnits) {
        // Calculate army strength for each side
        // Strength = total HP * damage potential * initiative factor
        let myStr = 0, enStr = 0;

        for (let u of myUnits) {
            if (u.hero) { myStr += 500; continue; } // hero adds flat value
            const avgDmg = (u.mindam + u.maxdam) / 2;
            const dmgPerUnit = avgDmg * Math.max(1, 1 + 0.05 * Math.max(0, u.atk - 5));
            const totalDmg = u.count * dmgPerUnit;
            const hp = u.totalHp;
            const initFactor = 1 + (u.init / 20); // higher init = more turns = more value
            const shooterBonus = u.shooter ? 1.3 : 1;
            const flyerBonus = u.flyer ? 1.15 : 1;
            myStr += (hp + totalDmg * 2) * initFactor * shooterBonus * flyerBonus;
        }

        for (let u of enUnits) {
            if (u.hero) { enStr += 500; continue; }
            const avgDmg = (u.mindam + u.maxdam) / 2;
            const dmgPerUnit = avgDmg * Math.max(1, 1 + 0.05 * Math.max(0, u.atk - 5));
            const totalDmg = u.count * dmgPerUnit;
            const hp = u.totalHp;
            const initFactor = 1 + (u.init / 20);
            const shooterBonus = u.shooter ? 1.3 : 1;
            const flyerBonus = u.flyer ? 1.15 : 1;
            enStr += (hp + totalDmg * 2) * initFactor * shooterBonus * flyerBonus;
        }

        if (myStr + enStr === 0) return 50;
        // Logistic function for smoother probability
        const ratio = myStr / (myStr + enStr);
        let prob = Math.round(ratio * 100);

        // Factor in unit count advantage (more stacks = more tactical options)
        const myStacks = myUnits.filter(u => !u.hero).length;
        const enStacks = enUnits.length;
        if (myStacks > enStacks) prob += 3;
        if (enStacks > myStacks) prob -= 3;

        return Math.max(1, Math.min(99, prob));
    }

    // ---- Is shooter blocked by adjacent enemy? ----
    function isShooterBlocked(shooter, allUnits) {
        if (!shooter.shooter) return false;
        if (shooter.shots === 0) return true; // no arrows left
        for (let u of allUnits) {
            if (u.side === shooter.side) continue; // same team
            if (u.hero) continue;
            if (u.count <= 0) continue;
            // Check all 8 adjacent + diagonal coords
            const dx = Math.abs(u.x - shooter.x);
            const dy = Math.abs(u.y - shooter.y);
            if (dx <= 1 && dy <= 1 && (dx + dy > 0)) return true;
        }
        return false;
    }

    // ---- Get adjacent enemies (for blocked shooter) ----
    function getAdjacentEnemies(unit, allUnits) {
        const adj = [];
        for (let u of allUnits) {
            if (u.side === unit.side) continue; // same team
            if (u.hero) continue;
            if (u.count <= 0) continue;
            const dx = Math.abs(u.x - unit.x);
            const dy = Math.abs(u.y - unit.y);
            if (dx <= 1 && dy <= 1 && (dx + dy > 0)) adj.push(u);
        }
        return adj;
    }

    // ---- Can attacker reach defender? ----
    function canReach(attacker, defender, allUnits) {
        if (attacker.shooter) {
            const blocked = isShooterBlocked(attacker, allUnits);
            if (!blocked) return true; // shooter can hit anyone if not blocked
            const d = dist(attacker, defender);
            return d <= 1; // blocked: only melee adjacent
        }
        if (attacker.flyer) return true; // flyers ignore obstacles
        const d = dist(attacker, defender);
        return d <= Math.max(1, attacker.speed);
    }

    // ---- Clone unit for simulation ----
    function cloneUnit(u) {
        return {
            idx: u.idx, name: u.name, count: u.count,
            hp: u.hp, maxHp: u.maxHp, totalHp: u.totalHp,
            atk: u.atk, def: u.def, speed: u.speed,
            init: u.init, nowinit: u.nowinit,
            x: u.x, y: u.y, scrX: u.scrX, scrY: u.scrY,
            owner: u.owner, side: u.side,
            shooter: u.shooter, flyer: u.flyer, hero: u.hero,
            mindam: u.mindam, maxdam: u.maxdam, ret: u.ret, big: u.big,
            ref: u.ref, shots: u.shots,
        };
    }

    // ---- Simulate attack on cloned units ----
    function simAttack(state, atkIdx, defIdx) {
        const atk = state[atkIdx];
        const def = state[defIdx];
        if (!atk || !def || atk.count <= 0 || def.count <= 0) return;

        const dmg = calcDamage(atk, def);
        const kills = Math.min(dmg.avgKills, def.count);
        def.count -= kills;
        if (def.count <= 0) {
            def.count = 0;
            def.totalHp = 0;
        } else {
            const remainingHp = def.hp - (dmg.avg - kills * def.maxHp);
            def.hp = Math.max(1, remainingHp);
            def.totalHp = (def.count - 1) * def.maxHp + def.hp;
        }

        // Retaliation (melee only, if defender survives and can retaliate)
        if (!atk.shooter && def.count > 0 && def.ret) {
            const retal = calcDamage(def, atk);
            const rKills = Math.min(retal.avgKills, atk.count);
            atk.count -= rKills;
            if (atk.count <= 0) {
                atk.count = 0;
                atk.totalHp = 0;
            } else {
                const rHp = atk.hp - (retal.avg - rKills * atk.maxHp);
                atk.hp = Math.max(1, rHp);
                atk.totalHp = (atk.count - 1) * atk.maxHp + atk.hp;
            }
        }
    }

    // ---- Simulate move (reposition) ----
    function simMove(state, unitIdx, newX, newY) {
        const u = state[unitIdx];
        if (!u) return;
        u.x = newX;
        u.y = newY;
    }

    // ---- Evaluate position (higher = better for me) ----
    function evalState(state) {
        let myStr = 0, enStr = 0;
        for (let i = 0; i < state.length; i++) {
            const u = state[i];
            if (!u || u.count <= 0) continue;
            if (u.hero) {
                if (u.side === mySide) myStr += 500;
                else enStr += 500;
                continue;
            }
            const avgDmg = (u.mindam + u.maxdam) / 2;
            const dmgVal = u.count * avgDmg * (1 + 0.05 * Math.max(0, u.atk - u.def));
            const hpVal = u.totalHp;
            const initF = 1 + u.init / 20;
            const shootF = u.shooter ? 1.3 : 1;
            const flyF = u.flyer ? 1.15 : 1;
            const val = (hpVal + dmgVal * 2) * initF * shootF * flyF;
            if (u.side === mySide) myStr += val;
            else enStr += val;
        }
        return myStr - enStr;
    }

    // ---- Get all possible actions for a unit ----
    function getActions(unit, state) {
        const actions = [];
        const enemies = [];
        for (let i = 0; i < state.length; i++) {
            const u = state[i];
            if (!u || u.count <= 0) continue;
            if (u.side === unit.side) continue;
            if (u.hero) continue;
            enemies.push({ idx: i, unit: u });
        }

        for (const e of enemies) {
            const d = dist(unit, e.unit);
            const reachable = canReach(unit, e.unit, state.filter(u => u !== null));
            if (reachable) {
                actions.push({ type: 'attack', target: e.idx, d });
            }
        }

        // If no attacks possible, add "move toward nearest enemy"
        if (actions.length === 0 && !unit.shooter) {
            let nearest = null;
            let minD = 999;
            for (const e of enemies) {
                const d = dist(unit, e.unit);
                if (d < minD) { minD = d; nearest = e; }
            }
            if (nearest) {
                const spd = Math.max(1, unit.speed);
                if (minD > spd) {
                    const dx = nearest.unit.x - unit.x;
                    const dy = nearest.unit.y - unit.y;
                    const ratio = spd / minD;
                    actions.push({
                        type: 'move',
                        x: Math.round(unit.x + dx * ratio),
                        y: Math.round(unit.y + dy * ratio),
                        d: minD,
                    });
                }
            }
        }

        // "Wait" action (skip turn)
        actions.push({ type: 'wait' });

        return actions;
    }

    // ---- Get turn order from state (by nowinit desc) ----
    function getTurnOrder(state) {
        const order = [];
        for (let i = 0; i < state.length; i++) {
            const u = state[i];
            if (!u || u.count <= 0) continue;
            if (u.hero && u.nowinit < 0) continue;
            order.push({ idx: i, nowinit: u.nowinit });
        }
        order.sort((a, b) => b.nowinit - a.nowinit);
        return order.map(o => o.idx);
    }

    // ---- Minimax with alpha-beta pruning ----
    // depth = number of half-turns to look ahead (5 = 5 plies)
    // Turn order determined by nowinit (NOT alternating like chess!)
    function minimax(state, depth, alpha, beta) {
        // Terminal: depth 0 or no enemies/units left
        const myAlive = state.filter(u => u && u.count > 0 && u.side === mySide && !u.hero).length;
        const enAlive = state.filter(u => u && u.count > 0 && u.side !== mySide && !u.hero).length;

        if (depth === 0 || enAlive === 0 || myAlive === 0) {
            return { score: evalState(state), bestAction: null };
        }

        // Get whose turn it is from nowinit (same as real game)
        const order = getTurnOrder(state);
        if (order.length === 0) return { score: evalState(state), bestAction: null };

        const activeIdx = order[0];
        const activeUnit = state[activeIdx];
        if (!activeUnit || activeUnit.count <= 0) {
            return { score: evalState(state), bestAction: null };
        }

        // Determine if this unit is mine or enemy's (NOT alternating!)
        const isMyUnit = activeUnit.side === mySide;
        const actions = getActions(activeUnit, state);

        let bestAction = null;

        if (isMyUnit) {
            // Maximizing - my unit's turn
            let maxEval = -Infinity;
            for (const action of actions) {
                const newState = state.map(u => u ? cloneUnit(u) : null);

                if (action.type === 'attack') {
                    simAttack(newState, activeIdx, action.target);
                } else if (action.type === 'move') {
                    simMove(newState, activeIdx, action.x, action.y);
                }

                // Decrement nowinit so next unit in queue goes next
                if (newState[activeIdx]) newState[activeIdx].nowinit -= 100;

                const result = minimax(newState, depth - 1, alpha, beta);
                if (result.score > maxEval) {
                    maxEval = result.score;
                    bestAction = action;
                }
                alpha = Math.max(alpha, result.score);
                if (beta <= alpha) break;
            }
            return { score: maxEval, bestAction };
        } else {
            // Minimizing - enemy unit's turn
            let minEval = Infinity;
            for (const action of actions) {
                const newState = state.map(u => u ? cloneUnit(u) : null);

                if (action.type === 'attack') {
                    simAttack(newState, activeIdx, action.target);
                } else if (action.type === 'move') {
                    simMove(newState, activeIdx, action.x, action.y);
                }

                if (newState[activeIdx]) newState[activeIdx].nowinit -= 100;

                const result = minimax(newState, depth - 1, alpha, beta);
                if (result.score < minEval) {
                    minEval = result.score;
                    bestAction = action;
                }
                beta = Math.min(beta, result.score);
                if (beta <= alpha) break;
            }
            return { score: minEval, bestAction };
        }
    }

    // ---- Main analysis ----
    function analyze() {
        try {
            if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) {
                return { status: 'wait', msg: 'ბრძოლა ჩატვირთვა...' };
            }

            const units = getUnits();
            if (units.length === 0) return { status: 'wait', msg: 'რაზმები არ არიან...' };

            mySide = getMySide();
            const myUnits = units.filter(u => u.side === mySide);
            const enUnits = units.filter(u => u.side !== mySide && !u.hero);
            const enAll = units.filter(u => u.side !== mySide);
            const queue = getTurnQueue(units);
            const active = getActiveUnit(units);
            const winProb = calcWinProbability(myUnits, enAll);

            // Log to console every 5 cycles
            window.__bai3.cycle++;
            if (window.__bai3.cycle % 5 === 1) {
                console.log('%c=== BATTLE ANALYSIS #' + window.__bai3.cycle + ' ===', 'color:#0ff;font-weight:bold');
                console.log('my_side: ' + mySide + ' | Grid: ' + (typeof defxn !== 'undefined' ? defxn + 'x' + defyn : '?') + ' | Units: ' + units.length);
                console.log('Sides:', units.map(u => u.name + '(side:' + u.side + ',owner:' + u.owner + ')').join(', '));
                console.log('Turn queue:', queue.map(u => u.name + '(i:' + u.nowinit + ')').join(' → '));
                console.log('My army:', myUnits.map(u => u.name + '×' + u.count + ' HP:' + u.hp).join(', '));
                console.log('Enemy:', enUnits.map(u => u.name + '×' + u.count + ' HP:' + u.hp).join(', '));
                if (active) console.log('Active: ' + active.name + '×' + active.count + ' (init:' + active.nowinit + ')');
                console.log('%cმოგების შანსი: ' + winProb + '%', 'color:#' + (winProb >= 60 ? '0f0' : winProb >= 40 ? 'ff0' : 'f55') + ';font-weight:bold;font-size:14px');
            }

            if (!active) return { status: 'wait', msg: 'ველოდებით სვლას...' };

            const isMyTurn = active.side === mySide;
            clearAll();

            // Track enemy movements
            let enemyMoveInfo = '';
            for (let u of units) {
                if (u.side === mySide) continue;
                if (u.hero) continue;
                const dx = u.destx !== undefined ? u.destx : null;
                const dy = u.desty !== undefined ? u.desty : null;
                if (dx !== null && dy !== null && (dx !== u.x || dy !== u.y) && u.doing && u.doing !== '') {
                    // Enemy is moving to destx,desty
                    drawRingAtGrid(dx, dy, 'enemymov');
                    highlightHex(dx, dy, '#ff8800');
                    enemyMoveInfo += '<div class="enemy">🏃 ' + u.name + ' ×' + u.count + ' → [' + dx + ',' + dy + ']</div>';
                }
            }

            if (!isMyTurn) {
                // Highlight active enemy (use grid coords)
                drawRingAtGrid(active.x, active.y, 'enemymov');
                highlightHex(active.x, active.y, '#ff8800');
                return {
                    status: 'enemy',
                    msg: 'მტრის სვლა: ' + active.name + ' ×' + active.count,
                    enemyMoveInfo,
                    queue, myUnits, enUnits, winProb,
                };
            }

            // My turn - find best target using minimax
            if (enUnits.length === 0) {
                return { status: 'done', msg: 'მტრები აღარ არიან!' };
            }

            // If hero's turn - still show best target recommendation
            if (active.hero) {
                // Find best target for hero's spell (highest threat enemy)
                let bestSpellTarget = null;
                let bestSpellScore = -1;
                for (const enemy of enUnits) {
                    const dmg = calcDamage(active, enemy);
                    let score = dmg.avg;
                    if (enemy.shooter) score *= 1.6;
                    if (dmg.avgKills >= enemy.count) score += 500;
                    score += enemy.init * dmg.avgKills * 3;
                    if (score > bestSpellScore) { bestSpellScore = score; bestSpellTarget = enemy; }
                }

                if (bestSpellTarget) {
                    highlightHex(bestSpellTarget.x, bestSpellTarget.y, '#00ff00');
                    drawRingAtGrid(bestSpellTarget.x, bestSpellTarget.y, 'tgt');
                    const dmg = calcDamage(active, bestSpellTarget);
                    let action = '🧙 გმირის სვლა - გამოიყენე ჯადო!';
                    action += '<br>🎯 საუკეთესო სამიზნე: ' + bestSpellTarget.name + ' ×' + bestSpellTarget.count;
                    action += '<br>📍 უჯრა: [' + bestSpellTarget.x + ', ' + bestSpellTarget.y + ']';
                    action += '<br>💥 ზიანი: ' + dmg.min + '-' + dmg.max;
                    action += '<br>💀 მოკლული: ' + dmg.minKills + '-' + dmg.maxKills;
                    if (bestSpellTarget.shooter) action += '<br>📝 🏹 მშვილდოსანი - პრიორიტეტი!';
                    if (dmg.avgKills >= bestSpellTarget.count) action += '<br>📝 💀 განადგურდება!';

                    // Also show next unit's recommendation
                    const nextUnit = queue.find(u => u.side === mySide && !u.hero && u !== active);
                    if (nextUnit) {
                        action += '<br>⏭ შემდეგი შენი რაზმი: ' + nextUnit.name + ' ×' + nextUnit.count;
                    }

                    return { status: 'ok', activeName: active.name, activeCount: 1, action, moves: [], enemyMoveInfo, queue, myUnits, enUnits, winProb };
                }
                return { status: 'ok', activeName: active.name, activeCount: 1, action: '🧙 გმირის სვლა - გამოიყენე ჯადო!', moves: [], enemyMoveInfo, queue, myUnits, enUnits, winProb };
            }

            // Build state array for minimax (indexed by position in units array)
            const state = units.map(u => cloneUnit(u));
            const activeIdx = units.indexOf(active);

            // Run minimax with alpha-beta pruning
            // Depth adapts to unit count for performance
            const unitCount = units.filter(u => !u.hero && u.count > 0).length;
            const SEARCH_DEPTH = unitCount <= 4 ? 5 : unitCount <= 6 ? 4 : 3;
            const aiResult = minimax(state, SEARCH_DEPTH, -Infinity, Infinity);
            const bestAction = aiResult.bestAction;

            // Also compute simple heuristic moves for display
            const moves = [];
            for (const enemy of enUnits) {
                const d = dist(active, enemy);
                const reachable = canReach(active, enemy, units);
                const blocked = active.shooter ? isShooterBlocked(active, units) : false;
                const dmg = calcDamage(active, enemy);
                let score = dmg.avg;
                let reason = '';

                if (active.shooter && blocked) reason = '🔒 მსროლელი დაბლოკილია! ახლო ბრძოლა: ';
                if (enemy.shooter) { score *= 1.6; reason += '🏹 მშვილდოსანი! '; }
                if (dmg.avgKills >= enemy.count) { score *= 1.4; score += 500; reason += '💀 განადგურდება! '; }
                else if (!active.shooter && enemy.ret) {
                    const retal = calcDamage(enemy, active);
                    score -= retal.avgKills * active.maxHp * 0.8;
                }
                score += enemy.init * dmg.avgKills * 3;
                if (!reachable) {
                    if (active.shooter && blocked) { score = -1; reason = '🔒 დაბლოკილია, მხოლოდ გვერდით მტერზე'; }
                    else if (!active.shooter) { score = -1; reason = '🚫 შორსაა (' + d + ' უჯრა)'; }
                }
                moves.push({ enemy, d, reachable, dmg, score, reason });
            }
            moves.sort((a, b) => b.score - a.score);

            // Process minimax result
            if (bestAction && bestAction.type === 'attack') {
                const targetUnit = units[bestAction.target];
                const dmg = calcDamage(active, targetUnit);
                const blocked = active.shooter ? isShooterBlocked(active, units) : false;

                highlightHex(targetUnit.x, targetUnit.y, '#00ff00');
                highlightHex(active.x, active.y, '#ff0000');
                drawRingAtGrid(targetUnit.x, targetUnit.y, 'tgt');
                drawRingAtGrid(active.x, active.y, 'atk');

                let action = '⚔️ დაესხი: ' + targetUnit.name + ' ×' + targetUnit.count;
                action += '<br>📍 უჯრა: [' + targetUnit.x + ', ' + targetUnit.y + ']';
                action += '<br>💥 ზიანი: ' + dmg.min + '-' + dmg.max;
                action += '<br>💀 მოკლული: ' + dmg.minKills + '-' + dmg.maxKills;
                action += '<br>🧠 ' + SEARCH_DEPTH + '-სვლიანი ანალიზი: ' + (aiResult.score > 0 ? 'დადებითი' : 'რისკიანი') + ' (score: ' + Math.round(aiResult.score) + ')';
                if (blocked) action += '<br>📝 🔒 მსროლელი დაბლოკილია - ახლო ბრძოლა';
                if (targetUnit.shooter) action += '<br>📝 🏹 მშვილდოსანი - პრიორიტეტი!';
                if (dmg.avgKills >= targetUnit.count) action += '<br>📝 💀 განადგურდება!';
                if (!active.shooter && targetUnit.ret && dmg.avgKills < targetUnit.count) {
                    const retal = calcDamage(targetUnit, active);
                    action += '<br>⚠️ კონტრ-დარტყმა: ' + retal.min + '-' + retal.max + ' (მოკლული: ' + retal.avgKills + ')';
                } else if (active.shooter && blocked && targetUnit.ret && dmg.avgKills < targetUnit.count) {
                    const retal = calcDamage(targetUnit, active);
                    action += '<br>⚠️ კონტრ-დარტყმა: ' + retal.min + '-' + retal.max + ' (მოკლული: ' + retal.avgKills + ')';
                }

                if (window.__bai3.cycle % 5 === 1) {
                    console.log('%c→ რჩევა (5-ply): ' + targetUnit.name + ' ×' + targetUnit.count + ' | ზიანი: ' + dmg.min + '-' + dmg.max + ' | score: ' + Math.round(aiResult.score), 'color:#0f0;font-weight:bold');
                }

                return { status: 'ok', activeName: active.name, activeCount: active.count, action, moves: moves.slice(0, 4), enemyMoveInfo, queue, myUnits, enUnits, winProb };
            } else if (bestAction && bestAction.type === 'move') {
                const spd = Math.max(1, active.speed);
                let closest = null;
                for (const m of moves) { if (!closest || m.d < closest.d) closest = m; }
                const targetName = closest ? closest.enemy.name : 'მტერი';

                highlightHex(bestAction.x, bestAction.y, '#00ccff');
                highlightHex(active.x, active.y, '#ff0000');
                if (closest) {
                    highlightHex(closest.enemy.x, closest.enemy.y, '#ff8800');
                    drawRingAtGrid(closest.enemy.x, closest.enemy.y, 'enemymov');
                }
                drawRingAtGrid(bestAction.x, bestAction.y, 'mov');
                drawRingAtGrid(active.x, active.y, 'atk');

                return {
                    status: 'ok', activeName: active.name, activeCount: active.count,
                    action: '🏃 წადი ახლოს: ' + targetName +
                        '<br>🔴 შენი პოზიცია: [' + active.x + ', ' + active.y + ']' +
                        '<br>🔵 წადი უჯრაზე: [' + bestAction.x + ', ' + bestAction.y + ']' +
                        '<br>🧠 ' + SEARCH_DEPTH + '-სვლიანი ანალიზი: score: ' + Math.round(aiResult.score) +
                        '<br>📏 სიჩქარე: ' + spd + ' უჯრა',
                    moves: [], enemyMoveInfo, queue, myUnits, enUnits, winProb,
                };
            } else {
                // Wait or no action found - fallback to heuristic
                const best = moves.find(m => m.reachable && m.score > 0);
                if (best) {
                    highlightHex(best.enemy.x, best.enemy.y, '#00ff00');
                    highlightHex(active.x, active.y, '#ff0000');
                    drawRingAtGrid(best.enemy.x, best.enemy.y, 'tgt');
                    drawRingAtGrid(active.x, active.y, 'atk');

                    let action = '⚔️ დაესხი: ' + best.enemy.name + ' ×' + best.enemy.count;
                    action += '<br>� უჯრა: [' + best.enemy.x + ', ' + best.enemy.y + ']';
                    action += '<br>💥 ზიანი: ' + best.dmg.min + '-' + best.dmg.max;
                    action += '<br>� მოკლული: ' + best.dmg.minKills + '-' + best.dmg.maxKills;
                    if (best.reason) action += '<br>� ' + best.reason;

                    return { status: 'ok', activeName: active.name, activeCount: active.count, action, moves: moves.slice(0, 4), enemyMoveInfo, queue, myUnits, enUnits, winProb };
                }
            }
            return { status: 'wait', msg: 'ვერ ვიპოვე სამიზნე' };
        } catch(e) {
            console.log('[BAI] ERROR: ' + e.message);
            return { status: 'error', msg: e.message };
        }
    }

    // ---- Render ----
    function render(a) {
        let el = document.getElementById('__bai3_panel');
        if (!el) { el = document.createElement('div'); el.id = '__bai3_panel'; document.body.appendChild(el); }

        let html = '<div class="t">🧠 Battle AI v6 <span style="font-size:11px;color:#0ff">5-ply minimax</span></div>';

        // Win probability bar
        if (a.winProb !== undefined) {
            const wp = a.winProb;
            const barColor = wp >= 60 ? '#0f0' : wp >= 40 ? '#ff0' : '#f55';
            const enemyProb = 100 - wp;
            html += '<div style="margin:8px 0;padding:8px;background:rgba(0,0,0,0.4);border-radius:6px">';
            html += '<div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px">';
            html += '<span style="color:#7f7">შენ: ' + wp + '%</span>';
            html += '<span style="color:#f77">მტერი: ' + enemyProb + '%</span>';
            html += '</div>';
            html += '<div style="height:12px;border-radius:6px;background:#f55;overflow:hidden;position:relative">';
            html += '<div style="height:100%;width:' + wp + '%;background:' + barColor + ';transition:width 0.5s"></div>';
            html += '</div>';
            html += '</div>';
        }

        if (a.status !== 'ok' && a.status !== 'enemy') {
            html += '<div class="wt">' + a.msg + '</div>';
            if (a.enemyMoveInfo) html += a.enemyMoveInfo;
            el.innerHTML = html;
            return;
        }

        // Turn queue
        if (a.queue) {
            html += '<div class="turnq">⏱ სვლები: ';
            html += a.queue.slice(0, 6).map((u, i) => {
                const cls = i === 0 ? 'color:#ff0;font-weight:bold' : 'color:#7af';
                return '<span style="' + cls + '">' + u.name + '</span>';
            }).join(' → ');
            html += '</div>';
        }

        if (a.status === 'enemy') {
            html += '<div class="wt">' + a.msg + '</div>';
        } else {
            // Active unit + advice
            html += '<div style="color:#7af;font-size:13px">შენი რაზმი: ' + a.activeName + ' ×' + a.activeCount + '</div>';
            html += '<div class="act">' + a.action + '</div>';
        }

        // Enemy movement
        if (a.enemyMoveInfo) html += a.enemyMoveInfo;

        // Army status
        if (a.myUnits && a.enUnits) {
            html += '<div class="sub" style="margin-top:8px;border-top:1px solid #333;padding-top:6px">ჩემი არმია:</div>';
            for (let u of a.myUnits) {
                if (u.hero) continue;
                html += '<div class="army me">🟢 ' + u.name + ' ×' + u.count + ' (HP:' + u.hp + '/' + u.maxHp + ' ATK:' + u.atk + ' DEF:' + u.def + ' SPD:' + u.speed + (u.shooter ? ' 🏹' + u.shots : '') + (u.flyer ? ' ✈' : '') + ')</div>';
            }
            html += '<div class="sub" style="margin-top:6px">მტრის არმია:</div>';
            for (let u of a.enUnits) {
                html += '<div class="army en">🔴 ' + u.name + ' ×' + u.count + ' (HP:' + u.hp + '/' + u.maxHp + ' ATK:' + u.atk + ' DEF:' + u.def + ' SPD:' + u.speed + (u.shooter ? ' 🏹' + u.shots : '') + (u.flyer ? ' ✈' : '') + ')</div>';
            }
        }

        // Other options
        if (a.moves && a.moves.length > 1) {
            html += '<div class="sub" style="margin-top:8px;border-top:1px solid #333;padding-top:6px">სხვა ვარიანტები:</div>';
            for (let i = 1; i < a.moves.length; i++) {
                const m = a.moves[i];
                if (!m.reachable) continue;
                html += '<div class="sub">' + m.enemy.name + ' ×' + m.enemy.count +
                    ' | ზიანი: ' + m.dmg.min + '-' + m.dmg.max +
                    ' | მოკლული: ' + m.dmg.minKills + '-' + m.dmg.maxKills + '</div>';
            }
        }

        el.innerHTML = html;
    }

    // ---- Start ----
    console.log('%c🧠 Battle AI v6 ჩართულია! (5-ply minimax + alpha-beta)', 'color:#0f0;font-size:18px;font-weight:bold');
    console.log('%c🟢 მწვანე = სამიზნე | 🔴 წითელი = შენი რაზმი | 🟠 ნარიჯი = მტრის მოძრაობა', 'color:#ff0;font-size:14px');
    console.log('%c💡 Stop: battleAI.stop() | Debug: battleAI.units()', 'color:#f88;font-size:13px');

    render({ status: 'wait', msg: 'ინიციალიზაცია...' });

    window.__bai3.timer = setInterval(function() { render(analyze()); }, 600);
    setTimeout(function() { render(analyze()); }, 200);

    window.battleAI = {
        stop: function() {
            clearInterval(window.__bai3.timer);
            clearAll();
            const el = document.getElementById('__bai3_panel');
            if (el) el.remove();
            console.log('Battle AI stopped.');
        },
        setSide: function(side) {
            window.__bai3_manualSide = side;
            console.log('[BAI] Manual side set to: ' + side);
        },
        units: function() {
            const u = getUnits();
            console.table(u.map(x => ({
                name: x.name, count: x.count, side: x.side, owner: x.owner,
                hp: x.hp + '/' + x.maxHp, atk: x.atk, def: x.def, spd: x.speed,
                init: x.nowinit, pos: '[' + x.x + ',' + x.y + ']',
                shooter: x.shooter, flyer: x.flyer, shots: x.shots,
            })));
            return u;
        },
        analyze: function() { const a = analyze(); console.log(a); return a; },
    };

})();
