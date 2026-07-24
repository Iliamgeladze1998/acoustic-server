var map_req_ind = 0;
var MAP_REQ_IND_MAX = 5;
var map_objXMLHttpReq = new Array();

var map_fps = 0;
var map_apple_flashshow = (/iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream);
var map_fps_timer = 0;

var map_id = 'canvas_map';
var map_container = 'show_map';

var map_scaling_sectors = 470/500;
var map_sectors = Array();

var MapHunterDelta = 0;
var MapHunterClientRefreshAt = 0;


map_sectors = Array();
map_sectors[1] = Array(); map_sectors[1].x = 305; map_sectors[1].y = 300; map_sectors[1].w = 146; map_sectors[1].h = 156;
map_sectors[2] = Array(); map_sectors[2].x = 436; map_sectors[2].y = 293; map_sectors[2].w = 136; map_sectors[2].h = 181;
map_sectors[3] = Array(); map_sectors[3].x = 313; map_sectors[3].y = 160; map_sectors[3].w = 156; map_sectors[3].h = 160;
map_sectors[4] = Array(); map_sectors[4].x = 442; map_sectors[4].y = 160; map_sectors[4].w = 130; map_sectors[4].h = 158;
map_sectors[5] = Array(); map_sectors[5].x = 306; map_sectors[5].y = 440; map_sectors[5].w = 140; map_sectors[5].h = 154;
map_sectors[6] = Array(); map_sectors[6].x = 311; map_sectors[6].y = 36; map_sectors[6].w = 156; map_sectors[6].h = 144;
map_sectors[7] = Array(); map_sectors[7].x = 166; map_sectors[7].y = 448; map_sectors[7].w = 168; map_sectors[7].h = 139;
map_sectors[8] = Array(); map_sectors[8].x = 182; map_sectors[8].y = 300; map_sectors[8].w = 138; map_sectors[8].h = 161;
map_sectors[9] = Array(); map_sectors[9].x = 165; map_sectors[9].y = 42; map_sectors[9].w = 157; map_sectors[9].h = 142;
map_sectors[10] = Array(); map_sectors[10].x = 319; map_sectors[10].y = 582; map_sectors[10].w = 128; map_sectors[10].h = 128;
map_sectors[11] = Array(); map_sectors[11].x = 424; map_sectors[11].y = 450; map_sectors[11].w = 144; map_sectors[11].h = 139;
map_sectors[12] = Array(); map_sectors[12].x = 152; map_sectors[12].y = 175; map_sectors[12].w = 168; map_sectors[12].h = 148;
map_sectors[13] = Array(); map_sectors[13].x = 11; map_sectors[13].y = 178; map_sectors[13].w = 174; map_sectors[13].h = 166;
map_sectors[14] = Array(); map_sectors[14].x = 557; map_sectors[14].y = 279; map_sectors[14].w = 168; map_sectors[14].h = 196;
map_sectors[15] = Array(); map_sectors[15].x = 563; map_sectors[15].y = 141; map_sectors[15].w = 162; map_sectors[15].h = 153;
map_sectors[16] = Array(); map_sectors[16].x = 572; map_sectors[16].y = 22; map_sectors[16].w = 177; map_sectors[16].h = 138;
map_sectors[17] = Array(); map_sectors[17].x = 696; map_sectors[17].y = 251; map_sectors[17].w = 196; map_sectors[17].h = 172;
map_sectors[18] = Array(); map_sectors[18].x = 700; map_sectors[18].y = 132; map_sectors[18].w = 170; map_sectors[18].h = 148;
map_sectors[19] = Array(); map_sectors[19].x = 438; map_sectors[19].y = 582; map_sectors[19].w = 132; map_sectors[19].h = 137;
map_sectors[20] = Array(); map_sectors[20].x = 387; map_sectors[20].y = 706; map_sectors[20].w = 162; map_sectors[20].h = 151;
map_sectors[21] = Array(); map_sectors[21].x = 518; map_sectors[21].y = 702; map_sectors[21].w = 138; map_sectors[21].h = 154;
map_sectors[22] = Array(); map_sectors[22].x = 515; map_sectors[22].y = 843; map_sectors[22].w = 158; map_sectors[22].h = 140;
map_sectors[23] = Array(); map_sectors[23].x = 20; map_sectors[23].y = 53; map_sectors[23].w = 164; map_sectors[23].h = 147;
map_sectors[24] = Array(); map_sectors[24].x = 445; map_sectors[24].y = 23; map_sectors[24].w = 138; map_sectors[24].h = 155;
map_sectors[25] = Array(); map_sectors[25].x = 747; map_sectors[25].y = 544; map_sectors[25].w = 166; map_sectors[25].h = 141;
map_sectors[26] = Array(); map_sectors[26].x = 164; map_sectors[26].y = 581; map_sectors[26].w = 172; map_sectors[26].h = 127;
map_sectors[27] = Array(); map_sectors[27].x = 13; map_sectors[27].y = 323; map_sectors[27].w = 176; map_sectors[27].h = 164;

