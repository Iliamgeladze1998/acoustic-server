var hwm_hint_show_in = 1000;
var hwm_hint;
var hwm_hint_timer = 0;
var hwm_hint_hide_timer = 0;
var hwm_hint_default_delay = 500;
var hwm_hint_hide_default_delay = 200;
var hwm_hint_mobile_bottom_padding = 0.025;
var hwm_hint_ignore_mousemove = false;

function hwm_hint_get_font_scale()
{
   var scale = 1;
   try {
      if (typeof window !== 'undefined' && window.HWM_HINT_FONT_SCALE !== undefined) {
         scale = Number(window.HWM_HINT_FONT_SCALE);
      }
   } catch (e) {
      scale = 1;
   }
   if (!isFinite(scale) || scale <= 0) scale = 1;
   return Math.max(0.25, Math.min(4, scale));
}

function show_hwm_hint(e)
{
   if (typeof hwm_hint === 'undefined') return 0;
   if ((hwm_hint_ignore_mousemove)&&(e.type == 'mousemove')) return 0;
   if (!e.pageX){
			if ((e.touches)&&(e.touches[0])){
				e.pageX = e.touches[0].pageX;
				e.pageY = e.touches[0].pageY;
			}else{
				e.pageX = -1;
				e.pageY = -1;
			};
   };
   var divider = 2;
   if (e.type == 'touchstart'){
	   divider = 1;
	   hwm_hint_ignore_mousemove = true;
   };

	var doc = document.documentElement;
	var left = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
	var top = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0);


   hwm_hint.mx = e.pageX - left;
   hwm_hint.my = e.pageY  - top;

   if (hwm_hint_timer) {
      clearTimeout(hwm_hint_timer);
      hwm_hint_timer = 0;
   }
   if ((hwm_hint.link == this) && (hwm_hint_timer != 0)) return 0;
   hwm_hint.link = this;
   if (hwm_hint_hide_timer) {
      clearTimeout(hwm_hint_hide_timer);
      hwm_hint_hide_timer = 0;
   };
   if (hwm_hint.link.getAttribute('hint_blocker')) {
      var hint_blocker = hwm_hint.link.getAttribute('hint_blocker');
      if (document.getElementById(hint_blocker).style.display != 'none') {
         return 0;
      };
   };
   if (hwm_hint.link.getAttribute('hint_delay')) var hint_delay = hwm_hint.link.getAttribute('hint_delay');
   else var hint_delay = hwm_hint_default_delay;

   var not_hide = false;
   if (e.type == 'touchstart'){
      not_hide = true;
   };

   if (typeof divider !== 'undefined')
   {
	   hint_delay /= divider;
   }
   if (hint_delay == 0) {
      start_show_hwm_hint(not_hide);
      hwm_hint_timer = 1;
   }
   else hwm_hint_timer = setTimeout(start_show_hwm_hint, hint_delay, not_hide);
};

function hint_getScrollbarWidth() {

  const outer = document.createElement('div');
  outer.style.visibility = 'hidden';
  outer.style.overflow = 'scroll'; 
  outer.style.msOverflowStyle = 'scrollbar'; 
  document.body.appendChild(outer);

  const inner = document.createElement('div');
  outer.appendChild(inner);

  const scrollbarWidth = (outer.offsetWidth - inner.offsetWidth);

  outer.parentNode.removeChild(outer);

  return scrollbarWidth;

}

