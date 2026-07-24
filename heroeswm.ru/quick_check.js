// Quick check - paste in console during battle
(function() {
    // 1. Check stage
    console.log('stage:', typeof stage !== 'undefined' ? typeof stage : 'NO');
    try { if (stage) console.log('stage keys:', Object.keys(stage).slice(0,15)); } catch(e){}
    try { if (stage && stage.pole) console.log('stage.pole keys:', Object.keys(stage.pole).slice(0,15)); } catch(e){}
    try { if (stage && stage.pole && stage.pole.obj) console.log('stage.pole.obj keys:', Object.keys(stage.pole.obj).slice(0,10)); } catch(e){}

    // 2. Check pole directly
    console.log('pole:', typeof pole !== 'undefined' ? typeof pole : 'NO');
    try { if (pole) console.log('pole keys:', Object.keys(pole).slice(0,15)); } catch(e){}

    // 3. Check PIXI
    console.log('PIXI:', typeof PIXI !== 'undefined' ? 'YES' : 'NO');
    try {
        // PIXI app might be stored somewhere
        if (typeof PIXI !== 'undefined') {
            // Check for PIXI stage/renderer
            for (let k of Object.keys(window)) {
                let v = window[k];
                if (v && v.constructor && v.constructor.name && v.constructor.name.includes('Application')) {
                    console.log('Found PIXI.Application:', k);
                }
                if (v && v.stage && v.renderer) {
                    console.log('Found PIXI app:', k, 'stage:', v.stage.constructor.name);
                }
            }
        }
    } catch(e){}

    // 4. Check show_polep.js globals - try common names
    const names = ['stage','pole','gameStage','gamePole','battleStage','battlePole',
        'app','pixiApp','gameApp','battleground',' battlefield',
        'cur_unit','my_side','heroes','magic','defxn','defyn',
        'get_dmg_info','show_pole','cre','obj','obj_array',
        'mapobj','xr_last','yr_last','animspeed','timer_interval',
        'battle_is_it_perk','chat_inside','chat_format',
        'cre_collection','allUnits','units','creatures'];
    
    console.log('--- Globals check ---');
    for (let n of names) {
        try {
            if (typeof window[n] !== 'undefined') {
                let v = window[n];
                let info = typeof v;
                if (v && typeof v === 'object') {
                    let keys = Object.keys(v);
                    info += ' {' + keys.slice(0,6).join(',') + '}';
                }
                console.log('  ' + n + ': ' + info);
            }
        } catch(e) {}
    }

    // 5. Try to find any object that has .pole property
    console.log('--- Objects with .pole ---');
    for (let k of Object.keys(window)) {
        try {
            let v = window[k];
            if (v && typeof v === 'object' && v.pole && typeof v.pole === 'object') {
                console.log('  window.' + k + ' has .pole!', Object.keys(v.pole).slice(0,8));
            }
        } catch(e) {}
    }

    // 6. Try to find any object that has .obj_array
    console.log('--- Objects with .obj_array ---');
    for (let k of Object.keys(window)) {
        try {
            let v = window[k];
            if (v && typeof v === 'object' && v.obj_array) {
                console.log('  window.' + k + ' has .obj_array!', v.obj_array);
            }
            if (v && typeof v === 'object' && v.pole && v.pole.obj_array) {
                console.log('  window.' + k + '.pole has .obj_array!', v.pole.obj_array);
            }
        } catch(e) {}
    }

    console.log('=== DONE ===');
})();