for (var mapxmlr_i = 0; mapxmlr_i < MAP_REQ_IND_MAX; mapxmlr_i++) map_objXMLHttpReq[mapxmlr_i] = map_css_createXMLHttpReq();

function map_css_createXMLHttpReq()
{
   var objXMLHttpReq;

   if (window.XMLHttpRequest)
   {
      objXMLHttpReq = new XMLHttpRequest();
   }
   else if (window.ActiveXObject)
   {
      objXMLHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
   }
   return objXMLHttpReq;
}

function incr_map_send_ind()
{
   map_req_ind = (map_req_ind + 1) % MAP_REQ_IND_MAX;
}

function hwm_map_send_obj_block_request(event, cx, cy, st)
{
   if (event && event.ctrlKey)
   {
      return true;
   }

   incr_map_send_ind();

   map_objXMLHttpReq[map_req_ind].open('GET', 'map.php?cx='+cx+'&cy='+cy+'&st='+st+'&action=get_objects&js_output=1&rand=' + Math.random() * 1000000, true);
   map_objXMLHttpReq[map_req_ind].onreadystatechange = map_html_handle_data;
   map_objXMLHttpReq[map_req_ind].send(null);

   if (typeof hide_hwm_hint === 'function') hide_hwm_hint(event, true);
   return false;
}

function hwm_map_send_hunt_cancel_request(event)
{
   incr_map_send_ind();

   map_objXMLHttpReq[map_req_ind].open('GET', 'map.php?action=skip&js_output=1&rand=' + Math.random() * 1000000, true);
   map_objXMLHttpReq[map_req_ind].onreadystatechange = map_html_handle_data;
   map_objXMLHttpReq[map_req_ind].send(null);

   if (typeof hide_hwm_hint === 'function') hide_hwm_hint(event, true);
   return false;
}

function hwm_map_send_attack_request(event, nt, auto)
{
   incr_map_send_ind();

   var url = 'map.php?action=attack'+nt;
   if (auto) url = url + '&auto=1&sign='+PL_JS_SIGN;
   url = url + '&js_output=1&rand=' + Math.random() * 1000000;

   map_objXMLHttpReq[map_req_ind].open('GET', url, true);
   map_objXMLHttpReq[map_req_ind].onreadystatechange = map_html_handle_data;
   map_objXMLHttpReq[map_req_ind].send(null);

   if (typeof hide_hwm_hint === 'function') hide_hwm_hint(event, true);
   return false;
}

function map_html_get_current_time_in_sec()
{
   return Math.floor(Date.now() / 1000)
}

function map_html_set_hunt_client_time(delta)
{
   MapHunterClientRefreshAt = map_html_get_current_time_in_sec() + delta;
}

