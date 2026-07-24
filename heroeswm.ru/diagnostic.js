// HeroesWM Battle Diagnostic - paste in console during battle
(function() {
    console.log('%c=== HeroesWM Battle Diagnostic ===', 'color:#0ff;font-size:16px;font-weight:bold');

    // Check stage
    console.log('1. stage:', typeof stage !== 'undefined' ? 'EXISTS' : 'NOT FOUND');
    if (typeof stage !== 'undefined') {
        console.log('   stage.pole:', stage.pole ? 'EXISTS' : 'NO');
        if (stage.pole) {
            console.log('   stage.pole.obj:', stage.pole.obj ? 'EXISTS' : 'NO');
            console.log('   stage.pole.obj_array:', stage.pole.obj_array);
        }
    }

    // Check other common globals
    const globals = ['stage','pole','units','creatures','army','battle','war','combat',
        'cur_unit','my_side','heroes','magic','defxn','defyn','mapobj',
        'get_dmg_info','battle_is_it_perk','animspeed','timer_interval',
        'game','field','board','grid','hex','hexes','cells',
        'WebGL','canvas','ctx','gl','renderer','scene','phaser','PIXI',
        'battlefield','combatField','warField','pole_obj','cre',
        'obj','obj_array','creatures_arr','army_arr','stacks'];

    console.log('2. Checking globals:');
    for (let g of globals) {
        try {
            if (typeof window[g] !== 'undefined') {
                let val = window[g];
                let type = typeof val;
                let info = '';
                if (type === 'object' && val) {
                    info = Object.keys(val).slice(0, 5).join(',');
                    if (val.constructor) info += ' (' + val.constructor.name + ')';
                }
                console.log('   ✓ ' + g + ': ' + type + ' [' + info + ']');
            }
        } catch(e) {}
    }

    // Check canvas elements
    console.log('3. Canvas elements:');
    const canvases = document.querySelectorAll('canvas');
    canvases.forEach((c, i) => {
        const r = c.getBoundingClientRect();
        console.log('   canvas[' + i + ']: ' + r.width + 'x' + r.height + ' at (' + r.left + ',' + r.top + ') id=' + c.id);
    });

    // Check for game objects in window
    console.log('4. All window keys with "game","battle","war","pole","unit","army","field","stage","hex":');
    const allKeys = Object.keys(window);
    const gameKeys = allKeys.filter(k => 
        /game|battle|war|pole|unit|army|field|stage|hex|combat|cre|stack|obj|dmg|fight/i.test(k)
    );
    for (let k of gameKeys) {
        try {
            let v = window[k];
            let t = typeof v;
            let extra = '';
            if (t === 'object' && v) {
                let keys = Object.keys(v);
                extra = keys.slice(0, 8).join(', ');
                if (v.constructor && v.constructor.name) extra += ' [' + v.constructor.name + ']';
            }
            console.log('   ' + k + ': ' + t + ' { ' + extra + ' }');
        } catch(e) {}
    }

    // Check for embedded game data in script tags
    console.log('5. Script tags with game data:');
    const scripts = document.querySelectorAll('script');
    let found = 0;
    scripts.forEach((sc, i) => {
        const txt = sc.textContent || '';
        if (txt.length > 50 && /pole|stage|battle|unit|army|creature|war|hex|dmg|attack|defence/i.test(txt)) {
            console.log('   script[' + i + ']: ' + txt.length + ' chars, first 300: ' + txt.substring(0, 300));
            found++;
        }
    });
    if (found === 0) console.log('   No game data scripts found');

    // Check for WebGL/Phaser/PixiJS
    console.log('6. Game engines:');
    console.log('   Phaser:', typeof Phaser !== 'undefined' ? 'YES' : 'NO');
    console.log('   PixiJS:', typeof PIXI !== 'undefined' ? 'YES' : 'NO');
    console.log('   Three.js:', typeof THREE !== 'undefined' ? 'YES' : 'NO');
    console.log('   CreateJS:', typeof createjs !== 'undefined' ? 'YES' : 'NO');

    // Check document body for game containers
    console.log('7. Game containers:');
    const containers = document.querySelectorAll('[id*="game"],[id*="battle"],[id*="war"],[id*="pole"],[id*="field"],[id*="canvas"],[class*="game"],[class*="battle"]');
    containers.forEach((c, i) => {
        if (i < 15) console.log('   ' + c.tagName + ' #' + c.id + ' .' + c.className + ' (' + c.children.length + ' children)');
    });

    console.log('%c=== Done! Copy all this output and send to me ===', 'color:#0ff;font-size:14px');
})();
