var art_durability_shown = false;
var art_durability_hidden = false;
var hwm_mobile_hide_timeout = -1;

function hwm_mobile_hide_arts_durability(timer) {
   if (!timer) timer = 30000;
   if (hwm_mobile_hide_timeout != -1) clearTimeout(hwm_mobile_hide_timeout);
   hwm_mobile_hide_timeout = setTimeout(hwm_mobile_show_arts_durability, timer);      		  	
}

function hwm_mobile_show_arts_durability(pc_mode, show) {
   if (typeof pc_mode === 'undefined') {
      pc_mode = true;
      show = false;
   }
   if (show) {
      art_durability_hidden = false;
      if (hwm_mobile_hide_timeout != -1) {clearTimeout(hwm_mobile_hide_timeout);hwm_mobile_hide_timout = -1;};
      if (!pc_mode) hwm_mobile_hide_arts_durability(30000);
   }
   if ((!art_durability_hidden)&&(!show)) {
      hwm_mobile_hide_arts_durability(20);
   }

   if (!pc_mode && art_durability_shown) return true;
   if (pc_mode && art_durability_shown && show) return true;
   if (pc_mode && art_durability_hidden && !show) return true;

   hwm_mobile_show_arts_durability_show(show);
}

function hwm_mobile_show_arts_durability_show(show) {
   var Els = document.getElementsByClassName('art_durability_hidden');
   for (var Ei=0; Ei<Els.length; Ei++)
   {
      if (show)
      {
         Els[Ei].style.display='';
         Els[Ei].style.opacity = 1;
      }
      else
      {
         Els[Ei].style.opacity = Els[Ei].style.opacity - 0.1;
         if (Els[Ei].style.opacity == 0)
         {
            art_durability_hidden = true;
            Els[Ei].style.display='none';
         }
      }
   }
   art_durability_shown = show;
}

function hwm_mobile_show_arts_durability_update_displayed() {
   if (art_durability_shown) hwm_mobile_show_arts_durability_show(true);
}

function hwm_handle_click(event, url) {
    var target = event.target;
    while (target && target !== event.currentTarget) {
      if (target.tagName && target.tagName.toLowerCase() === 'a') {
        return false;
      }
      target = target.parentNode;
    }

   if (event.ctrlKey || event.metaKey) {
      window.open(url, '_blank');
   } else {
      window.location.href = url;
   }
}

function hwm_disable_buttons() {
   var elements = document.querySelectorAll("[hwm_action_button_type]");
   for (var i = 0; i < elements.length; i++) {
       var element = elements[i];
       var button_type = element.getAttribute("hwm_action_button_type");
       if (button_type == "1") {
           element.disabled = true;
       } else {
           element.style.filter = "";
           if (element.classList) {
               element.classList.add("home_disabled");
               if (element.classList.contains("Checkpoint_variant2")) {
                  element.classList.remove("Checkpoint_variant2");
               }
           } else {
              element.className += " home_disabled";
              var classNameArr = element.className.split(/\s+/);
              var newClassNameArr = [];
              for (var j = 0; j < classNameArr.length; j++) {
                 if (classNameArr[j] !== "Checkpoint_variant2") {
                    newClassNameArr.push(classNameArr[j]);
                 }
              }
              element.className = newClassNameArr.join(" ");
           }
       }
   }
   return true;
}

