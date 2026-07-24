var hwm_top_hint_timer;

function top_line_add_events_listeners()
{
	var i;

	var x_e = document.getElementsByClassName("mm_item_inside");
	for (i = 0; i < x_e.length; i++) {
	  x_e[i].addEventListener("touchstart", mm_item_hover);
	  x_e[i].addEventListener("mouseenter", mm_item_hover);
	  x_e[i].addEventListener("mouseleave", mm_item_hover);
	}

	var x_e = document.getElementsByClassName("sh_dd_container");
	for (i = 0; i < x_e.length; i++) {
	  x_e[i].addEventListener("mouseenter", container_hover);
	  x_e[i].addEventListener("mouseleave", container_hover);
	}

	for (i=0;i<=25;i++)
	{
	  var el = document.getElementById('hwm_topline_with_hint'+i);
	  if (el)
	  {
		  el.addEventListener("mouseenter", ResourceItem_hover);
		  el.addEventListener("mouseleave", ResourceItem_hover);
	  }
	}
	document.getElementById('hintBlock').addEventListener("mouseenter", hintBlock_hover);
}


function hintBlock_hover(e)
{
	event.stopPropagation();
}

function ResourceItem_hover(e)
{
	var ResourceLable = this.getAttribute('hwm_label');

	var hintBlock = document.getElementById('hintBlock');
	var visible = true;

	hwm_top_line_hide_all_exp_menu();


	if (e.type !='mouseenter')
	{
		hwm_toggle(hintBlock, false);
		var children = this.childNodes; 
		for (var i=0; i<children.length; i++) { 
		  var child = children[i]; 
		  if (child.className == 'sh_HMResAmount') { 
				hwm_toggle(child, false);
		  } 
		}

		if (hwm_top_hint_timer)	clearTimeout(hwm_top_hint_timer);

		return false;
	}

	hintBlock._child = this.childNodes;
	hintBlock._this = this;

	hintBlock.innerHTML = '<div>'+ResourceLable+'</div>'; 
	var offset = getCoords(this);
	var height = this.offsetHeight;
	hintBlock.style.left = Math.round(offset.left + (Math.round(this.offsetWidth / 2 + 10)))+'px';
	hintBlock.style.top = Math.round(offset.top + (Math.round(height)))+'px';

	if (hwm_top_hint_timer)	clearTimeout(hwm_top_hint_timer);
	hwm_top_hint_timer = setTimeout(hwm_top_show_hint_on_timer, 400);

	return false;
};


function hwm_top_show_hint_on_timer()
{
	var hintBlock = document.getElementById('hintBlock');

	hwm_toggle(hintBlock, true);

	var children = hintBlock._child;
	for (var i=0; i<children.length; i++) { 
	  var child = children[i]; 
	  if (child.className == 'sh_HMResAmount') { 
			hwm_toggle(child, true);
	  } 
	} 
	var offset = getCoords(hintBlock._this);
	var height = hintBlock._this.offsetHeight;
	hintBlock.style.left = Math.round(offset.left + (Math.round(hintBlock._this.offsetWidth / 2 + 10)))+'px';
	hintBlock.style.top = Math.round(offset.top + (Math.round(height)))+'px';

}


function getCoords(elem) // crossbrowser version
{ 
    var box = elem.getBoundingClientRect();

    var body = document.body;
    var docEl = document.documentElement;

    var scrollTop = window.pageYOffset || docEl.scrollTop || body.scrollTop;
    var scrollLeft = window.pageXOffset || docEl.scrollLeft || body.scrollLeft;

    var clientTop = docEl.clientTop || body.clientTop || 0;
    var clientLeft = docEl.clientLeft || body.clientLeft || 0;

    var top  = box.top +  scrollTop - clientTop;
    var left = box.left + scrollLeft - clientLeft;

    return { top: Math.round(top), left: Math.round(left) };
}

function mm_item_hover(e)
{
	var item = this.id;
	var popup = document.getElementById(this.id + '_expandable');
	if (!popup) return;
	var visible = false;
    hwm_top_line_hide_all_exp_menu();

	if ((e.type=='mouseenter')||(e.type=='touchstart')){
		visible = true;
	};
	hwm_toggle(popup, visible);
	if (!visible)
	{
		return 0;
	}
	var offset = getCoords(this);

	var height = this.offsetHeight;
	popup.style.left = Math.round(offset.left + (Math.round(this.offsetWidth / 2 - popup.offsetWidth / 2)))+'px';
	popup.style.top = Math.round(offset.top + (Math.round(height)))+'px';

	return false;
};


function hwm_toggle(e, visible)
{
	if ((e.style.display!='none')&&(!visible))
	{
		e.toggle_display = e.style.display;
		e.style.display = 'none';
	}
	else if (visible)
	{
		if (typeof e.toggle_display !== 'undefined'){
				e.style.display = e.toggle_display;
			}else{
				e.style.display = '';
		}
	}
}

