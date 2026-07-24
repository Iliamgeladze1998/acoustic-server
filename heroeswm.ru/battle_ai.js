// ==UserScript==
// @name         HeroesWM Battle AI Advisor
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Shows best move during battle - who to attack, expected damage/kills, threat analysis
// @match        https://www.heroeswm.ru/war*
// @match        https://my.lordswm.com/war*
// @match        https://www.lordswm.com/war*
// @match        https://mirror.heroeswm.ru/war*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // ============================================================
    // CONFIG
    // ============================================================
    const CONFIG = {
        showOverlay: true,       // Show floating panel with advice
        highlightBest: true,     // Highlight best target on battlefield
        autoRefresh: true,       // Auto-refresh when turn changes
        refreshInterval: 500,    // Check every 500ms for turn change
        minConfidence: 0.1,      // Minimum confidence to show advice
    };

    // ============================================================
    // STATE
    // ============================================================
    let lastTurnId = null;
    let overlayEl = null;
    let refreshTimer = null;

    // ============================================================
    // UTILITIES
    // ============================================================

    function log(msg) {
        console.log('[BattleAI] ' + msg);
    }

    function getMySide() {
        // Determine which side the player is on
        // The game stores player side info - we try multiple methods
        try {
            // Method 1: Check for player hero marker
            const objs = stage.pole.obj;
            const arr = stage.pole.obj_array;
            for (let k of arr) {
                const cre = objs[k];
                if (cre && cre.hero === 1) {
                    // Heroes have owner field - player is usually side 1
                    // But let's check more carefully
                }
            }
            // Method 2: Check URL or game state
            if (typeof my_side !== 'undefined') return my_side;
            if (typeof stage !== 'undefined' && stage.pole && stage.pole.my_side !== undefined) return stage.pole.my_side;
            // Default: try to detect from chat or other indicators
            // The player's hero is typically on side 1
            return 1;
        } catch(e) {
            return 1;
        }
    }

    function getActiveUnit() {
        // Get the unit whose turn it is
        try {
            if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) return null;

            const objs = stage.pole.obj;
            const arr = stage.pole.obj_array;

            // Method 1: Check for 'active' or 'current' marker
            for (let k of arr) {
                const cre = objs[k];
                if (!cre || cre.nownumber <= 0 || cre.hero === 1) continue;
                // Check various possible active indicators
                if (cre.active === 1 || cre.is_active === 1 || cre.turn === 1) return cre;
            }

            // Method 2: Check stage.pole.current or similar
            if (stage.pole.current_unit !== undefined) {
                return objs[stage.pole.current_unit];
            }
            if (stage.pole.active_unit !== undefined) {
                return objs[stage.pole.active_unit];
            }
            if (typeof cur_unit !== 'undefined' && cur_unit !== null) {
                return objs[cur_unit];
            }

            // Method 3: Look for the unit with highest initiative that hasn't acted
            // This is a fallback
            let best = null;
            let bestInit = -1;
            for (let k of arr) {
                const cre = objs[k];
                if (!cre || cre.nownumber <= 0 || cre.hero === 1) continue;
                if (cre.acted === 1 || cre.is_acted === 1) continue;
                const init = (cre.maxinit || 0) * (cre.initmodifier || 1);
                if (init > bestInit) {
                    bestInit = init;
                    best = cre;
                }
            }
            return best;
        } catch(e) {
            log('Error getting active unit: ' + e.message);
            return null;
        }
    }

    function getDamageInfo(attackerIdx, defenderIdx) {
        try {
            // Use the game's built-in damage calculation
            if (typeof get_dmg_info === 'function') {
                return get_dmg_info(attackerIdx, defenderIdx);
            }
            // Fallback: try via stage
            if (stage && stage.pole && typeof stage.pole.get_dmg_info === 'function') {
                return stage.pole.get_dmg_info(attackerIdx, defenderIdx);
            }
        } catch(e) {
            log('Error getting damage info: ' + e.message);
        }
        return null;
    }

    function calcKilled(dmg, defender) {
        if (!defender || !defender.maxhealth) return 0;
        let killed;
        if (dmg % defender.maxhealth > (defender.nowhealth || 0)) {
            killed = Math.floor(dmg / defender.maxhealth) + 1;
        } else {
            killed = Math.floor(dmg / defender.maxhealth);
        }
        return Math.min(killed, defender.nownumber || 0);
    }

    function getDistance(x1, y1, x2, y2) {
        // Hex grid distance calculation
        const dx = Math.abs(x1 - x2);
        const dy = Math.abs(y1 - y2);
        return Math.max(dx, dy, Math.floor((dx + dy) / 2));
        // Alternative: return Math.sqrt(dx*dx + dy*dy);
    }

    function canReach(attacker, defender) {
        // Check if attacker can reach defender this turn
        if (!attacker || !defender) return false;
        const dist = getDistance(attacker.x, attacker.y, defender.x, defender.y);
        // Most melee units can attack adjacent (distance 1)
        // Some have range or abilities
        const range = attacker.attack_range || attacker.shoot || 0;
        if (range > 0) return true; // Shooter
        // Check for speed/movement
        const speed = attacker.speed || attacker.maxspeed || 0;
        return dist <= Math.max(1, speed);
    }

    function isShooter(cre) {
        if (!cre) return false;
        if (cre.shoot === 1 || cre.shoot === true) return true;
        if (cre.data_string && cre.data_string.includes('shoot')) return true;
        return false;
    }

    // ============================================================
    // BATTLE ANALYSIS
    // ============================================================

    function getAllUnits() {
        const units = [];
        try {
            const objs = stage.pole.obj;
            const arr = stage.pole.obj_array;
            for (let k of arr) {
                const cre = objs[k];
                if (!cre || cre.nownumber <= 0) continue;
                if (cre.hero === 1) continue; // Skip heroes
                units.push({
                    ref: cre,
                    index: k,
                    name: cre.nametxt || 'Unknown',
                    count: cre.nownumber || 0,
                    hp: cre.nowhealth || cre.maxhealth || 0,
                    maxHp: cre.maxhealth || 1,
                    totalHp: (cre.nownumber - 1) * (cre.maxhealth || 1) + (cre.nowhealth || cre.maxhealth || 1),
                    attack: cre.attack || 0,
                    defence: cre.defence || 0,
                    initiative: (cre.maxinit || 0) * (cre.initmodifier || 1),
                    x: cre.x,
                    y: cre.y,
                    owner: cre.owner,
                    isShooter: isShooter(cre),
                    data_string: cre.data_string || '',
                });
            }
        } catch(e) {
            log('Error getting units: ' + e.message);
        }
        return units;
    }

    function analyzeMove(attacker, defender, allUnits, mySide) {
        const result = {
            target: defender,
            targetName: defender.name,
            damage: { min: 0, max: 0 },
            kills: { min: 0, max: 0 },
            score: 0,
            reason: '',
            canReach: false,
            isShooterAttack: attacker.isShooter,
        };

        // Check reachability
        const dist = getDistance(attacker.x, attacker.y, defender.x, defender.y);
        result.distance = dist;
        result.canReach = attacker.isShooter || canReach(attacker.ref, defender.ref);

        if (!result.canReach) {
            // Can we move closer?
            result.score = -1;
            result.reason = 'Out of range (' + dist + ' cells)';
            return result;
        }

        // Get damage info from game engine
        const dmgInfo = getDamageInfo(attacker.index, defender.index);
        if (dmgInfo) {
            result.damage.min = dmgInfo.min || 0;
            result.damage.max = dmgInfo.max || 0;
            result.kills.min = dmgInfo.min_killed || calcKilled(result.damage.min, defender.ref);
            result.kills.max = dmgInfo.max_killed || calcKilled(result.damage.max, defender.ref);
        } else {
            // Fallback calculation
            const baseDmg = (attacker.attack + 10) * attacker.count * 0.5;
            result.damage.min = Math.floor(baseDmg * 0.8);
            result.damage.max = Math.floor(baseDmg * 1.2);
            result.kills.min = calcKilled(result.damage.min, defender.ref);
            result.kills.max = calcKilled(result.damage.max, defender.ref);
        }

        // Calculate score
        const avgDmg = (result.damage.min + result.damage.max) / 2;
        const avgKills = (result.kills.min + result.kills.max) / 2;

        // Threat level: how dangerous is this enemy?
        const enemyThreat = defender.attack * defender.count * defender.initiative;
        const threatReduction = avgKills / defender.count; // Fraction of stack eliminated

        // Priority scoring:
        // 1. Killing shooters (high threat, can't be reached easily by melee)
        // 2. Eliminating high-damage stacks
        // 3. Maximizing damage efficiency
        let score = avgDmg;

        // Bonus for killing shooters
        if (defender.isShooter) {
            score *= 1.5;
            result.reason = 'Shooter priority! ';
        }

        // Bonus for high threat elimination
        score += threatReduction * enemyThreat * 0.3;

        // Bonus for completely destroying a stack
        if (avgKills >= defender.count) {
            score *= 1.3;
            result.reason += 'Stack destroyed! ';
        }

        // Penalty for attacking low-value targets
        if (defender.count <= 1 && !defender.isShooter) {
            score *= 0.7;
            result.reason += 'Low value target. ';
        }

        // Bonus for retaliation damage avoidance
        // If we kill the stack, no retaliation
        if (avgKills >= defender.count) {
            score += 500; // Big bonus for no retaliation
            result.reason += 'No retaliation! ';
        } else if (!attacker.isShooter) {
            // Melee attackers face retaliation
            const retalDmg = getDamageInfo(defender.index, attacker.index);
            if (retalDmg) {
                const retalKills = calcKilled(retalDmg.max, attacker.ref);
                score -= retalKills * attacker.maxHp * 0.5;
                result.retaliation = { min: retalDmg.min, max: retalDmg.max, kills: retalKills };
            }
        }

        // Initiative bonus: killing high-initiative units prevents them from acting
        score += defender.initiative * avgKills * 2;

        result.score = Math.round(score);

        if (!result.reason) {
            result.reason = avgKills > 0 ? 'Good damage' : 'Low damage';
        }

        return result;
    }

    function analyzeBattle() {
        try {
            if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) {
                return null;
            }

            const mySide = getMySide();
            const allUnits = getAllUnits();
            if (allUnits.length === 0) return null;

            const activeUnit = getActiveUnit();
            if (!activeUnit) {
                return { status: 'no_active_unit', message: 'Waiting for your turn...' };
            }

            // Find the active unit in our list
            const attacker = allUnits.find(u => u.index === activeUnit.obj_index) ||
                             allUnits.find(u => u.ref === activeUnit);

            if (!attacker) {
                return { status: 'error', message: 'Could not identify active unit' };
            }

            // Check if it's our unit
            if (attacker.owner !== mySide) {
                return { status: 'enemy_turn', message: 'Enemy turn: ' + attacker.name };
            }

            // Find all enemy units
            const enemies = allUnits.filter(u => u.owner !== mySide);
            if (enemies.length === 0) {
                return { status: 'no_enemies', message: 'No enemies found' };
            }

            // Analyze each possible move
            const moves = [];
            for (const enemy of enemies) {
                const move = analyzeMove(attacker, enemy, allUnits, mySide);
                moves.push(move);
            }

            // Sort by score
            moves.sort((a, b) => b.score - a.score);

            // Also consider defending/waiting
            const bestAttack = moves[0];
            const defendScore = -100; // Default: attacking is usually better

            // Generate advice
            let advice = '';
            let bestMove = null;

            if (bestAttack && bestAttack.score > 0 && bestAttack.canReach) {
                bestMove = bestAttack;
                advice = '⚔️ ATTACK: ' + bestAttack.targetName +
                    ' | DMG: ' + bestAttack.damage.min + '-' + bestAttack.damage.max +
                    ' | KILL: ' + bestAttack.kills.min + '-' + bestAttack.kills.max +
                    ' | ' + bestAttack.reason;

                if (bestAttack.retaliation) {
                    advice += ' | ⚠️ Retaliation: ' + bestAttack.retaliation.min + '-' + bestAttack.retaliation.max;
                }
            } else {
                // No good attack - consider moving closer or defending
                const closestEnemy = enemies.reduce((closest, e) => {
                    const d = getDistance(attacker.x, attacker.y, e.x, e.y);
                    if (!closest || d < closest.dist) {
                        return { enemy: e, dist: d };
                    }
                    return closest;
                }, null);

                if (closestEnemy && closestEnemy.dist > 1) {
                    advice = '🏃 MOVE closer to ' + closestEnemy.enemy.name + ' (' + closestEnemy.dist + ' cells away)';
                    bestMove = { type: 'move', target: closestEnemy.enemy, distance: closestEnemy.dist };
                } else {
                    advice = '🛡️ DEFEND (no good attack options)';
                    bestMove = { type: 'defend' };
                }
            }

            // Build full analysis
            const myUnits = allUnits.filter(u => u.owner === mySide);
            const enemyUnits = enemies;

            // Threat assessment
            const myThreat = myUnits.reduce((sum, u) => sum + u.attack * u.count * u.initiative, 0);
            const enemyThreat = enemyUnits.reduce((sum, u) => sum + u.attack * u.count * u.initiative, 0);

            return {
                status: 'ok',
                attacker: { name: attacker.name, count: attacker.count, hp: attacker.hp },
                advice: advice,
                bestMove: bestMove,
                allMoves: moves.slice(0, 5), // Top 5 options
                battlefield: {
                    myUnits: myUnits.length,
                    enemyUnits: enemyUnits.length,
                    myThreat: Math.round(myThreat),
                    enemyThreat: Math.round(enemyThreat),
                    advantage: myThreat > enemyThreat ? 'WINNING' : enemyThreat > myThreat * 1.3 ? 'LOSING' : 'EVEN',
                },
            };
        } catch(e) {
            log('Error analyzing battle: ' + e.message + ' (' + e.stack + ')');
            return { status: 'error', message: e.message };
        }
    }

    // ============================================================
    // UI / OVERLAY
    // ============================================================

    function createOverlay() {
        if (overlayEl) return;

        const style = document.createElement('style');
        style.textContent = `
            #battleAIOverlay {
                position: fixed;
                top: 10px;
                right: 10px;
                width: 340px;
                background: rgba(0, 0, 20, 0.92);
                color: #e0e0e0;
                font-family: 'Segoe UI', Arial, sans-serif;
                font-size: 13px;
                border: 2px solid #4a7;
                border-radius: 8px;
                padding: 12px;
                z-index: 99999;
                box-shadow: 0 4px 20px rgba(0,255,100,0.3);
                pointer-events: none;
                max-height: 80vh;
                overflow-y: auto;
            }
            #battleAIOverlay .ai-header {
                font-size: 15px;
                font-weight: bold;
                color: #4a7;
                border-bottom: 1px solid #4a7;
                padding-bottom: 6px;
                margin-bottom: 8px;
            }
            #battleAIOverlay .ai-advice {
                font-size: 14px;
                color: #ffcc44;
                padding: 8px;
                background: rgba(255,200,50,0.1);
                border-radius: 4px;
                margin-bottom: 8px;
                font-weight: bold;
            }
            #battleAIOverlay .ai-move {
                padding: 4px 8px;
                margin: 2px 0;
                border-radius: 3px;
                font-size: 12px;
            }
            #battleAIOverlay .ai-move.best {
                background: rgba(0,255,100,0.15);
                border-left: 3px solid #0f0;
            }
            #battleAIOverlay .ai-move.other {
                opacity: 0.6;
            }
            #battleAIOverlay .ai-stats {
                font-size: 11px;
                color: #888;
                margin-top: 8px;
                padding-top: 6px;
                border-top: 1px solid #333;
            }
            #battleAIOverlay .ai-status {
                font-size: 12px;
                color: #888;
                text-align: center;
                padding: 20px;
            }
            #battleAIOverlay .ai-threat {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 3px;
                font-weight: bold;
                font-size: 11px;
            }
            #battleAIOverlay .ai-threat.winning { background: rgba(0,200,0,0.3); color: #0f0; }
            #battleAIOverlay .ai-threat.even { background: rgba(200,200,0,0.3); color: #cc0; }
            #battleAIOverlay .ai-threat.losing { background: rgba(200,0,0,0.3); color: #f00; }
        `;
        document.head.appendChild(style);

        overlayEl = document.createElement('div');
        overlayEl.id = 'battleAIOverlay';
        overlayEl.innerHTML = '<div class="ai-header">⚔️ Battle AI Advisor</div><div class="ai-status">Initializing...</div>';
        document.body.appendChild(overlayEl);
    }

    function updateOverlay(analysis) {
        if (!overlayEl) return;

        if (!analysis) {
            overlayEl.innerHTML = '<div class="ai-header">⚔️ Battle AI Advisor</div><div class="ai-status">No battle data</div>';
            return;
        }

        if (analysis.status !== 'ok') {
            overlayEl.innerHTML = '<div class="ai-header">⚔️ Battle AI Advisor</div><div class="ai-status">' + (analysis.message || analysis.status) + '</div>';
            return;
        }

        let html = '<div class="ai-header">⚔️ Battle AI Advisor</div>';

        // Active unit
        html += '<div style="margin-bottom:6px">Active: <b style="color:#7af">' + analysis.attacker.name + '</b> ×' + analysis.attacker.count + ' (HP:' + analysis.attacker.hp + ')</div>';

        // Main advice
        html += '<div class="ai-advice">' + analysis.advice + '</div>';

        // Top moves
        if (analysis.allMoves && analysis.allMoves.length > 0) {
            html += '<div style="font-size:11px;color:#888;margin-bottom:4px">Top targets:</div>';
            analysis.allMoves.forEach((move, i) => {
                if (!move.canReach && move.score < 0) return;
                const cls = i === 0 ? 'best' : 'other';
                const killStr = move.kills.max > 0 ? ' | Kill: ' + move.kills.min + '-' + move.kills.max : '';
                const reachStr = move.canReach ? '' : ' | 🚫 Out of range';
                html += '<div class="ai-move ' + cls + '">';
                html += '<b>' + move.targetName + '</b> | DMG: ' + move.damage.min + '-' + move.damage.max + killStr + reachStr;
                if (move.retaliation) {
                    html += ' | ⚠️ Retal: ' + move.retaliation.max;
                }
                html += ' | Score: ' + move.score;
                html += '</div>';
            });
        }

        // Battlefield stats
        const bf = analysis.battlefield;
        const threatClass = bf.advantage === 'WINNING' ? 'winning' : bf.advantage === 'LOSING' ? 'losing' : 'even';
        html += '<div class="ai-stats">';
        html += 'Units: ' + bf.myUnits + ' vs ' + bf.enemyUnits + ' | ';
        html += 'Threat: ' + bf.myThreat + ' vs ' + bf.enemyThreat + ' ';
        html += '<span class="ai-threat ' + threatClass + '">' + bf.advantage + '</span>';
        html += '</div>';

        overlayEl.innerHTML = html;
    }

    // ============================================================
    // MAIN LOOP
    // ============================================================

    function checkAndAdvise() {
        try {
            const analysis = analyzeBattle();
            if (analysis) {
                updateOverlay(analysis);

                // Log to console for debugging
                if (analysis.status === 'ok') {
                    log(analysis.advice);
                }
            }
        } catch(e) {
            log('Error in checkAndAdvise: ' + e.message);
        }
    }

    function start() {
        log('Starting Battle AI Advisor...');

        // Wait for the game to load
        function waitForGame() {
            if (typeof stage !== 'undefined' && stage.pole && stage.pole.obj) {
                log('Game detected, starting advisor...');
                if (CONFIG.showOverlay) {
                    createOverlay();
                }
                if (CONFIG.autoRefresh) {
                    refreshTimer = setInterval(checkAndAdvise, CONFIG.refreshInterval);
                }
                // Also do an immediate check
                checkAndAdvise();
            } else {
                setTimeout(waitForGame, 1000);
            }
        }

        waitForGame();
    }

    // Start when page is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    // Expose for manual use
    window.battleAI = {
        analyze: analyzeBattle,
        refresh: checkAndAdvise,
        getUnits: getAllUnits,
        getActive: getActiveUnit,
    };

})();