var hwmPreloadCache = (function () {

  var list = [];
  var seen = {};
  var idx = 0;
  var active = 0;
  var max = 4;
  var started = 0;
  var scheduled = 0;

  var FALLBACK_DELAY_MS = 100;
  var START_DELAY_MS = 1000;
  var IDLE_TIMEOUT_MS = 1000;

  var ua = (window.navigator && window.navigator.userAgent) ? window.navigator.userAgent : '';
  if (/Mobi|Android|iPhone|iPad|iPod/.test(ua)) max = 2;

  function once(fn) {
    var called = 0;
    return function () {
      if (called) return;
      called = 1;
      fn();
    };
  }

  function addOne(url) {
    if (!url) return;
    url = '' + url;
    if (seen[url]) return;
    seen[url] = 1;
    list[list.length] = url;

    if (started) schedulePump();
  }

  function add(x) {
    var i;
    if (!x) return;

    if (typeof x !== 'string' && x.length != null) {
      for (i = 0; i < x.length; i++) {
        addOne(x[i]);
      }
    } else {
      addOne(x);
    }
  }

  function isImageUrl(url) {
     return /\.(png|jpe?g|gif|webp|avif|svg)(\?|$)/i.test(url);
  }

  function isCssUrl(url) {
    return /\.css(\?|$)/i.test(url);
  }

  function isJsUrl(url) {
    return /\.js(\?|$)/i.test(url);
  }

  function preloadHead(url, asType, done) {
    done = done || function(){};
  
    try {
      var link = document.createElement('link');
      var rel = (asType === 'script' || asType === 'style') ? 'preload' : 'prefetch';

      rel = 'prefetch';
  
      link.rel = rel;
      link.as = asType;
      link.href = url;
  
      var finished = 0;
      function finish() {
        if (finished) return;
        finished = 1;
        done();
      }
  
      link.onload = finish;
      link.onerror = finish;
      setTimeout(finish, 6000);
  
      document.head.appendChild(link);
      return true;
    } catch (e) {
      return false;
    }
  }


  function warmupByHead(url, done) {
    done = done || function(){};
  
    var asType = '';
    if (isImageUrl(url)) {
       asType = 'image';
       loadImage(url, done);
       return;
    }
    else if (isCssUrl(url)) {
       asType = 'style';
    }
    else if (isJsUrl(url)) asType = 'script';
  
    // 1) preload2head
    if (asType) {
      if (preloadHead(url, asType, done)) return;
    }
  
    // 2) Fallback: fetch
    if (window.fetch) {
      try {
        var p = window.fetch(url, { method: 'GET', cache: 'force-cache' });
        if (p && p.then) {
          p.then(function (r) {
            if (r && r.ok && r.arrayBuffer) return r.arrayBuffer();
          }).then(done, done);
        } else done();
        return;
      } catch (e) {}
    }
  
    // 3) Fallback: XHR (IE9+)
    try {
      var finished = 0;
      function finish(){ if (!finished){ finished=1; done(); } }
  
      var xhr = new XMLHttpRequest();
      xhr.open('GET', url, true);
      xhr.onreadystatechange = function(){
        if (xhr.readyState === 4) { xhr.onreadystatechange = null; finish(); }
      };
      if ('onerror' in xhr) xhr.onerror = finish;
      if ('ontimeout' in xhr) xhr.ontimeout = finish;
      try { xhr.timeout = 8000; } catch (e2) {}
      setTimeout(finish, 9000);
      xhr.send(null);
    } catch (e3) {
      done();
    }
  }

  function warmupBytes(url, done) {
    done = done || function(){};
  
    if (window.fetch) {
      try {
        var opts = { method: 'GET', cache: 'force-cache' };

        if (isImageUrl(url)) {
          opts.headers = {
            'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8'
          }
        }
   
        var p = window.fetch(url, opts);
  
        if (p && p.then) {
          p.then(function () { done(); }, function () { done(); });
        } else {
          done();
        }
        return;
      } catch (e) {
        // goto XHR
      }
    }
  
    // Fallback: XHR (IE9+)
    try {
      var finished = 0;
      function finish() {
        if (finished) return;
        finished = 1;
        done();
      }
  
      var xhr = new XMLHttpRequest();
      xhr.open('GET', url, true);
  
      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
          xhr.onreadystatechange = null;
          finish();
        }
      };
  
      if ('onerror' in xhr) xhr.onerror = finish;
      if ('ontimeout' in xhr) xhr.ontimeout = finish;
      try { xhr.timeout = 8000; } catch (e2) {}
  
      // for oldest devices
      setTimeout(finish, 9000);
  
      xhr.send(null);
    } catch (e3) {
      done();
    }
  }

  function loadImage(url, done) {
    done = done || function(){};
  
    var finished = 0;
    function finish() {
      if (finished) return;
      finished = 1;
      done();
    }
  
    var img = new Image();
    img.onload = img.onerror = function () {
      img.onload = null;
      img.onerror = null;
      finish();
    };
  
    // safety timeout
    setTimeout(finish, 8000);
  
    img.src = url;
  }


  function loadOne(url) {
    var finish = once(function () {
      active--;
      schedulePump();
    });

//    warmupBytes(url, finish);
    warmupByHead(url, finish);
  }


  function schedulePump() {
    if (scheduled) return;
    scheduled = 1;

    if (window.requestIdleCallback) {
      requestIdleCallback(function (deadline) {
        scheduled = 0;
        pump(deadline);
      }, { timeout: IDLE_TIMEOUT_MS });
    } else {
      setTimeout(function () {
        scheduled = 0;
        pump(null);
      }, FALLBACK_DELAY_MS);
    }
  }
  
  function pump(deadline) {
     while (active < max && idx < list.length) {
       if (deadline && deadline.timeRemaining && deadline.timeRemaining() <= 1) {
         break;
       }
       active++;
       loadOne(list[idx++]);
    }
  
    if (idx < list.length) {
      schedulePump();
    }
  }

  function start() {
    if (started) return;
    started = 1;
    setTimeout(schedulePump, START_DELAY_MS);
  }

  return {
    add: add,
    start: start
  };

})();