function map_html_handle_data()
{
   var obj = this;
   if (obj.readyState == 4)
   {
      var txt = obj.responseText;
      var data = txt.split(MAP_CSS_GOOD_JS_ANSWER_DELIMITER);

      if (data && data.length >= 3 && data[0] == MAP_CSS_GOOD_JS_ANSWER_PREFIX && data[1] && data[2] && document.getElementById(data[1]))
      {
         document.getElementById(data[1]).innerHTML = data[2];

         if (data[1] == 'map_hunt_block_div' && data.length >= 4 && data[3] && data[3] >= 0)
         {
            MapHunterDelta = parseInt(data[3]);
            map_html_set_hunt_client_time(MapHunterDelta);

            if (map_hunt_timer) clearTimeout(map_hunt_timer);
            map_hunt_timer = setTimeout('map_hunt_refresh()', 1000);
            print_hunt_time_new(MapHunterDelta);
         }

         if (typeof global_zoom_tables === 'function') global_zoom_tables();
         if (typeof try_resize_map === 'function') try_resize_map();
         if (typeof hwm_hints_init === 'function') hwm_hints_init();
      }
      else
      {
         window.location = 'map.php';
         return 0;
      }
   }
}

function print_hunt_time_new(t)
{
   if (t < 0) t = 0;
   var min = Math.floor(t / 60);
   var sec = t % 60;
   var s = '';

   if (min) s = min + ' '+ _LOC_MAP_NEXT_HUNT_TEXT_MIN + ' ';
   s = s + sec + ' ' + _LOC_MAP_NEXT_HUNT_TEXT_SEC + ' ';
   if (document.getElementById('next_ht_new')) document.getElementById('next_ht_new').innerHTML= _LOC_MAP_NEXT_HUNT_TEXT + s;
}

function map_hunt_refresh()
{
   if (map_hunt_timer>=0) clearTimeout(map_hunt_timer);
   MapHunterDelta = MapHunterDelta - 1;

   if (MapHunterClientRefreshAt && MapHunterClientRefreshAt-map_html_get_current_time_in_sec() + 15 < MapHunterDelta) //big lag due inactivity
   {
      window.location='map.php'; 
   }

   print_hunt_time_new(MapHunterDelta);
   if (MapHunterDelta >= 0) map_hunt_timer=setTimeout('map_hunt_refresh()',1000);
   if (MapHunterDelta < 0) window.location='map.php';
}


function map_sweet_confirm(){
      return swal({
  title: "",
  text: _LOC_MAP_CONF_TXT1,
  type: "warning",
  cancelButtonText: _LOC_MAP_CANCEL,
  confirmButtonText: "Ok",
  showCancelButton: true,
  closeOnConfirm: false,
  html: true},
    function(){
       swal.close(); window.location.href="map.php?action=instant_hunt&sign="+PL_JS_SIGN;});
}

function map_sweet_confirmg()
{
      return swal({
  title: "",
  text: _LOC_MAP_CONF_TXT2,
  type: "warning",
  cancelButtonText: _LOC_MAP_CANCEL,
  confirmButtonText: "Ok",
  showCancelButton: true,
  closeOnConfirm: false,
  html: true},
    function(){
       swal.close(); window.location.href="map.php?action=instant_hunt&gold_price="+TWO_WEEKS_OF_INSTANT_BY_GOLD_GOLD_PRICE+"&sign="+PL_JS_SIGN;});
}


function map_start_benchmark()
{
   if (map_apple_flashshow)
   {
      map_fps_check();
   }
   else
   {
      map_fps_timer = setInterval(map_fps_counter, 10);
      setTimeout(map_fps_check, 1000);
   }
}

function map_fps_counter()
{
   map_fps++;
}

function map_fps_check()
{
   if (map_fps_timer) clearInterval(map_fps_timer);
   if ((map_fps<40)||(map_apple_flashshow))
   {
      var stop_anim = Array('map_flag1', 'map_flag2', 'map_rot4');
      if (map_apple_flashshow)
      {
         stop_anim = Array('map_flare1', 'map_flare2', 'map_flare3');
      }
      for (var i=0;i<stop_anim.length;i++)
      {
         var els = document.getElementsByClassName(stop_anim[i]);
         for (j=0;j<els.length;j++)
         {
            els[j].style['animation'] = '';
            els[j].style.animationPlayState = 'paused';
         }
      }
   }
}

