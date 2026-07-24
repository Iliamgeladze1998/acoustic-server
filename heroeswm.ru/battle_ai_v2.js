// =====================================================
// HeroesWM Battle AI v2 - Console Script
// =====================================================
// F12 -> Console -> Paste this -> Enter
// Draws GREEN circle on best target, RED on your unit
// Shows simple text: "დაესხი [სახელი] უჯრაზე [X,Y]"
// =====================================================

(function() {
    if (window.__bai2) {
        clearInterval(window.__bai2.timer);
        document.querySelectorAll('.__bai_marker').forEach(e => e.remove());
        const old = document.getElementById('__bai_panel');
        if (old) old.remove();
    }
    window.__bai2 = { timer: null };

    // ---- Style ----
    const s = document.createElement('style');
    s.textContent = `
    #__bai_panel {
        position: fixed; top: 10px; right: 10px; width: 320px;
        background: rgba(0,0,0,0.9); color: #fff;
        font-family: Arial,sans-serif; font-size: 16px;
        border: 2px solid #0f0; border-radius: 10px; padding: 15px;
        z-index: 999999; box-shadow: 0 0 20px rgba(0,255,0,0.5);
        pointer-events: none;
    }
    #__bai_panel .title { color: #0f0; font-size: 18px; font-weight: bold; margin-bottom: 10px; }
    #__bai_panel .action { color: #ff0; font-size: 20px; font-weight: bold; margin: 10px 0; }
    #__bai_panel .sub { color: #aaa; font-size: 13px; margin-top: 8px; }
    #__bai_panel .wait { color: #888; text-align: center; padding: 20px; font-size: 15px; }
    .__bai_marker {
        position: absolute; z-index: 99999; pointer-events: none;
        border-radius: 50%; border: 4px solid;
        animation: __bai_pulse 1s infinite;
    }
    .__bai_marker.target { border-color: #00ff00; box-shadow: 0 0 15px #0f0; }
    .__bai_marker.attacker { border-color: #ff0000; box-shadow: 0 0 15px #f00; }
    .__bai_marker.move { border-color: #00ccff; box-shadow: 0 0 15px #0cf; border-style: dashed; }
    @keyframes __bai_pulse {
        0%,100% { opacity: 1; transform: scale(1); }
        50% { opacity: 0.5; transform: scale(1.1); }
    }
    `;
    document.head.appendChild(s);

    // ---- Helpers ----
    function log(m) { console.log('[BAI] ' + m); }

    function getMySide() {
        try {
            if (typeof my_side !== 'undefined') return my_side;
            if (stage.pole && stage.pole.my_side != null) return stage.pole.my_side;
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
                    speed: c.speed || c.maxspeed || c.speedmax || 0,
                });
            }
        } catch(e) {}
        return units;
    }

    function getActiveUnit() {
        try {
            const objs = stage.pole.obj;
            const arr = stage.pole.obj_array;

            if (typeof cur_unit !== 'undefined' && cur_unit != null) return objs[cur_unit];
            if (stage.pole.current_unit != null) return objs[stage.pole.current_unit];
            if (stage.pole.active_unit != null) return objs[stage.pole.active_unit];

            for (let k of arr) {
                const c = objs[k];
                if (!c || c.nownumber <= 0 || c.hero === 1) continue;
                if (c.active === 1 || c.is_active === 1 || c.turn === 1) return c;
            }

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
            if (stage.pole && typeof stage.pole.get_dmg_info === 'function') return stage.pole.get_dmg_info(atkIdx, defIdx);
        } catch(e) {}
        return null;
    }

    function calcKilled(dmg, def) {
        if (!def || !def.maxhealth) return 0;
        let k = (dmg % def.maxhealth > (def.nowhealth || 0)) ? Math.floor(dmg / def.maxhealth) + 1 : Math.floor(dmg / def.maxhealth);
        return Math.min(k, def.nownumber || 0);
    }

    function hexDist(x1, y1, x2, y2) {
        return Math.max(Math.abs(x1 - x2), Math.ceil(Math.abs(y1 - y2) / 2));
    }

    // ---- Get pixel position of a hex cell ----
    function getCellPixel(x, y) {
        try {
            // Try multiple methods the game might use
            // Method 1: stage.pole has coordinate conversion
            if (stage.pole && typeof stage.pole.get_cell_pos === 'function') {
                const pos = stage.pole.get_cell_pos(x, y);
                return { px: pos.x, py: pos.y };
            }
            if (stage.pole && typeof stage.pole.cell2px === 'function') {
                const pos = stage.pole.cell2px(x, y);
                return { px: pos.x, py: pos.y };
            }
            // Method 2: Use the canvas element and game grid constants
            // HeroesWM uses a hex grid - try to calculate from defxn/defyn and cell size
            const canvas = document.querySelector('canvas');
            if (!canvas) return null;
            const rect = canvas.getBoundingClientRect();
            // Typical hex cell size in HeroesWM
            const cellW = 44; // approximate cell width
            const cellH = 38; // approximate cell height
            const offsetX = 30; // grid offset
            const offsetY = 30;
            const px = rect.left + offsetX + x * cellW + (y % 2) * (cellW / 2);
            const py = rect.top + offsetY + y * (cellH * 0.75);
            return { px, py };
        } catch(e) {
            return null;
        }
    }

    // ---- Draw markers on battlefield ----
    function clearMarkers() {
        document.querySelectorAll('.__bai_marker').forEach(e => e.remove());
    }

    function drawMarker(x, y, type) {
        const pos = getCellPixel(x, y);
        if (!pos) return;
        const m = document.createElement('div');
        m.className = '__bai_marker ' + type;
        m.style.left = (pos.px - 25) + 'px';
        m.style.top = (pos.py - 25) + 'px';
        m.style.width = '50px';
        m.style.height = '50px';
        document.body.appendChild(m);
    }

    // ---- Analysis ----
    function analyze() {
        try {
            if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) {
                return { status: 'wait', msg: 'ბრძოლა ჩატვირთვა...' };
            }

            const mySide = getMySide();
            const units = getUnits();
            if (units.length === 0) return { status: 'wait', msg: 'რაზმები არ მოიძებნა...' };

            const active = getActiveUnit();
            if (!active) return { status: 'wait', msg: 'ველოდებით სვლას...' };

            let attacker = units.find(u => u.idx === active.obj_index);
            if (!attacker) attacker = units.find(u => u.ref === active);
            if (!attacker) return { status: 'wait', msg: 'ვერ მოიძებნა აქტიური რაზმი' };

            if (attacker.owner !== mySide) {
                return { status: 'enemy', msg: 'მტრის სვლა: ' + attacker.name };
            }

            const enemies = units.filter(u => u.owner !== mySide);
            if (enemies.length === 0) return { status: 'done', msg: 'მტრები აღარ არიან!' };

            // Score each enemy
            const moves = [];
            for (const enemy of enemies) {
                const dist = hexDist(attacker.x, attacker.y, enemy.x, enemy.y);
                const reachable = attacker.shooter || dist <= Math.max(1, attacker.speed);

                let dmgMin = 0, dmgMax = 0, killMin = 0, killMax = 0, score = 0;
                let reason = '';
                let retal = null;

                if (reachable) {
                    const di = getDmg(attacker.idx, enemy.idx);
                    if (di) {
                        dmgMin = di.min || 0;
                        dmgMax = di.max || 0;
                        killMin = di.min_killed || calcKilled(dmgMin, enemy.ref);
                        killMax = di.max_killed || calcKilled(dmgMax, enemy.ref);
                    }
                    const avgDmg = (dmgMin + dmgMax) / 2;
                    const avgKill = (killMin + killMax) / 2;
                    score = avgDmg;

                    if (enemy.shooter) { score *= 1.6; reason = 'მშვილდოსანი! '; }
                    if (avgKill >= enemy.count) { score *= 1.4; score += 500; reason += 'განადგურდება! '; }
                    else if (!attacker.shooter) {
                        const ri = getDmg(enemy.idx, attacker.idx);
                        if (ri) {
                            const rK = calcKilled(ri.max, attacker.ref);
                            score -= rK * attacker.maxHp * 0.8;
                            retal = { max: ri.max };
                        }
                    }
                    score += enemy.init * avgKill * 3;
                } else {
                    score = -1;
                    reason = 'შორსაა (' + dist + ' უჯრა)';
                }

                moves.push({ enemy, dist, reachable, dmgMin, dmgMax, killMin, killMax, score, reason, retal });
            }

            moves.sort((a, b) => b.score - a.score);

            const best = moves.find(m => m.reachable && m.score > 0);
            clearMarkers();

            if (best) {
                // Draw green circle on target
                drawMarker(best.enemy.x, best.enemy.y, 'target');
                // Draw red circle on our unit
                drawMarker(attacker.x, attacker.y, 'attacker');

                let action = '⚔️ დაესხი: ' + best.enemy.name + ' ×' + best.enemy.count;
                action += '\n📍 უჯრა: [' + best.enemy.x + ', ' + best.enemy.y + ']';
                action += '\n💥 ზიანი: ' + best.dmgMin + '-' + best.dmgMax;
                action += '\n💀 მოკლული: ' + best.killMin + '-' + best.killMax;
                if (best.reason) action += '\n📝 ' + best.reason;
                if (best.retal) action += '\n⚠️ კონტრ-დარტყმა: -' + best.retal.max;

                return {
                    status: 'ok',
                    action,
                    attackerName: attacker.name,
                    attackerCount: attacker.count,
                    targetX: best.enemy.x,
                    targetY: best.enemy.y,
                    moves: moves.slice(0, 3),
                };
            } else {
                // Move closer to nearest enemy
                let closest = null;
                for (const m of moves) {
                    if (!closest || m.dist < closest.dist) closest = m;
                }
                if (closest) {
                    drawMarker(closest.enemy.x, closest.enemy.y, 'move');
                    drawMarker(attacker.x, attacker.y, 'attacker');
                    return {
                        status: 'ok',
                        action: '🏃 წადი ახლოს: ' + closest.enemy.name + '\n📍 უჯრა: [' + closest.enemy.x + ', ' + closest.enemy.y + ']\n📏 დაშორება: ' + closest.dist + ' უჯრა',
                        attackerName: attacker.name,
                        attackerCount: attacker.count,
                        moves: [],
                    };
                }
                return { status: 'wait', msg: 'ვერ ვიპოვე სამიზნე' };
            }
        } catch(e) {
            return { status: 'error', msg: e.message };
        }
    }

    // ---- Render panel ----
    function render(a) {
        let el = document.getElementById('__bai_panel');
        if (!el) {
            el = document.createElement('div');
            el.id = '__bai_panel';
            document.body.appendChild(el);
        }

        if (a.status !== 'ok') {
            el.innerHTML = '<div class="title">⚔️ Battle AI</div><div class="wait">' + a.msg + '</div>';
            return;
        }

        let html = '<div class="title">⚔️ Battle AI</div>';
        html += '<div style="color:#7af;font-size:14px">შენი რაზმი: ' + a.attackerName + ' ×' + a.attackerCount + '</div>';
        html += '<div class="action">' + a.action.replace(/\n/g, '<br>') + '</div>';

        if (a.moves && a.moves.length > 1) {
            html += '<div class="sub">სხვა ვარიანტები:</div>';
            for (let i = 1; i < a.moves.length; i++) {
                const m = a.moves[i];
                if (!m.reachable) continue;
                html += '<div class="sub">' + m.enemy.name + ' ×' + m.enemy.count +
                    ' | ზიანი: ' + m.dmgMin + '-' + m.dmgMax +
                    ' | მოკლული: ' + m.killMin + '-' + m.killMax + '</div>';
            }
        }

        el.innerHTML = html;
    }

    // ---- Main loop ----
    log('Battle AI v2 starting...');
    render({ status: 'wait', msg: 'ინიციალიზაცია...' });

    window.__bai2.timer = setInterval(function() {
        const a = analyze();
        render(a);
    }, 800);

    setTimeout(function() { render(analyze()); }, 200);

    console.log('%c⚔️ Battle AI v2 ჩართულია!', 'color:#0f0;font-size:18px;font-weight:bold');
    console.log('%c🟢 მწვანე = სამიზნე (ვის ვუტევ)', 'color:#0f0;font-size:14px');
    console.log('%c🔴 წითელი = შენი რაზმი', 'color:#f00;font-size:14px');
    console.log('%c🔵 ლურჯი = წადი ახლოს (როცა ვერ მიწვდები)', 'color:#0cf;font-size:14px');
    console.log('%c💡 Debug: battleAI.debug() | Stop: battleAI.stop()', 'color:#ff0;font-size:13px');

    window.battleAI = {
        debug: function() {
            console.log('=== DEBUG ===');
            console.log('stage:', typeof stage, stage ? 'OK' : 'NO');
            if (typeof stage !== 'undefined' && stage.pole) {
                console.log('obj_array:', stage.pole.obj_array);
                for (let k of stage.pole.obj_array) {
                    const c = stage.pole.obj[k];
                    if (!c) continue;
                    console.log('[' + k + ']', c.nametxt, 'x' + c.nownumber,
                        'owner:' + c.owner, 'hero:' + c.hero,
                        'ATK:' + c.attack, 'DEF:' + c.defence,
                        'HP:' + c.nowhealth + '/' + c.maxhealth,
                        'pos:[' + c.x + ',' + c.y + ']',
                        'shoot:' + c.shoot, 'speed:' + (c.speed||c.maxspeed),
                        'obj_index:' + c.obj_index);
                }
            }
            console.log('get_dmg_info:', typeof get_dmg_info);
            console.log('cur_unit:', typeof cur_unit !== 'undefined' ? cur_unit : 'N/A');
            console.log('my_side:', typeof my_side !== 'undefined' ? my_side : 'N/A');
            // Check canvas
            const cv = document.querySelector('canvas');
            console.log('canvas:', cv ? cv.getBoundingClientRect() : 'NOT FOUND');
            // Check for coordinate conversion functions
            if (typeof stage !== 'undefined' && stage.pole) {
                const methods = Object.getOwnPropertyNames(Object.getPrototypeOf(stage.pole)).filter(m => typeof stage.pole[m] === 'function');
                console.log('stage.pole methods:', methods.filter(m => m.includes('cell') || m.includes('pos') || m.includes('coord') || m.includes('px') || m.includes('pixel')));
            }
        },
        stop: function() {
            clearInterval(window.__bai2.timer);
            clearMarkers();
            const el = document.getElementById('__bai_panel');
            if (el) el.remove();
            console.log('Battle AI stopped.');
        },
    };

})();
