// =====================================================
// HeroesWM Battle AI v3 - WORKING VERSION
// =====================================================
// F12 -> Console -> Paste -> Enter
// GREEN circle = who to attack | RED circle = your unit
// Uses scr_x/scr_y for pixel-perfect markers
// Calculates damage with game formula
// =====================================================

(function() {
    if (window.__bai3) {
        clearInterval(window.__bai3.timer);
        document.querySelectorAll('.__bai3_m').forEach(e => e.remove());
        const old = document.getElementById('__bai3_panel');
        if (old) old.remove();
    }
    window.__bai3 = { timer: null };

    const s = document.createElement('style');
    s.textContent = `
    #__bai3_panel {
        position: fixed; top: 10px; right: 10px; width: 340px;
        background: rgba(0,0,0,0.92); color: #fff;
        font-family: Arial,sans-serif; font-size: 15px;
        border: 2px solid #0f0; border-radius: 10px; padding: 15px;
        z-index: 999999; box-shadow: 0 0 20px rgba(0,255,0,0.4);
        pointer-events: none;
    }
    #__bai3_panel .t { color: #0f0; font-size: 17px; font-weight: bold; margin-bottom: 8px; }
    #__bai3_panel .act { color: #ff0; font-size: 18px; font-weight: bold; margin: 8px 0; line-height: 1.5; }
    #__bai3_panel .sub { color: #aaa; font-size: 12px; margin-top: 6px; }
    #__bai3_panel .wt { color: #888; text-align: center; padding: 15px; }
    .__bai3_m {
        position: fixed; z-index: 999999; pointer-events: none;
        border-radius: 50%; border: 4px solid;
        animation: __bai3_p 0.8s infinite;
    }
    .__bai3_m.tgt { border-color: #00ff00; box-shadow: 0 0 20px #0f0; width: 60px; height: 60px; }
    .__bai3_m.atk { border-color: #ff3333; box-shadow: 0 0 20px #f00; width: 60px; height: 60px; }
    .__bai3_m.mov { border-color: #00ccff; box-shadow: 0 0 20px #0cf; border-style: dashed; width: 60px; height: 60px; }
    @keyframes __bai3_p { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:0.4;transform:scale(1.15)} }
    `;
    document.head.appendChild(s);

    // ---- Read units from game ----
    function getUnits() {
        const units = [];
        try {
            const arr = stage.pole.obj_array;
            for (let k of arr) {
                const c = stage.pole.obj[k];
                if (!c) continue;
                if (c.dead === 1 || c.nownumber <= 0) continue;
                if (!c.it_unit) continue; // skip rocks/decorations
                units.push({
                    idx: k,
                    name: c.nametxt || '???',
                    count: c.nownumber || 0,
                    hp: c.nowhealth || c.maxhealth || 0,
                    maxHp: c.maxhealth || 1,
                    totalHp: (c.nownumber - 1) * (c.maxhealth || 1) + (c.nowhealth || c.maxhealth || 1),
                    atk: c.attack || 0,
                    def: c.defence || 0,
                    speed: c.speed || 0,
                    init: c.maxinit || 0,
                    nowinit: c.nowinit || 0,
                    x: c.x, y: c.y,
                    scrX: c.scr_x || c._x || 0,
                    scrY: c.scr_y || c._y || 0,
                    owner: c.owner, // 1=player, 2=enemy, 0=neutral
                    side: c.side,   // 1=player, -1=enemy
                    shooter: c.shooter === 1,
                    flyer: c.flyer === 1,
                    hero: c.hero === 1,
                    range: c.range || 0,
                    mindam: c.mindam || 0,
                    maxdam: c.maxdam || 0,
                    ret: c.ret,     // can retaliate
                    big: c.big === 1,
                    morale: c.morale || 0,
                    luck: c.luck || 0,
                    ref: c,
                });
            }
        } catch(e) { console.log('[BAI] getUnits error: ' + e.message); }
        return units;
    }

    // ---- Find active unit (highest nowinit among living, skip hero if has -1) ----
    function getActiveUnit(units) {
        let best = null;
        let bestInit = -9999;
        for (let u of units) {
            // Hero with nowinit -1 means it's waiting/not active
            if (u.hero && u.nowinit < 0) continue;
            if (u.nowinit > bestInit) {
                bestInit = u.nowinit;
                best = u;
            }
        }
        // If no non-hero unit found, try including heroes
        if (!best) {
            for (let u of units) {
                if (u.nowinit > bestInit) {
                    bestInit = u.nowinit;
                    best = u;
                }
            }
        }
        return best;
    }

    // ---- Damage calculation (game formula) ----
    function calcDamage(attacker, defender) {
        const avgDmg = (attacker.mindam + attacker.maxdam) / 2;
        let multiplier;
        if (attacker.atk > defender.def) {
            multiplier = 1 + 0.05 * (attacker.atk - defender.def);
        } else if (attacker.atk < defender.def) {
            multiplier = 1 / (1 + 0.05 * (defender.def - attacker.atk));
        } else {
            multiplier = 1;
        }
        const totalDmg = attacker.count * avgDmg * multiplier;

        // Min and max
        const minDmg = attacker.count * attacker.mindam * multiplier;
        const maxDmg = attacker.count * attacker.maxdam * multiplier;

        // Kills
        const minKills = Math.floor(minDmg / defender.maxHp);
        const maxKills = Math.floor(maxDmg / defender.maxHp);
        const avgKills = Math.floor(totalDmg / defender.maxHp);

        return {
            min: Math.round(minDmg),
            max: Math.round(maxDmg),
            avg: Math.round(totalDmg),
            minKills: Math.min(minKills, defender.count),
            maxKills: Math.min(maxKills, defender.count),
            avgKills: Math.min(avgKills, defender.count),
        };
    }

    // ---- Hex distance ----
    function dist(a, b) {
        return Math.max(Math.abs(a.x - b.x), Math.ceil(Math.abs(a.y - b.y) / 2));
    }

    // ---- Can reach? ----
    function canReach(attacker, defender) {
        if (attacker.shooter) return true;
        if (attacker.flyer) return true; // flyers can reach anywhere
        const d = dist(attacker, defender);
        return d <= Math.max(1, attacker.speed);
    }

    // ---- Draw markers ----
    function clearMarkers() {
        document.querySelectorAll('.__bai3_m').forEach(e => e.remove());
    }

    function drawMarker(scrX, scrY, type) {
        const pole = document.getElementById('pole');
        const off = pole ? pole.getBoundingClientRect() : { left: 0, top: 0 };
        const m = document.createElement('div');
        m.className = '__bai3_m ' + type;
        m.style.position = 'fixed';
        m.style.left = (off.left + scrX - 30) + 'px';
        m.style.top = (off.top + scrY - 30) + 'px';
        document.body.appendChild(m);
    }

    // ---- Main analysis ----
    function analyze() {
        try {
            if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) {
                return { status: 'wait', msg: 'ბრძოლა ჩატვირთვა...' };
            }

            const units = getUnits();
            if (units.length === 0) return { status: 'wait', msg: 'რაზმები არ არიან...' };

            const active = getActiveUnit(units);
            if (!active) return { status: 'wait', msg: 'ველოდებით სვლას...' };

            // Check if it's our turn (owner=1 or side=1)
            const isMyTurn = active.owner === 1 || active.side === 1;
            if (!isMyTurn) {
                return { status: 'enemy', msg: 'მტრის სვლა: ' + active.name + ' ×' + active.count };
            }

            // Find enemies (owner=2 or side=-1), EXCLUDE heroes (can't attack them directly)
            const enemies = units.filter(u => (u.owner === 2 || u.side === -1) && !u.hero);
            if (enemies.length === 0) {
                if (active.hero) {
                    return { status: 'ok', activeName: active.name, activeCount: 1, action: '🧙 გმირის სვლა - გამოიყენე ჯადო!', moves: [] };
                }
                return { status: 'done', msg: 'მტრები აღარ არიან!' };
            }

            // Score each enemy
            const moves = [];
            for (const enemy of enemies) {
                const d = dist(active, enemy);
                const reachable = canReach(active, enemy);
                const dmg = calcDamage(active, enemy);

                let score = dmg.avg;
                let reason = '';

                // Priority: shooters first
                if (enemy.shooter) { score *= 1.6; reason = '🏹 მშვილდოსანი! '; }

                // Destroying stack = no retaliation
                if (dmg.avgKills >= enemy.count) {
                    score *= 1.4; score += 500;
                    reason += '💀 განადგურდება! ';
                } else if (!active.shooter && enemy.ret) {
                    // Retaliation damage
                    const retal = calcDamage(enemy, active);
                    score -= retal.avgKills * active.maxHp * 0.8;
                }

                // Initiative: killing fast units is valuable
                score += enemy.init * dmg.avgKills * 3;

                // Distance penalty for non-shooters
                if (!reachable && !active.shooter) {
                    score = -1;
                    reason = '🚫 შორსაა (' + d + ' უჯრა)';
                }

                moves.push({ enemy, d, reachable, dmg, score, reason });
            }

            moves.sort((a, b) => b.score - a.score);

            const best = moves.find(m => m.reachable && m.score > 0);
            clearMarkers();

            if (best) {
                // Draw markers using screen coordinates
                drawMarker(best.enemy.scrX, best.enemy.scrY, 'tgt');
                drawMarker(active.scrX, active.scrY, 'atk');

                let action = '⚔️ დაესხი: ' + best.enemy.name + ' ×' + best.enemy.count;
                action += '<br>📍 უჯრა: [' + best.enemy.x + ', ' + best.enemy.y + ']';
                action += '<br>💥 ზიანი: ' + best.dmg.min + '-' + best.dmg.max;
                action += '<br>💀 მოკლული: ' + best.dmg.minKills + '-' + best.dmg.maxKills;
                if (best.reason) action += '<br>📝 ' + best.reason;

                // Retaliation warning
                if (!active.shooter && best.enemy.ret && best.dmg.avgKills < best.enemy.count) {
                    const retal = calcDamage(best.enemy, active);
                    action += '<br>⚠️ კონტრ-დარტყმა: ' + retal.min + '-' + retal.max + ' (მოკლული: ' + retal.avgKills + ')';
                }

                return {
                    status: 'ok',
                    activeName: active.name,
                    activeCount: active.count,
                    action,
                    moves: moves.slice(0, 4),
                };
            } else {
                // Move closer
                let closest = null;
                for (const m of moves) {
                    if (!closest || m.d < closest.d) closest = m;
                }
                if (closest) {
                    drawMarker(closest.enemy.scrX, closest.enemy.scrY, 'mov');
                    drawMarker(active.scrX, active.scrY, 'atk');
                    return {
                        status: 'ok',
                        activeName: active.name,
                        activeCount: active.count,
                        action: '🏃 წადი ახლოს: ' + closest.enemy.name + '<br>📍 უჯრა: [' + closest.enemy.x + ', ' + closest.enemy.y + ']<br>📏 დაშორება: ' + closest.d + ' უჯრა',
                        moves: [],
                    };
                }
            }

            return { status: 'wait', msg: 'ვერ ვიპოვე სამიზნე' };
        } catch(e) {
            return { status: 'error', msg: e.message };
        }
    }

    // ---- Render ----
    function render(a) {
        let el = document.getElementById('__bai3_panel');
        if (!el) {
            el = document.createElement('div');
            el.id = '__bai3_panel';
            document.body.appendChild(el);
        }

        if (a.status !== 'ok') {
            el.innerHTML = '<div class="t">⚔️ Battle AI</div><div class="wt">' + a.msg + '</div>';
            return;
        }

        let html = '<div class="t">⚔️ Battle AI</div>';
        html += '<div style="color:#7af;font-size:13px">შენი რაზმი: ' + a.activeName + ' ×' + a.activeCount + '</div>';
        html += '<div class="act">' + a.action + '</div>';

        if (a.moves && a.moves.length > 1) {
            html += '<div class="sub">სხვა ვარიანტები:</div>';
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
    console.log('%c⚔️ Battle AI v3 ჩართულია!', 'color:#0f0;font-size:18px;font-weight:bold');
    console.log('%c🟢 მწვანე = სამიზნე | 🔴 წითელი = შენი რაზმი | 🔵 წადი ახლოს', 'color:#ff0;font-size:14px');
    console.log('%c💡 Stop: battleAI.stop()', 'color:#f88;font-size:13px');

    render({ status: 'wait', msg: 'ინიციალიზაცია...' });

    window.__bai3.timer = setInterval(function() {
        render(analyze());
    }, 800);

    setTimeout(function() { render(analyze()); }, 200);

    window.battleAI = {
        stop: function() {
            clearInterval(window.__bai3.timer);
            document.querySelectorAll('.__bai3_m').forEach(e => e.remove());
            const el = document.getElementById('__bai3_panel');
            if (el) el.remove();
            console.log('Battle AI stopped.');
        },
        units: function() {
            const u = getUnits();
            u.forEach(x => console.log(x.name, 'x' + x.count, 'owner:' + x.owner, 'ATK:' + x.atk, 'DEF:' + x.def, 'HP:' + x.hp + '/' + x.maxHp, 'pos:[' + x.x + ',' + x.y + ']', 'scr:[' + x.scrX + ',' + x.scrY + ']', 'init:' + x.nowinit));
            return u;
        },
    };

})();
