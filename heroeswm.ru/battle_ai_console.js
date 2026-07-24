// =====================================================
// HeroesWM Battle AI - Console Script
// =====================================================
// Usage: Open browser console (F12) during a battle on heroeswm.ru
// Paste this entire script and press Enter
// The AI advisor panel will appear in the top-right corner
// It auto-updates every second during battle
// =====================================================

(function() {
    // Remove old instance if exists
    if (window.__battleAI) {
        clearInterval(window.__battleAI.timer);
        const old = document.getElementById('__bai_overlay');
        if (old) old.remove();
    }

    window.__battleAI = { timer: null };

    // ---- CSS ----
    const css = `
    #__bai_overlay {
        position: fixed; top: 10px; right: 10px; width: 360px;
        background: rgba(10,15,30,0.95); color: #ddd;
        font-family: 'Segoe UI',Arial,sans-serif; font-size: 13px;
        border: 2px solid #3a7; border-radius: 10px; padding: 14px;
        z-index: 999999; box-shadow: 0 0 25px rgba(0,255,120,0.4);
        pointer-events: none; max-height: 85vh; overflow-y: auto;
    }
    #__bai_overlay h2 { color: #3a7; font-size: 16px; margin: 0 0 8px 0; border-bottom: 1px solid #3a7; padding-bottom: 5px; }
    #__bai_overlay .bai-active { color: #7af; font-weight: bold; margin-bottom: 6px; }
    #__bai_overlay .bai-advice { font-size: 15px; color: #fc4; font-weight: bold; padding: 10px; background: rgba(255,200,50,0.12); border-radius: 6px; margin-bottom: 10px; line-height: 1.4; }
    #__bai_overlay .bai-move { padding: 5px 8px; margin: 3px 0; border-radius: 4px; font-size: 12px; }
    #__bai_overlay .bai-move.best { background: rgba(0,255,80,0.18); border-left: 4px solid #0f0; }
    #__bai_overlay .bai-move.other { opacity: 0.55; }
    #__bai_overlay .bai-move.unreachable { opacity: 0.3; }
    #__bai_overlay .bai-stats { font-size: 11px; color: #777; margin-top: 8px; padding-top: 6px; border-top: 1px solid #2a2a3a; }
    #__bai_overlay .bai-threat { display: inline-block; padding: 2px 10px; border-radius: 4px; font-weight: bold; font-size: 11px; }
    #__bai_overlay .bai-threat.win { background: rgba(0,180,0,0.3); color: #0f0; }
    #__bai_overlay .bai-threat.even { background: rgba(180,180,0,0.3); color: #cc0; }
    #__bai_overlay .bai-threat.lose { background: rgba(180,0,0,0.3); color: #f44; }
    #__bai_overlay .bai-wait { text-align: center; padding: 30px; color: #777; font-size: 14px; }
    #__bai_overlay .bai-coord { color: #4cf; font-weight: bold; }
    `;

    // ---- Helpers ----
    function log(m) { console.log('[BattleAI] ' + m); }

    function getMySide() {
        try {
            if (typeof my_side !== 'undefined') return my_side;
            if (stage && stage.pole && stage.pole.my_side != null) return stage.pole.my_side;
            // Try to detect from hero positions
            // Player hero is typically at bottom (higher Y values) on side 1
            return 1;
        } catch(e) { return 1; }
    }

    function getUnits() {
        const units = [];
        try {
            const objs = stage.pole.obj;
            const arr = stage.pole.obj_array;
            for (let k of arr) {
                const c = objs[k];
                if (!c || c.nownumber <= 0) continue;
                if (c.hero === 1) continue;
                units.push({
                    ref: c, idx: k,
                    name: c.nametxt || '???',
                    count: c.nownumber || 0,
                    hp: c.nowhealth || c.maxhealth || 0,
                    maxHp: c.maxhealth || 1,
                    totalHp: (c.nownumber - 1) * (c.maxhealth || 1) + (c.nowhealth || c.maxhealth || 1),
                    atk: c.attack || 0,
                    def: c.defence || 0,
                    init: (c.maxinit || 0) * (c.initmodifier || 1),
                    x: c.x, y: c.y,
                    owner: c.owner,
                    shooter: (c.shoot === 1 || c.shoot === true || (c.data_string && c.data_string.includes('shoot'))),
                    data: c.data_string || '',
                });
            }
        } catch(e) { log('getUnits error: ' + e.message); }
        return units;
    }

    function getActiveUnit() {
        try {
            const objs = stage.pole.obj;
            const arr = stage.pole.obj_array;

            // Try various methods to find active unit
            if (typeof cur_unit !== 'undefined' && cur_unit != null) return objs[cur_unit];
            if (stage.pole.current_unit != null) return objs[stage.pole.current_unit];
            if (stage.pole.active_unit != null) return objs[stage.pole.active_unit];

            // Check for active flag
            for (let k of arr) {
                const c = objs[k];
                if (!c || c.nownumber <= 0 || c.hero === 1) continue;
                if (c.active === 1 || c.is_active === 1 || c.turn === 1) return c;
            }

            // Fallback: highest initiative unacted unit
            let best = null, bestInit = -1;
            for (let k of arr) {
                const c = objs[k];
                if (!c || c.nownumber <= 0 || c.hero === 1) continue;
                if (c.acted === 1 || c.is_acted === 1) continue;
                const i = (c.maxinit || 0) * (c.initmodifier || 1);
                if (i > bestInit) { bestInit = i; best = c; }
            }
            return best;
        } catch(e) { return null; }
    }

    function getDmg(atkIdx, defIdx) {
        try {
            if (typeof get_dmg_info === 'function') return get_dmg_info(atkIdx, defIdx);
            if (stage && stage.pole && typeof stage.pole.get_dmg_info === 'function') return stage.pole.get_dmg_info(atkIdx, defIdx);
        } catch(e) {}
        return null;
    }

    function calcKilled(dmg, def) {
        if (!def || !def.maxhealth) return 0;
        let k;
        if (dmg % def.maxhealth > (def.nowhealth || 0)) k = Math.floor(dmg / def.maxhealth) + 1;
        else k = Math.floor(dmg / def.maxhealth);
        return Math.min(k, def.nownumber || 0);
    }

    function hexDist(x1, y1, x2, y2) {
        const dx = Math.abs(x1 - x2);
        const dy = Math.abs(y1 - y2);
        return Math.max(dx, Math.ceil(dy / 2));
    }

    function canReach(attacker, defender) {
        if (!attacker || !defender) return false;
        if (attacker.shooter) return true;
        const dist = hexDist(attacker.x, attacker.y, defender.x, defender.y);
        const speed = attacker.ref.speed || attacker.ref.maxspeed || attacker.ref.speedmax || 0;
        // If adjacent, always reachable
        if (dist <= 1) return true;
        // Check speed
        return dist <= Math.max(1, speed);
    }

    // ---- Analysis ----
    function analyze() {
        try {
            if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) {
                return { status: 'wait', msg: 'Battle not loaded yet...' };
            }

            const mySide = getMySide();
            const units = getUnits();
            if (units.length === 0) return { status: 'wait', msg: 'No units found...' };

            const active = getActiveUnit();
            if (!active) return { status: 'wait', msg: 'Waiting for turn...' };

            // Find attacker in our list
            let attacker = units.find(u => u.idx === active.obj_index);
            if (!attacker) attacker = units.find(u => u.ref === active);
            if (!attacker) return { status: 'wait', msg: 'Cannot identify active unit' };

            // Check if it's our turn
            if (attacker.owner !== mySide) {
                return { status: 'enemy', msg: 'Enemy turn: ' + attacker.name + ' x' + attacker.count };
            }

            const enemies = units.filter(u => u.owner !== mySide);
            if (enemies.length === 0) return { status: 'done', msg: 'No enemies left!' };

            // Analyze each enemy as target
            const moves = [];
            for (const enemy of enemies) {
                const move = {
                    name: enemy.name,
                    x: enemy.x, y: enemy.y,
                    count: enemy.count,
                    shooter: enemy.shooter,
                    dmgMin: 0, dmgMax: 0,
                    killMin: 0, killMax: 0,
                    score: 0,
                    reason: '',
                    canReach: canReach(attacker, enemy),
                    distance: hexDist(attacker.x, attacker.y, enemy.x, enemy.y),
                    retaliation: null,
                };

                if (move.canReach) {
                    const di = getDmg(attacker.idx, enemy.idx);
                    if (di) {
                        move.dmgMin = di.min || 0;
                        move.dmgMax = di.max || 0;
                        move.killMin = di.min_killed || calcKilled(move.dmgMin, enemy.ref);
                        move.killMax = di.max_killed || calcKilled(move.dmgMax, enemy.ref);
                    }

                    const avgDmg = (move.dmgMin + move.dmgMax) / 2;
                    const avgKill = (move.killMin + move.killMax) / 2;
                    let score = avgDmg;

                    // Priority: shooters first
                    if (enemy.shooter) { score *= 1.6; move.reason = '🏹 Shooter! '; }

                    // Destroying stack = no retaliation
                    if (avgKill >= enemy.count) {
                        score *= 1.4;
                        score += 800;
                        move.reason += '💀 Destroyed! ';
                    } else if (!attacker.shooter) {
                        // Calculate retaliation
                        const ri = getDmg(enemy.idx, attacker.idx);
                        if (ri) {
                            const rKill = calcKilled(ri.max, attacker.ref);
                            score -= rKill * attacker.maxHp * 0.8;
                            move.retaliation = { min: ri.min, max: ri.max, kills: rKill };
                        }
                    }

                    // Initiative: killing fast units is valuable
                    score += enemy.init * avgKill * 3;

                    // Damage efficiency
                    const eff = avgDmg / (enemy.totalHp || 1);
                    score += eff * 200;

                    // Low-value target penalty
                    if (enemy.count <= 1 && !enemy.shooter) { score *= 0.6; move.reason += 'Low value. '; }

                    move.score = Math.round(score);
                    if (!move.reason) move.reason = avgKill > 0 ? '⚔️ Good damage' : '⚠️ Low damage';
                } else {
                    move.reason = '🚫 Out of range (' + move.distance + ')';
                    move.score = -1;
                }

                moves.push(move);
            }

            moves.sort((a, b) => b.score - a.score);

            // Also check: should we move closer?
            const bestAttack = moves.find(m => m.canReach && m.score > 0);
            let advice = '';
            let bestMove = null;

            if (bestAttack) {
                bestMove = bestAttack;
                advice = '⚔️ დაესხი: ' + bestAttack.name + ' x' + bestAttack.count +
                    ' | უჯრა: [' + bestAttack.x + ',' + bestAttack.y + ']' +
                    ' | ზიანი: ' + bestAttack.dmgMin + '-' + bestAttack.dmgMax +
                    ' | მოკლული: ' + bestAttack.killMin + '-' + bestAttack.killMax +
                    ' | ' + bestAttack.reason;
                if (bestAttack.retaliation) {
                    advice += ' | ⚠️ კონტრ-დარტყმა: ' + bestAttack.retaliation.min + '-' + bestAttack.retaliation.max;
                }
            } else {
                // Find closest enemy to move toward
                let closest = null;
                for (const e of enemies) {
                    const d = hexDist(attacker.x, attacker.y, e.x, e.y);
                    if (!closest || d < closest.dist) closest = { enemy: e, dist: d };
                }
                if (closest) {
                    advice = '🏃 წადი ახლოს: ' + closest.enemy.name + ' (' + closest.dist + ' უჯრა)';
                    bestMove = { type: 'move', target: closest.enemy, distance: closest.dist };
                } else {
                    advice = '🛡️ დაიცავი';
                    bestMove = { type: 'defend' };
                }
            }

            // Battlefield assessment
            const myU = units.filter(u => u.owner === mySide);
            const enU = enemies;
            const myThreat = myU.reduce((s, u) => s + u.atk * u.count * u.init, 0);
            const enThreat = enU.reduce((s, u) => s + u.atk * u.count * u.init, 0);
            const advantage = enThreat > 0 ? (myThreat / enThreat) : 1;
            const status = advantage > 1.3 ? 'win' : advantage < 0.7 ? 'lose' : 'even';
            const statusText = advantage > 1.3 ? 'მოგებული' : advantage < 0.7 ? 'წაგებული' : 'თანაბარი';

            return {
                status: 'ok',
                attackerName: attacker.name,
                attackerCount: attacker.count,
                attackerHp: attacker.hp,
                attackerX: attacker.x,
                attackerY: attacker.y,
                advice,
                bestMove,
                moves: moves.slice(0, 6),
                myCount: myU.length,
                enCount: enU.length,
                myThreat: Math.round(myThreat),
                enThreat: Math.round(enThreat),
                statusText,
                status,
            };
        } catch(e) {
            return { status: 'error', msg: e.message };
        }
    }

    // ---- UI ----
    function ensureOverlay() {
        let el = document.getElementById('__bai_overlay');
        if (el) return el;

        const style = document.createElement('style');
        style.textContent = css;
        document.head.appendChild(style);

        el = document.createElement('div');
        el.id = '__bai_overlay';
        document.body.appendChild(el);
        return el;
    }

    function render(a) {
        const el = ensureOverlay();
        if (!el) return;

        if (a.status === 'wait' || a.status === 'enemy' || a.status === 'done' || a.status === 'error') {
            el.innerHTML = '<h2>⚔️ Battle AI</h2><div class="bai-wait">' + (a.msg || '...') + '</div>';
            return;
        }

        let html = '<h2>⚔️ Battle AI Advisor</h2>';

        // Active unit info
        html += '<div class="bai-active">შენი სვლა: ' + a.attackerName + ' ×' + a.attackerCount +
            ' (HP:' + a.attackerHp + ') უჯრა:[' + a.attackerX + ',' + a.attackerY + ']</div>';

        // Main advice
        html += '<div class="bai-advice">' + a.advice + '</div>';

        // Top targets
        html += '<div style="font-size:11px;color:#888;margin-bottom:4px">საუკეთესო სამიზნეები:</div>';
        a.moves.forEach((m, i) => {
            const cls = i === 0 && m.canReach ? 'best' : m.canReach ? 'other' : 'unreachable';
            let line = '<div class="bai-move ' + cls + '">';
            line += '<b>' + m.name + '</b> ×' + m.count;
            line += ' | უჯრა: <span class="bai-coord">[' + m.x + ',' + m.y + ']</span>';
            if (m.canReach) {
                line += ' | ზიანი: ' + m.dmgMin + '-' + m.dmgMax;
                line += ' | მოკლული: ' + m.killMin + '-' + m.killMax;
                if (m.retaliation) line += ' | ⚠️კონტრ:' + m.retaliation.max;
                line += ' | Score:' + m.score;
            } else {
                line += ' | ' + m.reason;
            }
            line += '</div>';
            html += line;
        });

        // Stats
        const cls = 'bai-threat ' + a.status;
        html += '<div class="bai-stats">';
        html += 'რაზმები: ' + a.myCount + ' vs ' + a.enCount + ' | ';
        html += 'საფრთხე: ' + a.myThreat + ' vs ' + a.enThreat + ' ';
        html += '<span class="' + cls + '">' + a.statusText + '</span>';
        html += '</div>';

        el.innerHTML = html;
    }

    // ---- Main loop ----
    log('Battle AI starting...');
    render({ status: 'wait', msg: 'ინიციალიზაცია...' });

    window.__battleAI.timer = setInterval(function() {
        const a = analyze();
        render(a);
        if (a.status === 'ok') log(a.advice);
    }, 1000);

    // Immediate first check
    setTimeout(function() {
        const a = analyze();
        render(a);
    }, 100);

    log('Battle AI ready! Panel should appear top-right.');
    console.log('%c⚔️ Battle AI ჩართულია! პანელი მარჯვენა ზედა კუთხეში გამოჩნდება.', 'color:#0f0;font-size:16px;font-weight:bold');
    console.log('%c💡 თუ არ მუშაობს, აკრიფე: battleAI.debug()', 'color:#ff0;font-size:14px');
    console.log('%c💡 გასათიშად: battleAI.stop()', 'color:#f88;font-size:14px');

    // ---- Debug function ----
    window.battleAI = {
        debug: function() {
            console.log('=== Battle AI Debug ===');
            console.log('stage exists:', typeof stage !== 'undefined');
            if (typeof stage !== 'undefined') {
                console.log('stage.pole exists:', !!stage.pole);
                if (stage.pole) {
                    console.log('stage.pole.obj exists:', !!stage.pole.obj);
                    console.log('stage.pole.obj_array:', stage.pole.obj_array);
                    if (stage.pole.obj) {
                        const arr = stage.pole.obj_array || Object.keys(stage.pole.obj);
                        console.log('All units:');
                        for (let k of arr) {
                            const c = stage.pole.obj[k];
                            if (!c) continue;
                            console.log('  [' + k + ']', c.nametxt, 'x' + c.nownumber,
                                'owner:' + c.owner, 'hero:' + c.hero,
                                'ATK:' + c.attack, 'DEF:' + c.defence,
                                'HP:' + c.nowhealth + '/' + c.maxhealth,
                                'pos:[' + c.x + ',' + c.y + ']',
                                'init:' + c.maxinit,
                                'shoot:' + c.shoot,
                                'obj_index:' + c.obj_index);
                        }
                    }
                }
            }
            console.log('get_dmg_info exists:', typeof get_dmg_info !== 'undefined');
            console.log('cur_unit:', typeof cur_unit !== 'undefined' ? cur_unit : 'undefined');
            console.log('my_side:', typeof my_side !== 'undefined' ? my_side : 'undefined');
            // Check for other useful globals
            const usefulVars = ['heroes', 'magic', 'defxn', 'defyn', 'mapobj', 'battle_is_it_perk', 'animspeed', 'timer_interval'];
            for (let v of usefulVars) {
                try {
                    console.log(v + ':', typeof window[v] !== 'undefined' ? window[v] : 'undefined');
                } catch(e) {}
            }
            // Try to find active unit
            console.log('--- Trying to find active unit ---');
            if (typeof stage !== 'undefined' && stage.pole && stage.pole.obj) {
                const arr = stage.pole.obj_array;
                for (let k of arr) {
                    const c = stage.pole.obj[k];
                    if (!c || c.nownumber <= 0) continue;
                    if (c.active || c.is_active || c.turn) {
                        console.log('Found active unit:', c.nametxt, 'via flag');
                    }
                }
            }
        },
        stop: function() {
            clearInterval(window.__battleAI.timer);
            const el = document.getElementById('__bai_overlay');
            if (el) el.remove();
            console.log('%c⚔️ Battle AI გამორთული.', 'color:#f88;font-size:14px');
        },
        analyze: analyze,
    };

})();