function init_param(param)
{
	    if (param.indexOf('*english*')==0) 
		{
			lang=1;
			param=param.substr(9);
		};
		
		if (param.indexOf('*hour')==0) 
		{
			hour=parseFloat(param.substr(5, 2));
			param=param.substr(8);
		};

		if (param.indexOf('tgbut1*')==0) 
		{
			param=param.substr(7);
			show_button('task_button');
			make_notification('task_button');
		};
		if (param.indexOf('tgbut2*')==0) 
		{
			param=param.substr(7);
			show_button('task_button');
		};
		if (param.indexOf('cmbut1*')==0) 
		{
			param=param.substr(7);
			show_button('camp_button');
			make_notification('camp_button');
		};
		if (param.indexOf('cmbut2*')==0) 
		{
			param=param.substr(7);
			show_button('camp_button');
		};
		if (param.indexOf('ldbut1*')==0) 
		{
			param=param.substr(7);
			show_button('leader_button');
			make_notification('leader_button');
		};
		if (param.indexOf('ldbut2*')==0) 
		{
			param=param.substr(7);
			show_button('leader_button');
		};

	_LOC_OSTATKI="Остатки";
	if (lang==1){
		scaptb=Array("","Registry, Clan registration,<br>Hunters' guild,<br>Watchers' guild,<br>Rangers' guild","Mercenaries' guild","","","","Mercenaries' guild",
						 "Thieves' guild","","Portal","Portal","","","","","","Mercenaries' guild","","Portal","","","Mercenaries' guild, Portal","","","","","","","");
		_LOC_OSTATKI="Remnants";
	};	
		
	for (j=1;j<=20+2;j++){
		if (j==20+2){
			var tp=param.substr(0,param.indexOf(':'));
			param=param.substr(param.indexOf(':')+1);
			while(tp.indexOf('|')>0){
				i=parseFloat(tp.substr(0, tp.indexOf('~')));
				ii=Math.floor(i/100);
				closed[ii]=false;
				tp=tp.substr(tp.indexOf('~')+1);
				enemys[i]=parseFloat(tp.substr(0, tp.indexOf('~')));
				tp=tp.substr(tp.indexOf('~')+1);
				taken[i]=parseFloat(tp.substr(0, tp.indexOf('~')));
				tp=tp.substr(tp.indexOf('~')+1);
				clans[i]=parseFloat(tp.substr(0, tp.indexOf('~')));
				tp=tp.substr(tp.indexOf('~')+1);
				if ((tp.indexOf('|')>tp.indexOf('~'))&&(tp.indexOf('~')!=-1)){
					clanver[i]=parseFloat(tp.substr(0, tp.indexOf('~')));
					tp=tp.substr(tp.indexOf('~')+1);
					clanassault[i]=parseFloat(tp.substr(0, tp.indexOf('|')));
				}else{
					clanver[i]=parseFloat(tp.substr(0, tp.indexOf('|')));

				};
				tp=tp.substr(tp.indexOf('|')+1);
				
			};
			continue;
		};
		if (j==17){
			isgps=parseFloat(param.substr(0,param.indexOf(':')));
			if ((isgps)&&(cursec!=selsec)){
				butp[0]=selsec;
				d_but_visible_func(0, true);
			}else{
				d_but_visible[0] = false;
				d_but_visible_func(0, false);
			};
		};
		if (j==18){
			randomnum=parseFloat(param.substr(0,param.indexOf(':')));
		};
		if (j==19+2){
			tacticalonly=param.substr(0,param.indexOf(':'));
			if (tacticalonly==''){
				tacticalonly=0;
			};

			param=param.substr(param.indexOf(':')+1);
			continue;
		};
		if (j==18+2){
			myclan=param.substr(0,param.indexOf(':'));
			if (myclan==0){myclan=-100;};
			param=param.substr(param.indexOf(':')+1);
			continue;
		};
		if (j==17+2){
			par=param.substr(0,param.indexOf(':'));
			param=param.substr(param.indexOf(':')+1);
			var n=Array("n","e","s","w");
			while(par.length>1){
				k=par.substr(0,par.indexOf('-'));
				par=par.substr(par.indexOf('-')+1);
			};

			continue;
		};

		if (j==11){
			filename=param.substr(0,param.indexOf(':'));
			param=param.substr(param.indexOf(':')+1);
			continue;
		};
		if (j==12){
			ver=param.substr(0,param.indexOf(':'));
			param=param.substr(param.indexOf(':')+1);
			continue;
		};
		k=parseFloat(param.substr(0,param.indexOf(':')));
		param=param.substr(param.indexOf(':')+1);
		if (j==14){
			s1=k;
			continue;
		};
		if (j==15){
			nowtime=k;
			continue;
		};
		if (j==16){
			finishtime=k;
			nowtime=finishtime-nowtime;
			if (finishtime>0){
				s2=cursec;
				moving=true;
				map_layer_name = 'oldmap_move'+add_data;
			};
			continue;
		};
		if (j==13){
			naim_type = 'none';
			if (k==-1){
				naim_type = 'finished';
			};
			if (k>0){
				naim_type = 'fight';
				naim_sector = k;
			};
			continue;
		};
		if (j==6){
			param=param.substr(param.indexOf(':')+1);
		};
		if (j==1){
			cursec=k;
			selsec=k;
		}else{
			if (j==2){
				selsec=k;
			}else{
				butp[j-2]=k;
				if (k==0){
					d_but_visible[j-2] = false;
					d_but_visible_func(j-2, false);
				};
			};
		};
	};
	if (!moving){
		document.getElementById('sec_'+selsec).style.display = 'block';
		document.getElementById('sec_'+selsec).classList.add('map_sector_selected');
		var els = document.getElementById("map_texts");
		if (els){
			els.classList.remove('toolbar_Topcenter');
			els.classList.add('toolbar_BottomLeft');
			els.classList.add('toolbar_BottomLeft_sdvig');
		};
	};
	for (i=1;i<=kolsector;i++){

						if (closed[i]){
						}else{
							ay=Math.max(1.1, 3-Math.max(0,(23-19)/2.64));
						};
	};



	if (moving){
		cursor_visible = false;
		hide_button('map_navigator');
		hide_button('task_button');
		hide_button('camp_button');
		prepmoving();


	}else{
		captr=scaptr[cursec];
		if (lang==1) captr='';
		capt=scapte[cursec];
		capto=scaptb[cursec];
	};
};