function hwm_top_line_hide_all_exp_menu()
{
	var el = document.getElementsByClassName("sh_dd_container");
	for (var i = 0; i < el.length; i++) {
		el[i].style.display = 'none';
    }
}


function container_hover(e){
	var visible = false;
	if (e.type=='mouseenter')
	{
//		hwm_top_line_hide_all_exp_menu();
		visible = true;
	}
	hwm_toggle(this, visible);
	e.stopPropagation();
	return false;
};

function top_line_draw_canvas_heart(heart_param, max_heart_param, time_heart_param)
{
   if (window.hwm_top_line_heart_timer_id) clearTimeout(window.hwm_top_line_heart_timer_id);

   time_heart_param = Number(time_heart_param);
   if (!isFinite(time_heart_param) || time_heart_param <= 0) time_heart_param = window.hwm_top_line_heart_time || 1;
   window.hwm_top_line_heart_time = time_heart_param;

   var heart_timer_key = (new Date()).getTime() + Math.random();
   window.hwm_top_line_heart_timer_key = heart_timer_key;

   var heart_image1path = top_line_im_server_url+"i/health_n_empty.png";
   var heart_image2path = top_line_im_server_url+"i/health_n.png";

   var heart=heart_param;
   var max_heart=max_heart_param;
   var time_heart=time_heart_param;


   function draw()
   {
        context.setTransform(1, 0, 0, 1, 0, 0);
        context.scale(1, 1);
        context.shadowOffsetX = 0;
        context.shadowOffsetY = 0;
        context.shadowBlur = 0;

         context.clearRect(0,0, h_width, h_height);
            
        context.translate(h_width/2, h_height/2);
        context.scale(siz/100, siz/100);

        context.drawImage(image2, -h_width/2, -h_height/2);
         

         context.clearRect(-h_width/2, -h_height/2+5, h_width, (100-perc)*25/100*2);
        

        context.drawImage(image1, -h_width/2, -h_height/2);      
        

         context.setTransform(1, 0, 0, 1, 0, 0);
         context.scale(1, 1);

   }

   function run_top_line_heart_timer()
   {
        if (window.hwm_top_line_heart_timer_key != heart_timer_key) return;

        var d = new Date();
        var curTime = d.getTime();
        perc = Math.min(100, Math.floor(heart+100/time_heart*((curTime-startTime)/1000)));

        if (perc != perc_old)
        {
           if (document.getElementById("health_amount")) document.getElementById("health_amount").innerHTML = perc;
           if (document.getElementById('homecss_hp'))    document.getElementById('homecss_hp').innerHTML = perc+'%';
           var els = document.getElementsByName('homecss_hp_barprogress');
           if (els && els.length > 0) els[0].style.width = perc+'%';

           perc_old = perc;
        }

        if (perc==100)
        {
           siz-=plus;
           if (siz>90){plus=plus*1.03;}else{plus=-2;};
           if (siz>100){plus=0.4;siz=100;};
        }

        if (draw_ok) draw();
        window.hwm_top_line_heart_timer_id = window.setTimeout(run_top_line_heart_timer, timer_interval);
   }

   function check_all_load()
   {
      var i = 0;
      var cnt = 0;
      for (i=1;i<=image_cnt;i++)
      {
         if (image_loader[i]>0) cnt++;
         if (cnt==image_cnt)
         {
            draw_ok = true;
            draw();
         }
      }
   }

   var d = new Date();
   var startTime = d.getTime();
   var h_width = 64;
   var h_height = 64;
   var theCanvas = document.getElementById("heart");
   var txt_vis = false;
   var getTimer = 0;
   var timer_interval = 40;

   if (!theCanvas || !theCanvas.getContext)  return;
   var context = theCanvas.getContext("2d");
   var image1 = new Image();
   var image2 = new Image();
   var image_loader = Array();
   var image_cnt = 2;
   var siz = 100;
   var plus = 0.4;
   var draw_ok = false;
   var perc = 0;

   image1.onload = function()
   {
      image_loader[1] = 1;
      check_all_load();
   }

   image2.onload = function()
   {	   
      image_loader[2] = 1;
      check_all_load();
   }

   image1.src = heart_image1path;
   image2.src = heart_image2path;
   var perc_old = -1;

   run_top_line_heart_timer(); 
}

function hwm_top_line_open_radio(width, height)
{
   window.open('https://gvdplayer.com/player.html', "hwmradio", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no, resizable=yes,width="+width+",height="+height+",top=100,left=100");
}

function hwm_top_line_goto_url(url)
{
	location.href=url;
	window.event.stopPropagation();
}
