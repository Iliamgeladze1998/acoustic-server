// Dump unit data - paste in console during battle
(function() {
    console.log('=== UNIT DUMP ===');
    console.log('defxn:', defxn, 'defyn:', defyn);
    console.log('obj_array:', stage.pole.obj_array);
    
    // Dump all units
    for (let k of stage.pole.obj_array) {
        const c = stage.pole.obj[k];
        if (!c) { console.log('[' + k + '] NULL'); continue; }
        // Get ALL properties
        const props = {};
        for (let p in c) {
            try {
                let v = c[p];
                if (typeof v === 'function') continue;
                if (typeof v === 'object' && v !== null) {
                    // Skip PIXI objects, just note they exist
                    if (v.constructor && v.constructor.name) {
                        props[p] = '[' + v.constructor.name + ']';
                    } else {
                        props[p] = typeof v;
                    }
                } else {
                    props[p] = v;
                }
            } catch(e) { props[p] = 'ERR'; }
        }
        console.log('[' + k + ']', JSON.stringify(props));
    }

    // Check heroes
    console.log('=== HEROES ===');
    for (let k in heroes) {
        const h = heroes[k];
        if (!h) continue;
        const props = {};
        for (let p in h) {
            try {
                let v = h[p];
                if (typeof v === 'function') continue;
                if (typeof v === 'object' && v !== null) {
                    props[p] = v.constructor ? '[' + v.constructor.name + ']' : typeof v;
                } else {
                    props[p] = v;
                }
            } catch(e) {}
        }
        console.log('hero[' + k + ']', JSON.stringify(props));
    }

    // Check get_dmg_info
    console.log('=== FUNCTIONS ===');
    console.log('get_dmg_info:', typeof get_dmg_info);
    console.log('typeof stage.pole.get_dmg_info:', typeof stage.pole.get_dmg_info);
    console.log('typeof stage.pole.calcmagic_script:', typeof stage.pole.calcmagic_script);
    // Search for get_dmg_info in stage.pole methods
    if (stage.pole) {
        const methods = Object.getOwnPropertyNames(Object.getPrototypeOf(stage.pole)).filter(m => typeof stage.pole[m] === 'function');
        console.log('stage.pole methods:', methods.filter(m => m.includes('dmg') || m.includes('damage') || m.includes('calc') || m.includes('attack')));
    }

    // Check cur_unit / active unit
    console.log('=== ACTIVE UNIT ===');
    console.log('cur_unit:', typeof cur_unit !== 'undefined' ? cur_unit : 'N/A');
    // Check for active flags
    for (let k of stage.pole.obj_array) {
        const c = stage.pole.obj[k];
        if (!c) continue;
        if (c.active || c.is_active || c.turn || c.acted || c.is_acted) {
            console.log('[' + k + '] flags: active=' + c.active + ' is_active=' + c.is_active + ' turn=' + c.turn + ' acted=' + c.acted);
        }
    }

    // Check my_side
    console.log('my_side:', typeof my_side !== 'undefined' ? my_side : 'N/A');

    // Check pixis (PIXI Application)
    console.log('=== PIXI ===');
    if (typeof pixis !== 'undefined') {
        console.log('pixis.renderer:', pixis.renderer ? 'YES' : 'NO');
        console.log('pixis.stage:', pixis.stage ? 'YES' : 'NO');
        if (pixis.renderer) {
            console.log('renderer width:', pixis.renderer.width, 'height:', pixis.renderer.height);
        }
    }

    // Check xr_last, yr_last (last mouse position on grid)
    console.log('xr_last:', xr_last, 'yr_last:', yr_last);

    console.log('=== DONE ===');
})();
