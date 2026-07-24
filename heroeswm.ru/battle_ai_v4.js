// =====================================================
// HeroesWM Battle AI v4 - NATIVE HEX HIGHLIGHTING
// =====================================================
// F12 -> Console -> Paste -> Enter
// Uses game's own shado[] hex tile system for highlighting
// Grid coords (x,y) always correct even when units move
// =====================================================

(function() {
    if (window.__bai3) {
        clearInterval(window.__bai3.timer);
        clearHex();
        const old = document.getElementById('__bai3_panel');
        if (old) old.remove();
    }
    window.__bai3 = { timer: null, lastHex: [] };

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
    `;
    document.head.appendChild(s);

    // ---- Native hex highlighting using game's shado[] array ----
    function clearHex() {
        try {
            for (const h of window.__bai3.lastHex) {
                const tile = shado[h.x + h.y * defxn];
                if (tile) {
                    tile.fill(null);
                    set_visible(tile, 0);
                }
            }
        } catch(e) {}
        window.__bai3.lastHex = [];
    }

    function highlightHex(x, y, color) {
        try {
            const tile = shado[x + y * defxn];
            if (!tile) return;
            tile.fill(color);
            set_visible(tile, 1);
            window.__bai3.lastHex.push({ x, y });
        } catch(e) {}
    }

    // ---- Read units from game ----
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
                    owner: c.owner,
                    side: c.side,
                    shooter: c.shooter === 1,
                    flyer: c.flyer === 1,
                    hero: c.hero === 1,
                    range: c.range || 0,
                    mindam: c.mindam || 0,
                    maxdam: c.maxdam || 0,
                    ret: c.ret,
                    big: c.big === 1,
                    morale: c.morale || 0,
                    luck: c.luck || 0,
                    ref: c,
                });
            }
        } catch(e) { console.log('[BAI] getUnits error: ' + e.message); }
        return units;
    }

    // ---- Find active unit (highest nowinit among living) ----
    function getActiveUnit(units) {
        let best = null;
        let bestInit = -9999;
        for (let u of units) {
            if (u.hero && u.nowinit < 0) continue;
            if (u.nowinit > bestInit) {
                bestInit = u.nowinit;
                best = u;
            }
        }
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
        const minDmg = attacker.count * attacker.mindam * multiplier;
        const maxDmg = attacker.count * attacker.maxdam * multiplier;
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
        if (attacker.flyer) return true;
        const d = dist(attacker, defender);
        return d <= Math.max(1, attacker.speed);
    }

    // ---- Main analysis ----
    function analyze() {
        try {
            if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) {
                return { status: 'wait', msg: 'ბრძოლა ჩატვირთვა...' };
            }
            if (typeof shado === 'undefined') {
                return { status: 'wait', msg: 'shado არ არსებობს...' };
            }

            const units = getUnits();
            if (units.length === 0) return { status: 'wait', msg: 'რაზმები არ არიან...' };

            const active = getActiveUnit(units);
            if (!active) return { status: 'wait', msg: 'ველოდებით სვლას...' };

            const isMyTurn = active.owner === 1 || active.side === 1;
            if (!isMyTurn) {
                clearHex();
                return { status: 'enemy', msg: 'მტრის სვლა: ' + active.name + ' ×' + active.count };
            }

            // Exclude heroes from targets
            const enemies = units.filter(u => (u.owner === 2 || u.side === -1) && !u.hero);
            if (enemies.length === 0) {
                clearHex();
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

                if (enemy.shooter) { score *= 1.6; reason = '🏹 მშვილდოსანი! '; }

                if (dmg.avgKills >= enemy.count) {
                    score *= 1.4; score += 500;
                    reason += '💀 განადგურდება! ';
                } else if (!active.shooter && enemy.ret) {
                    const retal = calcDamage(enemy, active);
                    score -= retal.avgKills * active.maxHp * 0.8;
                }

                score += enemy.init * dmg.avgKills * 3;

                if (!reachable && !active.shooter) {
                    score = -1;
                    reason = '🚫 შორსაა (' + d + ' უჯრა)';
                }

                moves.push({ enemy, d, reachable, dmg, score, reason });
            }

            moves.sort((a, b) => b.score - a.score);

            const best = moves.find(m => m.reachable && m.score > 0);
            
            // Clear previous hex highlights
            clearHex();

            if (best) {
                // Highlight using game's native hex system
                highlightHex(best.enemy.x, best.enemy.y, '#00ff00');
                highlightHex(active.x, active.y, '#ff0000');

                let action = '⚔️ დაესხი: ' + best.enemy.name + ' ×' + best.enemy.count;
                action += '<br>📍 უჯრა: [' + best.enemy.x + ', ' + best.enemy.y + ']';
                action += '<br>💥 ზიანი: ' + best.dmg.min + '-' + best.dmg.max;
                action += '<br>💀 მოკლული: ' + best.dmg.minKills + '-' + best.dmg.maxKills;
                if (best.reason) action += '<br>📝 ' + best.reason;

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
                    highlightHex(closest.enemy.x, closest.enemy.y, '#00ccff');
                    highlightHex(active.x, active.y, '#ff0000');
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
    console.log('%c⚔️ Battle AI v4 ჩართულია!', 'color:#0f0;font-size:18px;font-weight:bold');
    console.log('%c🟢 მწვანე ჰექსი = სამიზნე | 🔴 წითელი ჰექსი = შენი რაზმი | 🔵 ლურჯი = წადი ახლოს', 'color:#ff0;font-size:14px');
    console.log('%c💡 Stop: battleAI.stop()', 'color:#f88;font-size:13px');

    render({ status: 'wait', msg: 'ინიციალიზაცია...' });

    window.__bai3.timer = setInterval(function() {
        render(analyze());
    }, 800);

    setTimeout(function() { render(analyze()); }, 200);

    window.battleAI = {
        stop: function() {
            clearInterval(window.__bai3.timer);
            clearHex();
            const el = document.getElementById('__bai3_panel');
            if (el) el.remove();
            console.log('Battle AI stopped.');
        },
        units: function() {
            const u = getUnits();
            u.forEach(x => console.log(x.name, 'x' + x.count, 'owner:' + x.owner, 'ATK:' + x.atk, 'DEF:' + x.def, 'HP:' + x.hp + '/' + x.maxHp, 'pos:[' + x.x + ',' + x.y + ']', 'init:' + x.nowinit));
            return u;
        },
    };

})();
