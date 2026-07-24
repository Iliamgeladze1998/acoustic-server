// Quick battle status - paste in console
(function() {
    if (typeof stage === 'undefined' || !stage.pole || !stage.pole.obj) {
        console.log('NO BATTLE LOADED');
        return;
    }
    const arr = stage.pole.obj_array;
    console.log('=== BATTLE STATUS ===');
    console.log('Grid: ' + defxn + 'x' + defyn);
    console.log('Units:');
    for (let k of arr) {
        const c = stage.pole.obj[k];
        if (!c) continue;
        if (!c.it_unit) continue;
        if (c.dead === 1 || c.nownumber <= 0) {
            console.log('  [' + k + '] DEAD: ' + c.nametxt);
            continue;
        }
        const team = c.owner === 1 ? 'ME' : c.owner === 2 ? 'ENEMY' : 'NEUTRAL';
        console.log('  [' + k + '] ' + team + ': ' + c.nametxt + ' x' + c.nownumber +
            ' HP:' + c.nowhealth + '/' + c.maxhealth +
            ' ATK:' + c.attack + ' DEF:' + c.defence +
            ' SPD:' + c.speed + ' INIT:' + c.nowinit +
            ' pos:[' + c.x + ',' + c.y + ']' +
            ' scr:[' + c.scr_x + ',' + c.scr_y + ']' +
            (c.shooter ? ' BOW' : '') + (c.flyer ? ' FLY' : '') +
            ' side:' + c.side);
    }
    // Find who has highest nowinit (should be active)
    let maxInit = -9999, activeIdx = -1, activeName = '';
    for (let k of arr) {
        const c = stage.pole.obj[k];
        if (!c || !c.it_unit || c.dead === 1 || c.nownumber <= 0) continue;
        if (c.nowinit > maxInit) {
            maxInit = c.nowinit;
            activeIdx = k;
            activeName = c.nametxt;
        }
    }
    console.log('Active (highest nowinit): [' + activeIdx + '] ' + activeName + ' (init:' + maxInit + ')');
    console.log('=== DONE ===');
})();