// Cache functions

var hwm_cache_array = Array();
var hwm_map_cache_loader = new XMLHttpRequest();
hwm_map_cache_loader.addEventListener('load', hwm_map_cache_loader_data_onLoad, false);
hwm_map_cache_loader.addEventListener('error', hwm_map_cache_loader_data_onError, false);
hwm_map_cache_loader.addEventListener('abort', hwm_map_cache_loader_data_onError, false);
hwm_map_cache_loader.loading = false;
var hwm_cache_maxTries = 100;
var hwm_cache_cur_load = 0;


function hwm_map_cache_getCookie(name)
{
   var matches = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"));
   var a = matches ? decodeURIComponent(matches[1]) : undefined;
   if (a=='false')
   {
      a=0;
   }
   return a;
}

function hwm_map_cache_setCookies(name, val, exp_time)
{
           var now = new Date();
           var time = now.getTime();
           if (!exp_time){
               var expireTime = time + 10000*36000*1000;
           }else{
               var expireTime = time + exp_time;
           };
           now.setTime(expireTime);
           document.cookie = name+'='+val+';expires='+now.toGMTString()+';';
}

function hwm_map_cache_loader_data_onLoad()
{
   this.loading = false;
   if (this.status == 200)
   {
      var src = this.response;
      if (src.substr(0, 3) == 'OK:')
      {
         src = src.substr(3);
         hwm_cache_array = src.split('|');
         hwm_cache_cur_load = 0;
         start_load_cache();
      }
   }
}

function hwm_map_cache_loader_data_onError()
{
   this.loading = false;
}