function start_show_hwm_hint(not_hide)
{

   if (typeof hwm_hint === 'undefined') return 0;
   if ((typeof hwm_mobile_view !== 'undefined')&&(hwm_mobile_view)) var is_mobile_view = true;
   var h_font_scale = hwm_hint_get_font_scale();
   var h_font_size = 90 * h_font_scale;
   if (typeof font_size !== 'undefined'){
	   hwm_hint.style['font-size'] = Math.min(16 * h_font_scale, font_size*0.9*h_font_scale) + 'px';
   }else{
	   hwm_hint.style['font-size'] = h_font_size + '%';
   };
   hwm_hint.time = Date.now();
   hwm_hint.not_hide = not_hide;
   hwm_hint.style['max-width'] = 'none';
   hwm_hint.innerHTML = hwm_hint.link.getAttribute('hint');
   hwm_hint.classList.add('hwm_hint_css_visible');
   hwm_hint.style.display = 'block';
   var el_width = hwm_hint.link.offsetWidth;
   var el_height = hwm_hint.link.offsetHeight;
   if (is_mobile_view) el_height += Math.max(window.outerWidth, window.outerHeight)*hwm_hint_mobile_bottom_padding;
   var elemRect = hwm_hint.link.getBoundingClientRect(),
      el_y = elemRect.top,
      el_x = elemRect.left;

   if ((!is_mobile_view)&&(hwm_hint.mx>0)){
	   el_width = hwm_hint.mx  + 10 - elemRect.left;
	   el_height = hwm_hint.my  + 14 - elemRect.top;
   };

   hwm_hint.style.left = '0px';
   hwm_hint.style.top = '0px';
   var mh_width = hwm_hint.offsetWidth;
   var mh_height = hwm_hint.offsetHeight;
   var ok = false;
   var st_width = mh_width;
   var w_perc = 1;
   if ((mh_width > mh_height * 3)&&((is_mobile_view)||(mh_width>400))) {
      w_perc = 0.3;
      hwm_hint.style['max-width'] = (w_perc * st_width) + 'px';
      mh_width = hwm_hint.offsetWidth;
      mh_height = hwm_hint.offsetHeight;
   };
   if (document.body.scrollHeight > document.body.clientHeight) var scroll_width = hwm_hint.ScrollbarWidth; else var scroll_width = 0;
   

   while (!ok) {
      ok = true;
      if (((hwm_hint.scrollWidth > hwm_hint.clientWidth) || (mh_width * 0.35 < mh_height)) && (w_perc < 1)) {
         w_perc += 0.1;
         hwm_hint.style['max-width'] = (w_perc * st_width) + 'px';
         mh_width = hwm_hint.offsetWidth;
         mh_height = hwm_hint.offsetHeight;
         ok = false;
         continue;
      }
      if ((((mh_height + el_y + el_height > window.innerHeight) && (el_y - mh_height < 0)) || (mh_width > document.body.clientWidth - scroll_width)) && (h_font_size > 20)) {
         if (w_perc < 1) {
            w_perc += 0.1;
            hwm_hint.style['max-width'] = (w_perc * st_width) + 'px';
         }
         else {
            hwm_hint.style['max-width'] = 'none';
         };
         h_font_size -= 5;
         hwm_hint.style['font-size'] = h_font_size + '%';
         mh_width = hwm_hint.offsetWidth;
         mh_height = hwm_hint.offsetHeight;
         ok = false;
      };
   }
   var mh_x = Math.max(1, el_x + el_width / 2 - mh_width / 2);
   if (!is_mobile_view){
	   mh_x = Math.max(1, el_x + el_width);
   };
   if (mh_x + mh_width >= document.body.clientWidth - scroll_width) {
      mh_x = document.body.clientWidth - mh_width - 1 - scroll_width;
   };
   if (is_mobile_view){
	   var mh_y = el_y - mh_height - 1;

	   if (mh_y<0){
		  mh_y = el_y + el_height;
	   }
   }else{
     var mh_y = el_y + el_height;
	 if (mh_height + mh_y > window.innerHeight) {
        mh_y = el_y - mh_height - 1;
     };
   };

   hwm_hint.style.top = mh_y + 'px';
   hwm_hint.style.left = mh_x + 'px';
};

function start_hide_hwm_hint()
{
   if (typeof hwm_hint === 'undefined') return 0;
     
   if (hwm_hint_timer) {
      clearTimeout(hwm_hint_timer);
      hwm_hint_timer = 0;
   };
   if (hwm_hint_hide_timer) {
      clearTimeout(hwm_hint_hide_timer);
      hwm_hint_hide_timer = 0;
   };

   hwm_hint.classList.remove('hwm_hint_css_visible');
   hwm_hint.style.display = 'none';
}

function hide_hwm_hint(e, instant) {
   if ((typeof hwm_hint !== 'undefined')&&(Date.now() - hwm_hint.time<300)&&(hwm_hint.not_hide)){
         return 0;
   }
   if (hwm_hint_timer){
	   clearTimeout(hwm_hint_timer);
	   hwm_hint_timer = 0;
   };
   if (hwm_hint_hide_timer) {
      clearTimeout(hwm_hint_hide_timer);
      hwm_hint_hide_timer = 0;
   };
   if ((typeof hwm_hint !== 'undefined')&&(hwm_hint.not_hide)){
      if ((e.type != 'touchend')&&(e.type != 'touchcancel')&&(e.type != 'mouseup')) return 0;
   };
   if (instant) {
      start_hide_hwm_hint();
   }
   else {
      hwm_hint_hide_timer = setTimeout(start_hide_hwm_hint, hwm_hint_hide_default_delay);
   };
};

function hwm_hints_init()
{
   if (typeof hwm_hint === 'undefined') {
      hwm_hint = document.createElement("div");
      hwm_hint.classList.add("hwm_hint_css");
      hwm_hint.style['z-index'] = 500000;
      document.body.appendChild(hwm_hint);
      hwm_hint.addEventListener('mouseup', hide_hwm_hint);
	  hwm_hint.ScrollbarWidth = hint_getScrollbarWidth();
   }
   var el = document.getElementsByClassName("show_hint");
   for (var i = 0; i < el.length; i++) {
      if (!el[i].getAttribute('hwm_hint_added')) {
         el[i].setAttribute("hwm_hint_added", 1);
         el[i].addEventListener('mousemove', show_hwm_hint);
         el[i].addEventListener('touchstart', show_hwm_hint);
         el[i].addEventListener('mouseout', hide_hwm_hint);
         el[i].addEventListener('touchend', hide_hwm_hint);
         el[i].addEventListener('touchcancel', hide_hwm_hint);
//         el[i].addEventListener('touchout', hide_hwm_hint);
      }
   }



}