// PHP-style sprintf supporting:
//   %s, %d        - positional (in order of appearance)
//   %1s, %2s ...  - explicit position (PHP non-dollar form)
//   %1$s, %2$s ...- explicit position (PHP dollar form)
// Excess placeholders (no matching arg) are left untouched.
function hwm_sprintf(format) {
   if (format === null || format === undefined) return '';
   var args    = arguments;
   var autoIdx = 1;

   return String(format).replace(/%(\d+)?\$?[sd]/g, function (match, idx) {
      var pos = idx ? parseInt(idx, 10) : autoIdx++;
      if (pos < 1 || pos >= args.length) return match;
      var v = args[pos];
      return (v === null || v === undefined) ? '' : v;
   });
}


function hwmFormatNumber(value) {
   if (value === null || value === undefined || value === '') return '0';
   var n = Number(value);
   if (!isFinite(n)) return '0';

   var sign = n < 0 ? '-' : '';
   n = Math.round(Math.abs(n) * 100) / 100;

   var intPart = Math.floor(n);
   var firstDec = Math.floor(n * 10) - intPart * 10;
   var dec = firstDec >= 1 ? '.' + firstDec : '';

   var intStr = String(intPart).replace(/\B(?=(\d{3})+(?!\d))/g, ',');

   return sign + intStr + dec;
}