function hwm_map_load_cache_files(path)
{
	hwm_map_cache_loader.loading = true;
	hwm_map_cache_loader.open('GET', path, true);
	hwm_map_cache_loader.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	hwm_map_cache_loader.send(null);
}

function hwm_cache_loadScript(path, numTries)
{
   var doc = document,
      pathStripped = path.replace(/^(css|img)!/, ''),
      isCss,
      e;

   numTries = numTries || 0;
 
   if ((path.indexOf('.css')>0)||(path.indexOf('.js')>0))
   {
      isCss = true;
    // css
      e = doc.createElement('link');
//    e.rel = 'stylesheet';
//    e.rel = 'prefetch';
      if (path.indexOf('.js')>0) e.as = 'script'; else e.as = 'style';
      e.rel = 'preload';
      e.href = pathStripped; //.replace(/^css!/, '');  // remove "css!" prefix
   }
   else if ((path.indexOf('.js')==-1)&&(path.indexOf('.php')==-1))
   {
    // image
    e = doc.createElement('img');
    e.src = pathStripped;    
   }
   else
   {
    // javascript
      e = doc.createElement('script');
      e.src = path;
      e.async = true;
   }

   e.link = path;
   e.loaded = false;
   e.numTries = numTries;
   doc.head.appendChild(e);
   e.onload = e.onerror = function (ev)
   {
      var result = ev.type[0];
      if (result == 'e')
      {
          console.log('error', this, ev , this.link);
		  // increment counter
		  this.numTries += 1;
		  this.loaded = true;
		  // exit function and try again
		  if (numTries < hwm_cache_maxTries) {
			var time_out = 1000;
			setTimeout(hwm_cache_loadScript, time_out, this.link, this.numTries);
			if ((this !== null)&&(this.parentNode !== null)) this.parentNode.removeChild(this);
			return false;
		  };
      }
      this.loaded = true;
      hwm_cache_load_next();
   }
}

function start_load_cache()
{
   var cache_load_count = 5;
   for (var b=1;b<=cache_load_count;b++)
   {
      hwm_cache_load_next();
   }
}

function hwm_cache_load_next()
{
   if (hwm_cache_cur_load<hwm_cache_array.length)
   {
      if (hwm_cache_array[hwm_cache_cur_load]!='') hwm_cache_loadScript(hwm_cache_array[hwm_cache_cur_load], 0);
   }
   hwm_cache_cur_load++;
}

function hwm_map_check_map_pre_cache()
{
   var cook = hwm_map_cache_getCookie('map_cache');
   if (cook != 1)
   {
      hwm_map_load_cache_files('hwm_cache_list.php?step=4&race='+PL_JS_RACE_ID);
      hwm_map_cache_setCookies('map_cache', 1, 24*60*60*1000);
   }
}

function hwm_map_check_map_pre_cache_start()
{
   window.onload = function()
   {
      hwm_map_check_map_pre_cache();
   }
}

function hwm_map_js_hunt_hide_buttons(ev, hide_other)
{
   var hide = false;
   var el = null;
   for (var i = 0; i < 36; ++i)
   {
      if (el = document.getElementById('hunt_but_'+i))
      {
         hide = true;
         if (!hide_other && el.getAttribute('other_button') == 1) hide = false;

         if (hide) el.classList.add('home_disabled');
      }
   }
  
   if (typeof hide_hwm_hint === 'function' && ev) hide_hwm_hint(ev, true);
}

////

