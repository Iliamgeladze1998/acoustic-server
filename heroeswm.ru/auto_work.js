// =====================================================
// HeroesWM Auto Work Script
// =====================================================
// F12 -> Console -> Paste -> Enter
// Automatically finds best work and applies every hour
// First 5 per day = no captcha, after that needs manual code
// =====================================================

(function() {
    if (window.__autoWork) {
        clearInterval(window.__autoWork.timer);
        console.log('[AutoWork] Stopped previous instance.');
    }
    window.__autoWork = { timer: null, lastWorkTime: 0, lastObject: null, cycle: 0 };

    // ---- Fetch a URL and return text ----
    function fetchPage(url) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open('GET', url, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) resolve(xhr.responseText);
                    else reject('HTTP ' + xhr.status);
                }
            };
            xhr.send(null);
        });
    }

    // ---- Parse map.php to find work objects ----
    async function findWorkObjects() {
        try {
            const html = await fetchPage('map.php?js=1');
            // Look for object-info.php links with work available
            const matches = [];
            const regex = /object-info\.php\?id=(\d+)/g;
            let m;
            while ((m = regex.exec(html)) !== null) {
                matches.push(parseInt(m[1]));
            }
            return [...new Set(matches)]; // unique
        } catch(e) {
            console.log('[AutoWork] Error fetching map: ' + e);
            return [];
        }
    }

    // ---- Check object-info page for work availability ----
    async function checkObject(objId) {
        try {
            const html = await fetchPage('object-info.php?id=' + objId);
            
            // Check if work button exists (kirka / "Устроиться")
            const hasWorkButton = html.includes('do_work') || html.includes('Устроиться') || html.includes('work_button');
            
            // Check if already working somewhere
            const alreadyWorking = html.includes('Вы уже работаете') || html.includes('вы работаете');
            
            // Check if full (no free spots)
            const isFull = html.includes('нет свободных') || html.includes('мест нет');
            
            // Try to find pay rate
            let payRate = 0;
            const payMatch = html.match(/(\d+)\s*зол/);
            if (payMatch) payRate = parseInt(payMatch[1]);
            
            // Check for captcha requirement
            const needsCaptcha = html.includes('code') || html.includes('код') || html.includes('captcha');
            
            return { id: objId, hasWorkButton, alreadyWorking, isFull, payRate, needsCaptcha, html };
        } catch(e) {
            return { id: objId, hasWorkButton: false, alreadyWorking: false, isFull: true, payRate: 0, needsCaptcha: false, html: '' };
        }
    }

    // ---- Try to apply for work at object ----
    async function applyForWork(objId, code) {
        try {
            // First get the page to find the form action / sign
            const html = await fetchPage('object-info.php?id=' + objId);
            
            // Find the work form - look for do_work action or sign
            let sign = '';
            const signMatch = html.match(/sign=([a-f0-9]+)/i);
            if (signMatch) sign = signMatch[1];
            
            // Find work type / action URL
            let workUrl = 'object-info.php?id=' + objId + '&do_work=1';
            if (sign) workUrl += '&sign=' + sign;
            if (code) workUrl += '&code=' + encodeURIComponent(code);
            
            // Try to submit
            const result = await fetchPage(workUrl);
            
            // Check if success
            const success = result.includes('Вы устроились') || result.includes('успешно') || !result.includes('ошибк');
            
            return { success, result };
        } catch(e) {
            return { success: false, result: e };
        }
    }

    // ---- Check if currently working ----
    async function checkCurrentWork() {
        try {
            const html = await fetchPage('home.php');
            // Look for "you are working" indicator
            if (html.includes('Вы работаете') || html.includes('вы работаете') || html.includes('working')) {
                // Try to find remaining time
                const timeMatch = html.match(/(\d+):(\d+)/);
                if (timeMatch) {
                    return { working: true, minutesLeft: parseInt(timeMatch[1]) * 60 + parseInt(timeMatch[2]) };
                }
                return { working: true, minutesLeft: 60 };
            }
            return { working: false, minutesLeft: 0 };
        } catch(e) {
            return { working: false, minutesLeft: 0 };
        }
    }

    // ---- Main work cycle ----
    async function doWorkCycle() {
        window.__autoWork.cycle++;
        const cycle = window.__autoWork.cycle;
        console.log('%c[AutoWork #' + cycle + '] Cycle started', 'color:#0ff');
        
        // Check if already working
        const currentStatus = await checkCurrentWork();
        if (currentStatus.working) {
            console.log('[AutoWork] Already working. ' + currentStatus.minutesLeft + ' min left.');
            return;
        }
        
        // Check if 1 hour has passed since last work
        const now = Date.now();
        if (window.__autoWork.lastWorkTime > 0 && (now - window.__autoWork.lastWorkTime) < 3600000) {
            const waitMin = Math.ceil((3600000 - (now - window.__autoWork.lastWorkTime)) / 60000);
            console.log('[AutoWork] Need to wait ' + waitMin + ' min before next work.');
            return;
        }
        
        // Find work objects from map
        const objIds = await findWorkObjects();
        console.log('[AutoWork] Found ' + objIds.length + ' objects on map');
        
        if (objIds.length === 0) {
            console.log('[AutoWork] No objects found. Make sure you are on heroeswm.ru');
            return;
        }
        
        // Check each object for work availability, sort by pay
        const available = [];
        for (const id of objIds) {
            const info = await checkObject(id);
            if (info.hasWorkButton && !info.alreadyWorking && !info.isFull) {
                available.push(info);
                console.log('[AutoWork] Object #' + id + ' available, pay: ' + info.payRate + ' gold, captcha: ' + info.needsCaptcha);
            }
        }
        
        if (available.length === 0) {
            console.log('[AutoWork] No available work found. Will retry next cycle.');
            return;
        }
        
        // Sort by pay rate (highest first)
        available.sort((a, b) => b.payRate - a.payRate);
        
        // Try best object
        const best = available[0];
        console.log('%c[AutoWork] Best object: #' + best.id + ' (pay: ' + best.payRate + ' gold)', 'color:#0f0;font-weight:bold');
        
        if (best.needsCaptcha) {
            console.log('%c[AutoWork] WARNING: Captcha required! Open this URL manually:', 'color:#ff0');
            console.log('https://www.heroeswm.ru/object-info.php?id=' + best.id);
            // Open the page for manual code entry
            window.open('object-info.php?id=' + best.id, '_blank');
            return;
        }
        
        // Apply for work
        const result = await applyForWork(best.id);
        if (result.success) {
            window.__autoWork.lastWorkTime = Date.now();
            window.__autoWork.lastObject = best.id;
            console.log('%c[AutoWork] SUCCESS! Applied for work at object #' + best.id, 'color:#0f0;font-weight:bold;font-size:14px');
        } else {
            console.log('%c[AutoWork] Failed to apply. Result: ' + result.result.substring(0, 200), 'color:#f55');
            // Try next available
            for (let i = 1; i < available.length; i++) {
                const next = available[i];
                if (next.needsCaptcha) continue;
                const r2 = await applyForWork(next.id);
                if (r2.success) {
                    window.__autoWork.lastWorkTime = Date.now();
                    window.__autoWork.lastObject = next.id;
                    console.log('%c[AutoWork] SUCCESS at fallback object #' + next.id, 'color:#0f0;font-weight:bold');
                    return;
                }
            }
            console.log('[AutoWork] All objects failed. Will retry next cycle.');
        }
    }

    // ---- Start ----
    console.log('%c🔨 AutoWork ჩართულია!', 'color:#0f0;font-size:18px;font-weight:bold');
    console.log('%c💡 Stop: clearInterval(window.__autoWork.timer)', 'color:#f88');
    console.log('[AutoWork] First cycle in 3 seconds...');
    
    // Run first cycle after 3 seconds
    setTimeout(doWorkCycle, 3000);
    
    // Then every 5 minutes check
    window.__autoWork.timer = setInterval(doWorkCycle, 300000);

    window.autoWork = {
        stop: function() {
            clearInterval(window.__autoWork.timer);
            console.log('[AutoWork] Stopped.');
        },
        run: function() { doWorkCycle(); },
        status: function() {
            console.log('Last work time:', window.__autoWork.lastWorkTime ? new Date(window.__autoWork.lastWorkTime).toLocaleString() : 'never');
            console.log('Last object:', window.__autoWork.lastObject || 'none');
            console.log('Cycles:', window.__autoWork.cycle);
        },
    };

})();