var hwmTopline = (function () {

   function setResourceAmount(values) {
      if (!values) return;

      for (var key in values) {
         if (!Object.prototype.hasOwnProperty.call(values, key)) continue;

         var elements = document.querySelectorAll('[data-hwm-topline-resource-amount="' + key + '"]');
         var formatted = hwmFormatNumber(values[key]);

         for (var i = 0; i < elements.length; i++) {
            elements[i].textContent = formatted;
         }
      }
   }

   function setText(elementId, value) {
      var el = document.getElementById(elementId);
      if (el && value !== undefined && value !== null) el.textContent = value;
   }

   function numeric(value) {
      var n = Number(value);
      return isFinite(n) ? n : null;
   }

   function setNamedBarWidth(name, width) {
      var bars = document.getElementsByName(name);
      if (!bars) return;

      for (var i = 0; i < bars.length; i++) {
         bars[i].style.width = width;
      }
   }

   function getHealthTimerValue() {
      var timer = null;

      if (typeof window.hwm_top_line_heart_time !== 'undefined') timer = numeric(window.hwm_top_line_heart_time);
      if ((timer === null || timer <= 0) && typeof window.hwm_time_heart !== 'undefined') timer = numeric(window.hwm_time_heart);
      if ((timer === null || timer <= 0) && typeof window.time_heart !== 'undefined') timer = numeric(window.time_heart);

      return (timer !== null && timer > 0) ? timer : 1;
   }

   function setTime(value)   { setText('hwm_topline_time',   value); }
   function setOnline(value) { setText('hwm_topline_online', value); }

   function setHealthHp(health) {
      var hp = numeric(health.hp);
      if (hp === null) return;

      var healthAmount = document.getElementById('health_amount');
      if (healthAmount) {
         healthAmount.textContent = hp;
      }

      var homeHp = document.getElementById('homecss_hp');
      if (homeHp) homeHp.textContent = hp + '%';
      setNamedBarWidth('homecss_hp_barprogress', hp + '%');

      var hpSeconds = numeric(health.hp_seconds);
      var hpTimerValue = (hpSeconds !== null && hpSeconds > 0) ? hpSeconds * 100 : getHealthTimerValue();

      if (typeof window.hwm_heart !== 'undefined') {
         window.hwm_heart = hp;
         if (typeof window.hwm_time_heart !== 'undefined') window.hwm_time_heart = hpTimerValue;
         if (typeof window.hwm_heart_startTime !== 'undefined') window.hwm_heart_startTime = (new Date()).getTime();
         if (typeof window.hwm_heart_draw === 'function') window.hwm_heart_draw(hp);
      }

      if (typeof window.hwmToplineLegacyHeartReset === 'function') {
         window.hwmToplineLegacyHeartReset(hp, hpTimerValue);
      }
      else if (typeof window.heart !== 'undefined') {
         window.heart = hp;
         if (typeof window.time_heart !== 'undefined') window.time_heart = hpTimerValue;
      }

      if (healthAmount && typeof window.top_line_draw_canvas_heart === 'function') {
         window.top_line_draw_canvas_heart(hp, 100, hpTimerValue);
      }
   }

   function setHealthMana(health) {
      var manaMax = numeric(health.mana_max);

      if (manaMax !== null) {
         setText('mana_amount', manaMax);
      }
   }

   function setHealth(health) {
      if (!health) return;

      setHealthHp(health);
      setHealthMana(health);
   }

   function getNotificationImageUrl(img) {
      if (!img) return '';
      if (/^(https?:)?\/\//.test(img)) return img;

      var base = (typeof window.top_line_im_server_url !== 'undefined') ? window.top_line_im_server_url : '';
      return base + img;
   }

   function setNotificationVisible(el, visible) {
      if (!el || !el.style) return;
      el.style.display = visible ? '' : 'none';
   }

   function setIncomingRepairNotification(notification) {
      if (!notification) return;

      var iconId = numeric(notification.icon_id);
      var visible = (iconId !== null && iconId > 0);
      var nodes = document.querySelectorAll('[data-topline-notification="incoming_repair"]');
      var url = notification.url || 'inventory.php?show_trades=1';
      var imgUrl = getNotificationImageUrl(notification.img || (iconId == 2 ? 'i/mobile_view/icons_add/repair2.png' : 'i/mobile_view/icons_add/repair1.png'));

      for (var i = 0; i < nodes.length; i++) {
         var node = nodes[i];
         var tag = node.tagName ? node.tagName.toLowerCase() : '';

         setNotificationVisible(node, visible);

         if (tag == 'a') {
            node.href = url;
         }

         if (notification.hint && node.setAttribute) {
            node.setAttribute('hwm_label', notification.hint);
         }
         if (node.removeAttribute) node.removeAttribute('title');

         var img = (tag == 'img') ? node : node.getElementsByTagName('img')[0];
         if (img && imgUrl) img.src = imgUrl;
         if (img && img.removeAttribute) img.removeAttribute('title');
      }
   }

   function setNotifications(notifications) {
      if (!notifications) return;
      if (notifications.incoming_repair !== undefined) setIncomingRepairNotification(notifications.incoming_repair);
   }

   // Server-shipped state from utils_get_topline_state().
   // Sections that are present get applied; missing sections are skipped.
   function applyState(state) {
      if (!state) return;
      if (state.resources)               setResourceAmount(state.resources);
      if (state.time   !== undefined)    setTime(state.time);
      if (state.online !== undefined)    setOnline(state.online);
      if (state.health)                  setHealth(state.health);
      if (state.notifications)           setNotifications(state.notifications);
   }

   return {
      setResourceAmount: setResourceAmount,
      setTime:           setTime,
      setOnline:         setOnline,
      setHealth:         setHealth,
      setNotifications:  setNotifications,
      applyState:        applyState
   };

})();