function canvas_map()
{
   var stage_width = 460;
   var stage_height = 460;
      
   Konva.pixelRatio = 2;
   if (typeof stage === 'undefined') stage = {};
   stage[map_id] = new Konva.Stage({
		  container: map_container,
		  width: stage_width,
		  height: stage_height
	});
   var layer = new Konva.Layer({hitGraphEnabled : true, listening: false});
   stage[map_id].layer = layer;
   stage[map_id].add(layer);
   var gr = new Konva.Group({hitGraphEnabled : true, listening: true});
   stage[map_id].sectors = gr;
   stage[map_id].layer.add(gr);

   min_z = 1;
   konva_secs = Array();
   sec_image_link = Array();
   konva_secs[1] = document.getElementById('sec_img_1');
   var img_temp = new Konva.Image({x: 141.47, y: 137.71, image: konva_secs[1], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 78, height: 82});
   img_temp.t_id = 'sec_'+1;
   img_temp.sec_link = 1;
   sec_image_link[1] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[2] = document.getElementById('sec_img_2');
   var img_temp = new Konva.Image({x: 190.35, y: 136.77, image: konva_secs[2], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 92, height: 89});
   img_temp.t_id = 'sec_'+2;
   img_temp.sec_link = 2;
   sec_image_link[2] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[3] = document.getElementById('sec_img_3');
   var img_temp = new Konva.Image({x: 140.06, y: 76.61, image: konva_secs[3], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 92.5, height: 91});
   img_temp.t_id = 'sec_'+3;
   img_temp.sec_link = 3;
   sec_image_link[3] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[4] = document.getElementById('sec_img_4');
   var img_temp = new Konva.Image({x: 205.39, y: 75.2, image: konva_secs[4], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 75.5, height: 93});
   img_temp.t_id = 'sec_'+4;
   img_temp.sec_link = 4;
   sec_image_link[4] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[5] = document.getElementById('sec_img_5');
   var img_temp = new Konva.Image({x: 139.12, y: 208.68, image: konva_secs[5], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 55, height: 86});
   img_temp.t_id = 'sec_'+5;
   img_temp.sec_link = 5;
   sec_image_link[5] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[6] = document.getElementById('sec_img_6');
   var img_temp = new Konva.Image({x: 140.53, y: 15.51, image: konva_secs[6], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 87, height: 98.5});
   img_temp.t_id = 'sec_'+6;
   img_temp.sec_link = 6;
   sec_image_link[6] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[7] = document.getElementById('sec_img_7');
   var img_temp = new Konva.Image({x: 75.2, y: 218.55, image: konva_secs[7], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 88, height: 66});
   img_temp.t_id = 'sec_'+7;
   img_temp.sec_link = 7;
   sec_image_link[7] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[8] = document.getElementById('sec_img_8');
   var img_temp = new Konva.Image({x: 84.13, y: 131.6, image: konva_secs[8], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 79, height: 104});
   img_temp.t_id = 'sec_'+8;
   img_temp.sec_link = 8;
   sec_image_link[8] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[9] = document.getElementById('sec_img_9');
   var img_temp = new Konva.Image({x: 78.49, y: 22.09, image: konva_secs[9], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 78, height: 89});
   img_temp.t_id = 'sec_'+9;
   img_temp.sec_link = 9;
   sec_image_link[9] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[10] = document.getElementById('sec_img_10');
   var img_temp = new Konva.Image({x: 142.41, y: 258.97, image: konva_secs[10], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 72, height: 82});
   img_temp.t_id = 'sec_'+10;
   img_temp.sec_link = 10;
   sec_image_link[10] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[11] = document.getElementById('sec_img_11');
   var img_temp = new Konva.Image({x: 183.77, y: 210.09, image: konva_secs[11], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 78.5, height: 70.5});
   img_temp.t_id = 'sec_'+11;
   img_temp.sec_link = 11;
   sec_image_link[11] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[12] = document.getElementById('sec_img_12');
   var img_temp = new Konva.Image({x: 68.62, y: 77.08, image: konva_secs[12], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 88.5, height: 75.5});
   img_temp.t_id = 'sec_'+12;
   img_temp.sec_link = 12;
   sec_image_link[12] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[13] = document.getElementById('sec_img_13');
   var img_temp = new Konva.Image({x: 2.82, y: 85.54, image: konva_secs[13], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 92, height: 83.5});
   img_temp.t_id = 'sec_'+13;
   img_temp.sec_link = 13;
   sec_image_link[13] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[14] = document.getElementById('sec_img_14');
   var img_temp = new Konva.Image({x: 242.52, y: 119.38, image: konva_secs[14], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 112.5, height: 110});
   img_temp.t_id = 'sec_'+14;
   img_temp.sec_link = 14;
   sec_image_link[14] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[15] = document.getElementById('sec_img_15');
   var img_temp = new Konva.Image({x: 261.32, y: 64.86, image: konva_secs[15], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 93, height: 76});
   img_temp.t_id = 'sec_'+15;
   img_temp.sec_link = 15;
   sec_image_link[15] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[16] = document.getElementById('sec_img_16');
   var img_temp = new Konva.Image({x: 265.08, y: 11.28, image: konva_secs[16], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 92, height: 72});
   img_temp.t_id = 'sec_'+16;
   img_temp.sec_link = 16;
   sec_image_link[16] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[17] = document.getElementById('sec_img_17');
   var img_temp = new Konva.Image({x: 319.13, y: 118.44, image: konva_secs[17], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 108, height: 85});
   img_temp.t_id = 'sec_'+17;
   img_temp.sec_link = 17;
   sec_image_link[17] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[18] = document.getElementById('sec_img_18');
   var img_temp = new Konva.Image({x: 330.41, y: 57.34, image: konva_secs[18], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 87, height: 80});
   img_temp.t_id = 'sec_'+18;
   img_temp.sec_link = 18;
   sec_image_link[18] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[19] = document.getElementById('sec_img_19');
   var img_temp = new Konva.Image({x: 202.57, y: 256.15, image: konva_secs[19], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 68, height: 94.5});
   img_temp.t_id = 'sec_'+19;
   img_temp.sec_link = 19;
   sec_image_link[19] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[20] = document.getElementById('sec_img_20');
   var img_temp = new Konva.Image({x: 180.48, y: 334.17, image: konva_secs[20], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 81.5, height: 72.5});
   img_temp.t_id = 'sec_'+20;
   img_temp.sec_link = 20;
   sec_image_link[20] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[21] = document.getElementById('sec_img_21');
   var img_temp = new Konva.Image({x: 240.64, y: 326.65, image: konva_secs[21], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 74.5, height: 79});
   img_temp.t_id = 'sec_'+21;
   img_temp.sec_link = 21;
   sec_image_link[21] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[22] = document.getElementById('sec_img_22');
   var img_temp = new Konva.Image({x: 235.47, y: 392.45, image: konva_secs[22], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 89.5, height: 76.5});
   img_temp.t_id = 'sec_'+22;
   img_temp.sec_link = 22;
   sec_image_link[22] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[23] = document.getElementById('sec_img_23');
   var img_temp = new Konva.Image({x: 7.52, y: 25.85, image: konva_secs[23], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 97, height: 77});
   img_temp.t_id = 'sec_'+23;
   img_temp.sec_link = 23;
   sec_image_link[23] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[24] = document.getElementById('sec_img_24');
   var img_temp = new Konva.Image({x: 194.11, y: 4.7, image: konva_secs[24], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 87, height: 86});
   img_temp.t_id = 'sec_'+24;
   img_temp.sec_link = 24;
   sec_image_link[24] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[25] = document.getElementById('sec_img_25');
   var img_temp = new Konva.Image({x: 343.1, y: 249.1, image: konva_secs[25], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 97, height: 79});
   img_temp.t_id = 'sec_'+25;
   img_temp.sec_link = 25;
   sec_image_link[25] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[26] = document.getElementById('sec_img_26');
   var img_temp = new Konva.Image({x: 74.73, y: 273.54, image: konva_secs[26], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 94.5, height: 65});
   img_temp.t_id = 'sec_'+26;
   img_temp.sec_link = 26;
   sec_image_link[26] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   konva_secs[27] = document.getElementById('sec_img_27');
   var img_temp = new Konva.Image({x: 7.05, y: 155.57, image: konva_secs[27], hitGraphEnabled : true,opacity: 0,  visible: 1, listening: true, scaleX: 1, scaleY: 1, width: 92.5, height: 80.5});
   img_temp.t_id = 'sec_'+27;
   img_temp.sec_link = 27;
   sec_image_link[27] = img_temp;
   img_temp.cache({pixelRatio: 0.5});
   stage[map_id].sectors.add(img_temp);
   stage[map_id].sectors.draw();
}