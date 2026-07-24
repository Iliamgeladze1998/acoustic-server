var need_redraw_ground = false;
var enginep_loaded = true;
var currentTip = 0;
var soundeff = 0;
var soundeff = 0;
var sounds = Array();
var shadow_pixel_ratio = 0.5;
var old_shadow = true;
var zamena = '';
var mycounter = 1;
var mqc = Array();
var mqc_n = Array('x', 'y', 'sdx', 'sdy', 'mxscale', 'myscale', 'scale', 'xs', 'ys', 'anim_scale', 'glow', 'atlas');
var subpath_reserve = 'https://im.heroeswm.ru/i/';
var loading_stack = Array();
var check_load_cnt = 0;
var inited_tweaker = false;
if (typeof portraits_dir === 'undefined') var portraits_dir = "portraits/";
if (typeof bomb_die === 'undefined') var bomb_die = false;
var portraits_default = "portraits/";

if (typeof get_portraits_dir === 'undefined')
{
   function get_portraits_dir(filename){
      if (filename=='swordmanani'){
         return portraits_default;
      }else{
         return portraits_dir;
      };
   };
};


var error_sender = new XMLHttpRequest();
error_sender.loading = false;

setInterval(function () {	check_load();}, 1000);

if ((typeof postloader === 'undefined')&&(typeof my_alert !== "function")){
	var postloader = new XMLHttpRequest();
	postloader.addEventListener('load', postloader_data_onLoad, false);
	postloader.addEventListener('error', postloader_data_onError, false);
	postloader.addEventListener('abort', postloader_data_onError, false);      
	postloader.loading = false;

	function postloader_data_onLoad(){
		postloader.loading = false;
	};

	function postloader_data_onError(evt){
		this.loading = false;
	};

	function postloader_load(url, body){
			postloader.loading = true;
			postloader.open('POST', url, true);
			postloader.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			postloader.onreadystatechange = function() {};
			postloader.send(body);
	};


	function my_alert(s){
		if (typeof warid=='undefined')
		{
			warid = -1;
		}
		if (typeof lastturn=='undefined')
		{
			lastturn = 0;
		}
		var php_out = 'warid='+warid+'&lastturn='+lastturn+'&tip='+currentTip+'&error='+s;
		postloader_load('save_html5_error.php', encodeURI(php_out));
		alert(warid+' '+lastturn+' '+s);
	};
};


for (var i=0;i<mqc_n.length;i++)
{
	mqc[mqc_n[i]] = i;
}

var nda = Array();
var nda_n = Array('curframe', 'lastframe', '_visible', '_alpha', '_xscale', '_yscale', 'matrix', 'matrix2', 'no_shadow');
for (var i=0;i<nda_n.length;i++)
{
	nda[nda_n[i]] = i;
}



var magic = Array();
var initialized = false;
var showed = false;
var animspeed = 1;
var image_obj = Array();
var pixel_ratio_cache = 1;

function hwm_je2d_get_battle_load_token(){
    if (typeof window === 'undefined') return null;
    if (typeof window.HWM_JE2D_BATTLE_LOAD_TOKEN === 'undefined') return null;
    return window.HWM_JE2D_BATTLE_LOAD_TOKEN;
}

function hwm_je2d_mark_battle_loader(obj){
    var token = hwm_je2d_get_battle_load_token();
    if (token === null || !obj) return;
    obj.hwm_je2d_battle_load_token = token;
}

function hwm_je2d_is_battle_loader_cancelled(obj){
    if (obj && obj.hwm_je2d_battle_load_cancelled) return true;
    var token = hwm_je2d_get_battle_load_token();
    return token !== null && obj && typeof obj.hwm_je2d_battle_load_token !== 'undefined' && obj.hwm_je2d_battle_load_token !== token;
}

	Object.size = function(obj) {
		var size = 0, key;
		for (key in obj) {
			if (obj.hasOwnProperty(key)) size++;
		}
		return size;
	};

var dynamic = Array();


function check_custom_images_loaded(unit) {
    if (!unit.custom_load_counter) unit.custom_load_counter = 0;
    unit.custom_load_counter--;

    if (unit.custom_load_counter <= 0) {
        set_visible(unit.layer, 1);

        unit.need_refresh = true; 
        unit.need_cache = 0;
        if (typeof unit.set_data === 'function') {
            try { unit.set_data(true); } catch(e) {}
        }
    }
}

function custom_replacement_has_filename(config) {
    if ((!config)||(typeof config.filename === 'undefined')||(config.filename === null)||(config.filename == '')||(config.filename == '.png')) return false;
    return String(config.filename).replace(/^\s+|\s+$/g, '') !== '';
}

var custom_image_color_codes = ['clr', 'clg', 'clb', 'car', 'cab', 'cag'];
var custom_image_color_defaults = { clr: 0, clg: 0, clb: 0, car: 100, cab: 100, cag: 100 };

function custom_image_color_number(value, def) {
    var n = parseFloat(value);
    return isNaN(n) ? def : n;
}

function custom_image_color_value(config, key) {
    if (!config || typeof config !== 'object') return custom_image_color_defaults[key];
    return custom_image_color_number(config[key], custom_image_color_defaults[key]);
}

function custom_image_color_has_filter(config) {
    if (!config || typeof config !== 'object') return false;
    for (var i = 0; i < custom_image_color_codes.length; i++) {
        var key = custom_image_color_codes[i];
        if (custom_image_color_value(config, key) != custom_image_color_defaults[key]) return true;
    }
    return false;
}

function custom_image_color_signature(config) {
    if (!custom_image_color_has_filter(config)) return '';
    var out = [];
    for (var i = 0; i < custom_image_color_codes.length; i++) {
        var key = custom_image_color_codes[i];
        out.push(key + '=' + custom_image_color_value(config, key));
    }
    return out.join(',');
}

function custom_image_clamp_color_offset(value) {
    value = custom_image_color_number(value, 0);
    return Math.max(-255, Math.min(255, value));
}

function custom_image_get_filters(where) {
    if (!where) return [];
    try {
        if (where.filter_array && where.filter_array.length) return where.filter_array.slice(0);
    } catch(e) {}
    try {
        if (where.konva_obj && where.filters) return (where.filters() || []).slice(0);
    } catch(e) {}
    try {
        if (where.pixi_obj && where.filters && where.filters.length) return where.filters.slice(0);
    } catch(e) {}
    return [];
}

function custom_image_strip_color_filters(filters) {
    var out = [];
    if (!filters) return out;
    for (var i = 0; i < filters.length; i++) {
        if (filters[i] && filters[i]._custom_image_color_filter) continue;
        out.push(filters[i]);
    }
    return out;
}

function custom_image_make_pixi_color_filter(config) {
    var f = new PIXI.filters.ColorMatrixFilter();
    f._custom_image_color_filter = true;
    f.matrix = [
        custom_image_color_value(config, 'car') / 100, 0, 0, 0, custom_image_color_value(config, 'clr') / 255,
        0, custom_image_color_value(config, 'cag') / 100, 0, 0, custom_image_color_value(config, 'clg') / 255,
        0, 0, custom_image_color_value(config, 'cab') / 100, 0, custom_image_color_value(config, 'clb') / 255,
        0, 0, 0, 1, 0
    ];
    return f;
}

function custom_image_get_konva_color_base(where) {
    if (!where._custom_image_color_base) {
        where._custom_image_color_base = {
            red: (typeof where.red === 'function' && !isNaN(where.red())) ? where.red() : 0,
            green: (typeof where.green === 'function' && !isNaN(where.green())) ? where.green() : 0,
            blue: (typeof where.blue === 'function' && !isNaN(where.blue())) ? where.blue() : 0
        };
    }
    return where._custom_image_color_base;
}

function custom_image_apply_color_filter(where, config) {
    if (!where || !custom_image_color_has_filter(config)) return 0;

    if (where.konva_obj || currentTip == 0) {
        var filters = custom_image_get_filters(where);
        if (filters.indexOf(Konva.Filters.RGB) < 0) filters.push(Konva.Filters.RGB);
        set_filter(where, filters);

        var colorBase = custom_image_get_konva_color_base(where);
        var redBase = colorBase.red;
        var greenBase = colorBase.green;
        var blueBase = colorBase.blue;

        if (typeof where.red === 'function') where.red(custom_image_clamp_color_offset(redBase + (custom_image_color_value(config, 'car') - 100) * 1.28 + custom_image_color_value(config, 'clr')));
        if (typeof where.green === 'function') where.green(custom_image_clamp_color_offset(greenBase + (custom_image_color_value(config, 'cag') - 100) * 1.28 + custom_image_color_value(config, 'clg')));
        if (typeof where.blue === 'function') where.blue(custom_image_clamp_color_offset(blueBase + (custom_image_color_value(config, 'cab') - 100) * 1.28 + custom_image_color_value(config, 'clb')));

        try { if (typeof where.clearCache === 'function') where.clearCache(); } catch(e) {}
        try { if (typeof where.cache === 'function') where.cache({pixelRatio: 1}); } catch(e) {}
        return 1;
    }

    if (where.pixi_obj || currentTip == 1) {
        var pixiFilters = custom_image_strip_color_filters(custom_image_get_filters(where));
        pixiFilters.push(custom_image_make_pixi_color_filter(config));
        set_filter(where, pixiFilters);
        return 1;
    }

    return 0;
}

function custom_image_apply_part_color_filter(unit, part_id, where) {
    if ((!unit)||(!unit.custom_replacements_map)||(!unit.custom_replacements_map[part_id])) return 0;
    var config = unit.custom_replacements_map[part_id];
    if (!custom_image_color_has_filter(config)) return 0;
    return custom_image_apply_color_filter(where, config);
}

function get_custom_portrait_filename(custom_image) {
    if ((!custom_image)||(!custom_image['portrait'])) return '';

    var cfg = custom_image['portrait'];
    if (typeof cfg === 'string') cfg = { filename: cfg };
    if (!custom_replacement_has_filename(cfg)) return '';

    var filename = String(cfg.filename).replace(/^\s+|\s+$/g, '');
    if (filename === '') return '';
    var has_extension = filename.indexOf('.') !== -1;
    filename = filename.replace(/(\.png)+$/i, '.png');
    if (filename.indexOf('.') === -1) filename += '.png';

    var dot_pos = filename.lastIndexOf('.');
    var basename = (dot_pos >= 0) ? filename.substr(0, dot_pos) : filename;
    var extension = (dot_pos >= 0) ? filename.substr(dot_pos) : '';
    if ((!has_extension)&&(!/p\d*$/i.test(basename))) basename += 'p';

    return basename + extension;
}


function load_custom_part_texture(sprite_obj, config, original_params, parent_unit, apply_color) {
    var img_url = dcdn_path+'i/custom_objects/' + config.filename;
    var img = new Image();
    var finished = false;
    img.crossOrigin = 'Anonymous';

    function apply_custom_part_image(img) {
        var new_width = img.width;
        var new_height = img.height;

        if (currentTip == 0) { // Konva
            sprite_obj.image(img);
            sprite_obj.width(new_width);
            sprite_obj.height(new_height);
            sprite_obj.crop({x: 0, y: 0, width: new_width, height: new_height});
            sprite_obj.offset({ x: 0, y: 0 });

        } else if (currentTip == 1) { // PIXI
            var newBase = new PIXI.BaseTexture(img);
            var newTex = new PIXI.Texture(newBase);
            sprite_obj.texture = newTex;

            if(sprite_obj.texture.frame) {
                 sprite_obj.texture.frame = new PIXI.Rectangle(0, 0, new_width, new_height);
            }

            sprite_obj.anchor.set(0, 0); 
            sprite_obj.pivot.set(0, 0);
        }
        if (!sprite_obj.bomb_meta) sprite_obj.bomb_meta = {};
        sprite_obj.bomb_meta.image_obj = img;
        sprite_obj.bomb_meta.crop = {x: 0, y: 0, width: new_width, height: new_height};
        sprite_obj.bomb_meta.width = new_width;
        sprite_obj.bomb_meta.height = new_height;
        
        set_visible(sprite_obj, 1);
        if (apply_color !== false) custom_image_apply_color_filter(sprite_obj, config);
        
        if (parent_unit) check_custom_images_loaded(parent_unit);
    }

    function finish_custom_part_texture(ok) {
        if (finished) return;
        finished = true;

        if (ok) {
            apply_custom_part_image(img);
        } else if (parent_unit) {
            check_custom_images_loaded(parent_unit);
        }
    }

    hwm_je2d_mark_battle_loader(img);

    img.onload = function() {
        if (hwm_je2d_is_battle_loader_cancelled(this)) return false;
        finish_custom_part_texture(true);
    };

    img.onerror = function() {
        if (hwm_je2d_is_battle_loader_cancelled(this)) return false;
        finish_custom_part_texture(false);
    };

    img.src = img_url;
    if (img.complete) {
        setTimeout(function() {
            finish_custom_part_texture(!!(img.naturalWidth || img.width));
        }, 0);
    }
}

function get_custom_image_for_part(custom_image, statix_d, part_id) {
    if ((!custom_image)||(!statix_d)||(!statix_d[part_id])||(!statix_d[part_id].name)) return null;

    var candidates = {};

    function save_candidate(key) {
        if (!key) return;
        if (!candidates[key]) {
            candidates[key] = key.split('.').length;
        }
    }

    function clone_visited(visited) {
        var out = {};
        for (var key in visited) {
            if (visited.hasOwnProperty(key)) out[key] = visited[key];
        }
        return out;
    }

    function walk_chain(curr_id, suffix, visited) {
        curr_id = parseInt(curr_id, 10);
        if ((!curr_id)||(!statix_d[curr_id])||(visited[curr_id])) return;

        visited[curr_id] = true;

        var curr_def = statix_d[curr_id];
        if (!curr_def.name) return;

        var curr_key = suffix ? (curr_def.name + '.' + suffix) : curr_def.name;
        save_candidate(curr_key);

        if (curr_def.parent) {
            walk_chain(curr_def.parent, curr_key, clone_visited(visited));
        }
        if (curr_def.parent2) {
            walk_chain(curr_def.parent2, curr_key, clone_visited(visited));
        }
    }

    walk_chain(part_id, '', {});

    var best_key = '';
    var best_depth = -1;
    for (var candidate_key in candidates) {
        if ((!candidates.hasOwnProperty(candidate_key))||(!custom_image[candidate_key])) continue;
        if (candidates[candidate_key] > best_depth) {
            best_key = candidate_key;
            best_depth = candidates[candidate_key];
        }
    }

    if (best_key !== '') {
        var cfg = custom_image[best_key];
        if (typeof cfg === 'string') cfg = { filename: cfg };
        return cfg;
    }

    return null;
}

function animation_check(th){
			  if ((th.filename=='teleport')&&(th.doing=='magic')){
				var tel_len = anim[th.anim][th.doing].length-1;
				if (th.frame<=tel_len/2)
				{
					var alpha = 1-th.frame/(tel_len/2);
				}else{
					var alpha = (th.frame-(tel_len/2))/(tel_len/2);
				};
					
				set_Alpha(stage[war_scr].obj[th.to_obj].layer, alpha);
				
				if ((th.frame>13)&&(th.dest_x)){
				    th.x = th.dest_x;
				    th.y = th.dest_y;
					stage[war_scr].obj[th.to_obj].x = th.dest_x;
				    stage[war_scr].obj[th.to_obj].y = th.dest_y;
					th.dest_x = 0;
					th.z = th.get_obj_z(th.y, 1) - 0.35 + th.big*10;
				    th.set_pole_pos(th.x+th.big*0.5, th.y+th.big*0.5);
					stage[war_scr].obj[th.to_obj].set_pole_pos(stage[war_scr].obj[th.to_obj].x, stage[war_scr].obj[th.to_obj].y);

				};
				
			  };
};

function bomb_die_rand(seed){
	var value = Math.sin(seed*12.9898 + 78.233)*43758.5453;
	return value - Math.floor(value);
};

function get_bomb_die_state(th){
	if ((!th)||(!th.it_unit)||(th.magic_spell)||(th.statix)||(th.building)||(th.portal)||(th.stone)||(!th.n_data)||(th.skip_bomb_die == 1)||(typeof bomb_die === 'undefined')||(!bomb_die)){
		return false;
	};
	var is_alive = (th.nownumber > 0);
	if (th.gate == 1){
		is_alive = (th.nowhealth > 0);
	};
	if (is_alive){
		th.bomb_die_hold = 0;
		th.bomb_die_progress = 0;
		th.bomb_die_active = 0;
		th.bomb_die_seed = 0;
		return false;
	};
	if ((!th.doing)||(th.doing.substr(0, 3) != 'die')){
		if (th.bomb_die_hold != 1){
			return false;
		};
	};

	var center_x = 0;
	var center_y = 0;
	var max_dist = 0;
	var visible_cnt = 0;
	var i = 0;
	var matrix = 0;
	var dx = 0;
	var dy = 0;

	for (i=1;i<=th['statix_len'];i++){
		if ((!th.n_data[i])||(th.n_data[i][nda['_visible']]!=1)||(typeof th.n_data[i][nda['matrix2']] === 'undefined')){
			continue;
		};
		matrix = th.n_data[i][nda['matrix2']].m;
		center_x += matrix[4];
		center_y += matrix[5];
		visible_cnt++;
	};
	if (!visible_cnt){
		return false;
	};
	center_x /= visible_cnt;
	center_y /= visible_cnt;

	for (i=1;i<=th['statix_len'];i++){
		if ((!th.n_data[i])||(th.n_data[i][nda['_visible']]!=1)||(typeof th.n_data[i][nda['matrix2']] === 'undefined')){
			continue;
		};
		matrix = th.n_data[i][nda['matrix2']].m;
		dx = matrix[4] - center_x;
		dy = matrix[5] - center_y;
		max_dist = Math.max(max_dist, Math.pow(dx*dx + dy*dy, 0.5));
	};
	if (max_dist < 1){
		max_dist = 24;
	};

	if ((th.doing)&&(th.doing.substr(0, 3) == 'die')){
		if (th.bomb_die_active != 1){
			th.bomb_die_active = 1;
			th.bomb_die_seed = Math.floor(engine_rand()*1000000) + (th.obj_index + 1)*997;
		};
		var total_frames = 1;
		if ((typeof anim !== 'undefined')&&(typeof th.anim !== 'undefined')&&(anim[th.anim])&&(anim[th.anim]['die'])){
			total_frames = Math.max(1, anim[th.anim]['die'].length-2);
		};
		th.bomb_die_progress = Math.max(0, Math.min(1, th.frame/total_frames));
		th.bomb_die_progress = Math.pow(th.bomb_die_progress, 0.65);
	};
	if (!th.bomb_die_seed){
		th.bomb_die_seed = (th.obj_index + 1)*997;
	};

	center_x += (bomb_die_rand(th.bomb_die_seed + 23) - 0.5)*max_dist*0.5;
	center_y += (bomb_die_rand(th.bomb_die_seed + 29) - 0.5)*max_dist*0.35;

	return {
		center_x: center_x,
		center_y: center_y,
		max_dist: max_dist,
		radius: Math.max(16, Math.min(110, max_dist*0.7 + 14)),
		progress: Math.max(0, Math.min(1, th.bomb_die_progress || 1))
	};
};

function get_bomb_die_matrix(th, part_id, matrix2, bomb_state){
	if ((!bomb_state)||(!matrix2)){
		return matrix2;
	};

	var tx = matrix2.m[4];
	var ty = matrix2.m[5];
	var seed = (th.bomb_die_seed || ((th.obj_index + 1)*1009)) + part_id*131;
	var random_angle = bomb_die_rand(seed)*Math.PI*2;
	var dir_x = tx - bomb_state.center_x + Math.cos(random_angle)*bomb_state.max_dist*0.45;
	var dir_y = ty - bomb_state.center_y + Math.sin(random_angle)*bomb_state.max_dist*0.45 - bomb_state.max_dist*0.12;
	var dir_len = Math.pow(dir_x*dir_x + dir_y*dir_y, 0.5);
	if (dir_len < 0.001){
		dir_x = Math.cos(random_angle);
		dir_y = Math.sin(random_angle);
		dir_len = 1;
	};

	var scatter = bomb_state.radius*bomb_state.progress*(0.55 + bomb_die_rand(seed + 17)*0.75);
	var result = matrix2.copy();
	result.m[4] += dir_x/dir_len*scatter;
	result.m[5] += dir_y/dir_len*scatter;
	if (result.m[5] < ty){
		result.m[5] = ty;
	};
	if (bomb_die_rand(seed + 43) >= 0.5){
		var lift_curve = Math.sin(bomb_state.progress*Math.PI);
		if (lift_curve > 0){
			var bomb_lift_mult = 1;
			if ((typeof bomb_die_lift !== 'undefined')&&(bomb_die_lift > 0)){
				bomb_lift_mult = bomb_die_lift;
			};
			var lift_size = bomb_state.radius*(0.08 + bomb_die_rand(seed + 47)*0.14)*bomb_lift_mult;
			result.m[5] -= lift_size*lift_curve;
		};
	};
	var rotate_angle = (bomb_die_rand(seed + 31) - 0.5)*1.1*bomb_state.progress;
	if (Math.abs(rotate_angle) > 0.0001){
		var anchor_x = result.m[4];
		var anchor_y = result.m[5];
		result.m[4] = 0;
		result.m[5] = 0;
		result.rotate(rotate_angle);
		result.m[4] = anchor_x;
		result.m[5] = anchor_y;
	};
	return result;
};

function get_matrix_top(matrix, width, height){
	if ((!matrix)||(!matrix.point)){
		return 0;
	};
	var p1 = matrix.point({x: 0, y: 0});
	var p2 = matrix.point({x: width, y: 0});
	var p3 = matrix.point({x: 0, y: height});
	var p4 = matrix.point({x: width, y: height});
	return Math.min(p1.y, p2.y, p3.y, p4.y);
};

function clamp_matrix_top(matrix, width, height, min_top, clamp_progress){
	if ((!matrix)||(clamp_progress <= 0)){
		return matrix;
	};
	var current_top = get_matrix_top(matrix, width, height);
	if (current_top < min_top){
		matrix.m[5] += (min_top - current_top)*clamp_progress;
	};
	return matrix;
};

function get_bomb_parts_count(seed){
	var min_parts = 1;
	var max_parts = 1;
	if (typeof min_bomb_parts !== 'undefined'){
		min_parts = Math.max(1, Math.floor(min_bomb_parts));
	};
	if (typeof max_bomb_parts !== 'undefined'){
		max_parts = Math.max(1, Math.floor(max_bomb_parts));
	};
	if (max_parts < min_parts){
		var temp_parts = min_parts;
		min_parts = max_parts;
		max_parts = temp_parts;
	};
	return min_parts + Math.floor(bomb_die_rand(seed + 53)*(max_parts - min_parts + 1));
};

function split_bomb_rects(width, height, count, seed){
	var rects = Array({x: 0, y: 0, width: Math.max(1, Math.round(width)), height: Math.max(1, Math.round(height))});
	var step = 0;

	while (rects.length < count){
		var best_index = -1;
		var best_area = 0;
		for (var i=0;i<rects.length;i++){
			var rect = rects[i];
			if ((rect.width <= 1)&&(rect.height <= 1)){
				continue;
			};
			var area = rect.width*rect.height;
			if (area > best_area){
				best_area = area;
				best_index = i;
			};
		};
		if (best_index < 0){
			break;
		};

		var src = rects.splice(best_index, 1)[0];
		var split_vertical = false;
		if (src.width <= 1){
			split_vertical = false;
		}else if (src.height <= 1){
			split_vertical = true;
		}else{
			split_vertical = (bomb_die_rand(seed + step*17 + 1) < src.width/(src.width + src.height));
		};

		if (split_vertical){
			var cut_x = 1 + Math.floor(bomb_die_rand(seed + step*29 + 3)*(src.width - 1));
			rects.push({x: src.x, y: src.y, width: cut_x, height: src.height});
			rects.push({x: src.x + cut_x, y: src.y, width: src.width - cut_x, height: src.height});
		}else{
			var cut_y = 1 + Math.floor(bomb_die_rand(seed + step*31 + 5)*(src.height - 1));
			rects.push({x: src.x, y: src.y, width: src.width, height: cut_y});
			rects.push({x: src.x, y: src.y + cut_y, width: src.width, height: src.height - cut_y});
		};
		step++;
	};

	return rects;
};

function hide_bomb_fragments_for_part(th, part_id){
	if ((!th.bomb_fragments)||(!th.bomb_fragments[part_id])||(!th.bomb_fragments[part_id].sprites)){
		return 0;
	};
	for (var i=0;i<th.bomb_fragments[part_id].sprites.length;i++){
		set_visible(th.bomb_fragments[part_id].sprites[i], 0);
	};
	if (th.bomb_fragments[part_id].blood_sprites){
		for (var i=0;i<th.bomb_fragments[part_id].blood_sprites.length;i++){
			set_visible(th.bomb_fragments[part_id].blood_sprites[i], 0);
		};
	};
	return 1;
};

function get_bomb_meta_signature(meta){
	if ((!meta)||(!meta.crop)){
		return '';
	};
	var img_src = '';
	if ((meta.image_obj)&&(typeof meta.image_obj.src !== 'undefined')){
		img_src = meta.image_obj.src;
	};
	return img_src+'|'+meta.crop.x+'|'+meta.crop.y+'|'+meta.crop.width+'|'+meta.crop.height;
};

function get_bomb_sprite_z(source_img){
	var base_z = 0;
	if ((source_img)&&(source_img.konva_obj)&&(typeof source_img.zIndex === 'function')){
		base_z = source_img.zIndex();
	};
	if ((source_img)&&(source_img.pixi_obj)&&(typeof source_img.zIndex !== 'undefined')){
		base_z = source_img.zIndex;
	};
	return base_z;
};

function is_bomb_blood_part_name(part_name){
	if (!part_name){
		return false;
	};
	part_name = (part_name + '').toLowerCase();
	return ((part_name.indexOf('head') >= 0)||(part_name.indexOf('leg') >= 0)||(part_name.indexOf('hand') >= 0)||(part_name.indexOf('telo') >= 0)||(part_name.indexOf('puzo') >= 0)||(part_name.indexOf('tors') >= 0)||(part_name.indexOf('body') >= 0));
};

function can_show_bomb_blood_for_part(th, part_id){
	if ((!th)||(!th.alive)||(typeof is_bomb_blood === 'undefined')||(!is_bomb_blood)||(!th.statix_d)||(!th.statix_d[part_id])){
		return false;
	};
	return is_bomb_blood_part_name(th.statix_d[part_id]['name']);
};

function draw_bomb_blood_ellipse(ctx, cx, cy, radius_x, radius_y, rotate_angle){
	ctx.save();
	ctx.translate(cx, cy);
	ctx.rotate(rotate_angle);
	ctx.scale(Math.max(0.01, radius_x), Math.max(0.01, radius_y));
	ctx.beginPath();
	ctx.arc(0, 0, 1, 0, Math.PI*2, false);
	ctx.restore();
	ctx.fill();
};

function get_bomb_blood_signature(meta, rect, seed){
	if ((!meta)||(!rect)){
		return '';
	};
	return get_bomb_meta_signature(meta)+'|'+rect.x+'|'+rect.y+'|'+rect.width+'|'+rect.height+'|'+seed;
};

function make_bomb_blood_canvas(meta, rect, seed){
	var width = Math.max(1, Math.round(rect.width));
	var height = Math.max(1, Math.round(rect.height));
	var canvas = document.createElement('canvas');
	canvas.width = width;
	canvas.height = height;
	var ctx = canvas.getContext('2d');
	if (!ctx){
		return canvas;
	};

	var area = width*height;
	var spot_count = Math.max(2, Math.min(9, 2 + Math.round(area/320)));
	for (var i=0;i<spot_count;i++){
		var local_seed = seed + i*37;
		var cx = width*(0.12 + bomb_die_rand(local_seed + 1)*0.76);
		var cy = height*(0.12 + bomb_die_rand(local_seed + 3)*0.7);
		var radius_x = Math.max(1.4, width*(0.08 + bomb_die_rand(local_seed + 5)*0.18));
		var radius_y = Math.max(1.2, height*(0.08 + bomb_die_rand(local_seed + 7)*0.16));
		var rotate_angle = (bomb_die_rand(local_seed + 9) - 0.5)*Math.PI*1.4;
		var alpha = 0.42 + bomb_die_rand(local_seed + 11)*0.28;
		ctx.fillStyle = 'rgba(120, 0, 0, '+alpha+')';
		draw_bomb_blood_ellipse(ctx, cx, cy, radius_x, radius_y, rotate_angle);

		var splash_count = 1 + Math.floor(bomb_die_rand(local_seed + 13)*3);
		for (var j=0;j<splash_count;j++){
			var dot_seed = local_seed + j*19;
			var dot_x = cx + (bomb_die_rand(dot_seed + 15) - 0.5)*radius_x*2.4;
			var dot_y = cy + (bomb_die_rand(dot_seed + 17) - 0.5)*radius_y*2.2;
			var dot_radius = Math.max(0.8, Math.min(width, height)*(0.02 + bomb_die_rand(dot_seed + 21)*0.045));
			ctx.fillStyle = 'rgba(150, 0, 0, '+(0.34 + bomb_die_rand(dot_seed + 23)*0.34)+')';
			ctx.beginPath();
			ctx.arc(dot_x, dot_y, dot_radius, 0, Math.PI*2, false);
			ctx.fill();
		};
	};

	if ((height > 5)&&(width > 3)){
		var streak_count = 1 + Math.floor(bomb_die_rand(seed + 101)*3);
		ctx.lineCap = 'round';
		for (var i=0;i<streak_count;i++){
			var streak_seed = seed + 131 + i*29;
			var start_x = width*(0.18 + bomb_die_rand(streak_seed + 1)*0.64);
			var start_y = height*(0.12 + bomb_die_rand(streak_seed + 3)*0.45);
			var len_y = height*(0.16 + bomb_die_rand(streak_seed + 5)*0.38);
			var drift_x = (bomb_die_rand(streak_seed + 7) - 0.5)*width*0.14;
			ctx.strokeStyle = 'rgba(95, 0, 0, '+(0.3 + bomb_die_rand(streak_seed + 9)*0.28)+')';
			ctx.lineWidth = Math.max(1, Math.min(width, height)*(0.04 + bomb_die_rand(streak_seed + 11)*0.04));
			ctx.beginPath();
			ctx.moveTo(start_x, start_y);
			ctx.quadraticCurveTo(start_x + drift_x, start_y + len_y*0.45, start_x + drift_x*0.6, Math.min(height, start_y + len_y));
			ctx.stroke();
		};
	};

	if ((meta)&&(meta.image_obj)&&(meta.crop)){
		try{
			ctx.globalCompositeOperation = 'destination-in';
			ctx.drawImage(meta.image_obj, meta.crop.x + rect.x, meta.crop.y + rect.y, width, height, 0, 0, width, height);
			ctx.globalCompositeOperation = 'source-over';
		}catch(e){
			ctx.globalCompositeOperation = 'source-over';
		};
	};

	return canvas;
};

function set_bomb_blood_texture(sprite, image_obj, width, height){
	if ((!sprite)||(!image_obj)){
		return 0;
	};
	if (sprite.konva_obj){
		sprite.image(image_obj);
		sprite.width(width);
		sprite.height(height);
		sprite.offset({x: 0, y: 0});
	};
	if (sprite.pixi_obj){
		sprite.texture = PIXI.Texture.from(image_obj);
		sprite.width = width;
		sprite.height = height;
		sprite.anchor.set(0, 0);
		sprite.pivot.set(0, 0);
	};
	sprite.bomb_blood_width = width;
	sprite.bomb_blood_height = height;
	return 1;
};

function apply_bomb_overlay_matrix(sprite, matrix2, alpha, no_reset){
	if ((!sprite)||(!matrix2)){
		return 0;
	};
	if (currentTip == 0){
		sprite.visible(1);
		sprite.matrix = matrix2;
	}else if (currentTip == 1){
		var pm_overlay = new PIXI.Matrix;
		pm_overlay.a = matrix2.m[0];
		pm_overlay.b = matrix2.m[1];
		pm_overlay.c = matrix2.m[2];
		pm_overlay.d = matrix2.m[3];
		pm_overlay.tx = matrix2.m[4];
		pm_overlay.ty = matrix2.m[5];
		sprite.transform.setFromMatrix(pm_overlay);
		sprite.visible = 1;
	};
	set_Alpha(sprite, alpha);
	if (!no_reset) sprite._cache = {};
	return 1;
};

function hide_bomb_part_blood_for_part(th, part_id){
	if ((!th.bomb_blood_parts)||(!th.bomb_blood_parts[part_id])||(!th.bomb_blood_parts[part_id].sprite)){
		return 0;
	};
	set_visible(th.bomb_blood_parts[part_id].sprite, 0);
	return 1;
};

function ensure_bomb_part_blood_for_part(th, part_id, source_img){
	if ((!can_show_bomb_blood_for_part(th, part_id))||(!source_img)||(!source_img.bomb_meta)||(!source_img.bomb_meta.image_obj)||(!source_img.bomb_meta.crop)){
		hide_bomb_part_blood_for_part(th, part_id);
		return false;
	};
	if (!th.bomb_blood_parts){
		th.bomb_blood_parts = Array();
	};
	var meta = source_img.bomb_meta;
	var rect = {x: 0, y: 0, width: Math.max(1, Math.round(meta.crop.width)), height: Math.max(1, Math.round(meta.crop.height))};
	var seed = (th.bomb_die_seed || ((th.obj_index + 1)*1033)) + part_id*193;
	var signature = get_bomb_blood_signature(meta, rect, seed);
	var entry = th.bomb_blood_parts[part_id];
	if (!entry){
		entry = {sprite: 0, signature: ''};
		th.bomb_blood_parts[part_id] = entry;
	};
	if (!entry.sprite){
		var blood_image = make_bomb_blood_canvas(meta, rect, seed);
		entry.sprite = My_Image({
			x: 0,
			y: 0,
			image: blood_image,
			width: rect.width,
			height: rect.height,
			visible: 0,
			listening: false,
			perfectDrawEnabled: false
		});
		Make_addChild(th.unit, entry.sprite);
	};
	if (entry.signature != signature){
		set_bomb_blood_texture(entry.sprite, make_bomb_blood_canvas(meta, rect, seed), rect.width, rect.height);
		entry.signature = signature;
	};
	Make_setZIndex(entry.sprite, get_bomb_sprite_z(source_img) + 1);
	return entry;
};

function ensure_bomb_fragment_blood_for_part(th, part_id, source_img, entry, fragment_index, rect){
	if ((!entry)||(!source_img)||(!source_img.bomb_meta)||(!source_img.bomb_meta.image_obj)||(!source_img.bomb_meta.crop)){
		return false;
	};
	if (!can_show_bomb_blood_for_part(th, part_id)){
		if (entry.blood_sprites){
			for (var i=0;i<entry.blood_sprites.length;i++){
				set_visible(entry.blood_sprites[i], 0);
			};
		};
		return false;
	};
	if (!entry.blood_sprites){
		entry.blood_sprites = Array();
	};
	if (!entry.blood_signatures){
		entry.blood_signatures = Array();
	};
	var meta = source_img.bomb_meta;
	var seed = (th.bomb_die_seed || ((th.obj_index + 1)*1033)) + part_id*881 + fragment_index*53;
	var signature = get_bomb_blood_signature(meta, rect, seed);
	var sprite = entry.blood_sprites[fragment_index];
	if (!sprite){
		var blood_image = make_bomb_blood_canvas(meta, rect, seed);
		sprite = My_Image({
			x: 0,
			y: 0,
			image: blood_image,
			width: rect.width,
			height: rect.height,
			visible: 0,
			listening: false,
			perfectDrawEnabled: false
		});
		Make_addChild(th.unit, sprite);
		entry.blood_sprites[fragment_index] = sprite;
	};
	if (entry.blood_signatures[fragment_index] != signature){
		set_bomb_blood_texture(sprite, make_bomb_blood_canvas(meta, rect, seed), rect.width, rect.height);
		entry.blood_signatures[fragment_index] = signature;
	};
	Make_setZIndex(sprite, get_bomb_sprite_z(source_img) + entry.rects.length + fragment_index + 1);
	return sprite;
};

function set_bomb_fragment_texture(sprite, meta, rect){
	if ((!sprite)||(!meta)||(!meta.image_obj)||(!meta.crop)||(!rect)){
		return 0;
	};
	if (sprite.konva_obj){
		sprite.image(meta.image_obj);
		sprite.width(rect.width);
		sprite.height(rect.height);
		sprite.crop({
			x: meta.crop.x + rect.x,
			y: meta.crop.y + rect.y,
			width: rect.width,
			height: rect.height
		});
		sprite.offset({x: 0, y: 0});
	};
	if (sprite.pixi_obj){
		var source_texture = PIXI.Texture.from(meta.image_obj);
		var texture = new PIXI.Texture(source_texture.baseTexture);
		texture.frame = new PIXI.Rectangle(meta.crop.x + rect.x, meta.crop.y + rect.y, rect.width, rect.height);
		sprite.texture = texture;
		sprite.width = rect.width;
		sprite.height = rect.height;
		sprite.anchor.set(0, 0);
		sprite.pivot.set(0, 0);
	};
	sprite.bomb_rect = rect;
	sprite.bomb_meta_signature = get_bomb_meta_signature(meta);
	return 1;
};

function ensure_bomb_fragments_for_part(th, part_id, source_img){
	if ((!th)||(!source_img)||(!source_img.bomb_meta)||(!source_img.bomb_meta.image_obj)||(!source_img.bomb_meta.crop)){
		return false;
	};
	if (!th.bomb_fragments){
		th.bomb_fragments = Array();
	};

	var seed = (th.bomb_die_seed || ((th.obj_index + 1)*1009)) + part_id*787;
	var meta = source_img.bomb_meta;
	var width = Math.max(1, Math.round(meta.crop.width));
	var height = Math.max(1, Math.round(meta.crop.height));
	var part_count = get_bomb_parts_count(seed);
	var entry = th.bomb_fragments[part_id];
	if (!entry){
		entry = {count: part_count, sprites: Array(), rects: Array(), signature: ''};
		th.bomb_fragments[part_id] = entry;
	}
	entry.count = part_count;

	if ((part_count <= 1)||(width <= 1)||(height <= 1)){
		hide_bomb_fragments_for_part(th, part_id);
		return entry;
	};

	var signature = get_bomb_meta_signature(meta);
	if ((entry.signature != signature)||(entry.rects.length != part_count)||(entry.sprites.length != part_count)){
		entry.signature = signature;
		entry.rects = split_bomb_rects(width, height, part_count, seed);
	}
	var base_z = get_bomb_sprite_z(source_img);

	for (var i=0;i<entry.rects.length;i++){
		var rect = entry.rects[i];
		var sprite = entry.sprites[i];
		if (!sprite){
			sprite = My_Image({
				x: 0,
				y: 0,
				image: meta.image_obj,
				width: rect.width,
				height: rect.height,
				crop: {
					x: meta.crop.x + rect.x,
					y: meta.crop.y + rect.y,
					width: rect.width,
					height: rect.height
				},
				visible: 0,
				listening: false,
				perfectDrawEnabled: false
			});
			Make_addChild(th.unit, sprite);
			entry.sprites[i] = sprite;
		};
		set_bomb_fragment_texture(sprite, meta, rect);
		Make_setZIndex(sprite, base_z + i);
	}
	for (var i=entry.rects.length;i<entry.sprites.length;i++){
		set_visible(entry.sprites[i], 0);
	}
	if (entry.blood_sprites){
		for (var i=entry.rects.length;i<entry.blood_sprites.length;i++){
			set_visible(entry.blood_sprites[i], 0);
		}
	}

	return entry;
};

function show_bomb_fragments_for_part(th, part_id, source_img, matrix2, alpha, bomb_state, no_reset){
	var entry = ensure_bomb_fragments_for_part(th, part_id, source_img);
	if ((!entry)||(entry.count <= 1)||(!entry.sprites.length)){
		return false;
	};

	set_visible(source_img, 0);
	for (var i=0;i<entry.sprites.length;i++){
		var sprite = entry.sprites[i];
		var rect = sprite.bomb_rect;
		var fragment_base_matrix = matrix2.copy();
		fragment_base_matrix.translate(rect.x, rect.y);
		var fragment_matrix = get_bomb_die_matrix(th, part_id*100 + i + 1, fragment_base_matrix, bomb_state);
		var top_clamp_progress = Math.max(0, Math.min(1, (bomb_state.progress - 0.55)/0.45));
		fragment_matrix = clamp_matrix_top(fragment_matrix, rect.width, rect.height, get_matrix_top(fragment_base_matrix, rect.width, rect.height), top_clamp_progress);

		if (currentTip == 0){
			sprite.visible(1);
			sprite.matrix = fragment_matrix;
		}else if (currentTip == 1){
			var pm_fragment = new PIXI.Matrix;
			pm_fragment.a = fragment_matrix.m[0];
			pm_fragment.b = fragment_matrix.m[1];
			pm_fragment.c = fragment_matrix.m[2];
			pm_fragment.d = fragment_matrix.m[3];
			pm_fragment.tx = fragment_matrix.m[4];
			pm_fragment.ty = fragment_matrix.m[5];
			sprite.transform.setFromMatrix(pm_fragment);
			sprite.visible = 1;
		};

		set_Alpha(sprite, alpha);
		if (!no_reset) sprite._cache = {};

		var blood_sprite = ensure_bomb_fragment_blood_for_part(th, part_id, source_img, entry, i, rect);
		if (blood_sprite){
			var blood_alpha = Math.min(1, alpha*(0.88 + bomb_die_rand((th.bomb_die_seed || 0) + part_id*41 + i*17)*0.18));
			apply_bomb_overlay_matrix(blood_sprite, fragment_matrix, blood_alpha, no_reset);
		};
	};
	if ((!can_show_bomb_blood_for_part(th, part_id))&&(entry.blood_sprites)){
		for (var i=0;i<entry.blood_sprites.length;i++){
			set_visible(entry.blood_sprites[i], 0);
		};
	};
	return true;
};

function setshoot(x, y, defender, x2, y2, x3, y3){
	var heroes_attackers = Array('pers_svani', 'wpers_svani','banditbarbani', 'banditgnomani', 'agrailani', 'banditsvani', 'banditnecrani', 'banditdemonani', 'banditknightani', 'surv_ani', 'surv_necrani', 'surv_barbani', 'surv_demonani', 'surv_gnomani', 'surv_svani', 'pers_gnomani', 'wpers_gnomani', 'pers_agnomani', 'wpers_agnomani', 'pers_ademonani', 'wpers_ademonani','pers_demonani', 'wpers_demonani', 'pers_necrani', 'wpers_necrani', 'pers_anecrani', 'wpers_anecrani', 'pers_barbani', 'wpers_barbani', 'pers_abarbani', 'wpers_abarbani', 'pers_ani', 'wpers_ani', 'pers_aani', 'wpers_aani');
	var mass_shooters = Array('battlemage', 'archmage', 'mageani', 'dgolemani', 'dgolemupani', 'runepatriarchani', 'fireball', 'runepriestani', 'lichani', 'archlichani', 'magogani');
	var heroes6 = Array('leader3aani','leader3bani','leader1aani', 'leader1wani');
	var heroes6_2 = Array('leadernpani', 'leadernpwani','leader41ani','leader41wani');
	var heroes6_3 = Array('leader2ani','leader2wani');

	this.shoot_requested = true;
	this.shoot_x = x;
	this.shoot_y = y;
	if ((x2)||(y2)){
		this.shoot_x2 = x2;
		this.shoot_y2 = y2;
	};
	if ((x3)||(y3)){
		this.shoot_x3 = x3;
		this.shoot_y3 = y3;
	};
	var stdlen = Math.pow(1300*1300+250*250, 0.5);
	var len =  Math.pow(x*x + y*y, 0.5);

	this.skip_delta = Math.max(0, Math.min(3, Math.round(stdlen/len))-1);
	if (this.chain_shot_start)
	{
		this.skip_delta = 3;
	}

	this.shoot_def = defender;
	if (this.doing == 'multishoot') return 1;

	for (var i=0;i<heroes_attackers.length;i++)
		if (this.filename==heroes_attackers[i]){
		  this.shoot_x -= 32*this.b_view*this.scaling;
		  this.shoot_y += 64*this.scaling;
		  return 1;
		};

	for (var i=0;i<mass_shooters.length;i++)
		if (this.filename==mass_shooters[i]){
		  return 1;
		};

	for (var i=0;i<heroes6.length;i++)
		if (this.filename==heroes6[i]){
		  this.shoot_y += 40*this.scaling;
		  this.shoot_x -= 64*this.b_view*this.scaling;
		  this.skip_delta = 0;
		  return 1;
		};
	for (var i=0;i<heroes6_3.length;i++)
		if (this.filename==heroes6_3[i]){
		  this.shoot_y += 60*this.scaling;
		  this.shoot_x -= 120*this.b_view*this.scaling;
		  this.skip_delta = 0;
		  return 1;
		};

	for (var i=0;i<heroes6_2.length;i++)
		if (this.filename==heroes6_2[i]){
		  this.shoot_x -= (Math.min(100, stage_width/Math.max(2, Math.abs(x))))*this.b_view*this.scaling;
		  this.shoot_x *= 1.08;
		  this.shoot_y *= 1.15;
		  this.shoot_y += 40*this.scaling;
		  this.skip_delta = 0;
		  return 1;
		};

    this.shoot_y += 74*this.scaling;
	return 2;

};


function can_use_shoot_teleport_fallback(th, doing){
	if ((!th)||(!th.hero)||(!th.shoot_requested)||(!th.shoot_def)||(typeof stage === 'undefined')||(!stage[war_scr])||(!stage[war_scr].obj[th.shoot_def])){
		return false;
	};
	if ((!doing)||((doing!="shoot")&&(doing.substr(0, 6)!="attack"))){
		return false;
	};
	if ((typeof th.anim === 'undefined')||(typeof anim[th.anim] === 'undefined')){
		return false;
	};
	if ((typeof anim[th.anim]["attack"] === 'undefined')||(anim[th.anim]["attack"].length<=1)){
		return false;
	};
	if ((typeof anim[th.anim]["shoot"] !== 'undefined')&&(anim[th.anim]["shoot"].length>2)){
		return false;
	};
	return true;
}


function init_shoot_teleport_fallback(th){
	var target = stage[war_scr].obj[th.shoot_def];
	if (!target){
		return false;
	};
	var attack_view = 1;
	if (target.x<th.x){
		attack_view = -1;
	};
	var start_view = th.b_view;
	if (!start_view){
		start_view = attack_view;
	};
	var target_big = 0;
	if (target.big){
		target_big = Math.max(target_big, target.big*0.15);
	};
	if (target.bigx){
		target_big = Math.max(target_big, target.bigx*0.2);
	};
	var unit_big = 0;
	if (th.big){
		unit_big = Math.max(unit_big, th.big*0.15);
	};
	if (th.bigx){
		unit_big = Math.max(unit_big, th.bigx*0.2);
	};
	var offset_x = 0.75 + target_big + unit_big;
	th.shoot_teleport_fallback = {
		phase: 'go_out',
		frame: 0,
		totalf: 6,
		start_x: th.x,
		start_y: th.y,
		start_view: start_view,
		dest_x: target.x-attack_view*offset_x,
		dest_y: target.y,
		attack_view: attack_view
	};
	return true;
}


function finish_shoot_teleport_fallback(th){
	if (th.shoot_teleport_fallback){
		th.x = th.shoot_teleport_fallback.start_x;
		th.y = th.shoot_teleport_fallback.start_y;
		th.set_pole_pos(th.x, th.y, th.shoot_teleport_fallback.start_view);
	};
	set_Alpha(th.under_layer, 1);
	th.need_cache = 1;
	th.frame = 0;
	th.arrow_fly = false;
	th.was_free = 0;
	th.back_frame = 0;
	th.stage = 0;
	th.at = 0;
	th.doing = "";
	th.lastdoing = "";
	th.skip_frame = 0;
	th.was_active = true;
	th.shoot_requested = false;
	th.shoot_teleport_fallback = false;
	th.statix_to_dynamic();
	th.set_statix(th.dynamic);
	return 0;
}


function animate_shoot_teleport_fallback(th){
	if ((!th.shoot_teleport_fallback)||((th.doing!="shootteleport_go")&&(th.doing!="shootteleport_back"))){
		return false;
	};
	var data = th.shoot_teleport_fallback;
	var totalf = data.totalf;
	if (!totalf){
		totalf = 6;
		data.totalf = totalf;
	};
	data.frame++;
	var now = Math.min(1, data.frame/totalf);
	var xx = data.start_x;
	var yy = data.start_y;
	var cur_view = data.start_view;
	var alpha = 1;
	if ((data.phase=='go_in')||(data.phase=='back_out')){
		xx = data.dest_x;
		yy = data.dest_y;
		cur_view = data.attack_view;
	};
	if ((data.phase=='go_out')||(data.phase=='back_out')){
		alpha = Math.max(0, 1-now);
	}else{
		alpha = Math.max(0, Math.min(1, now));
	};
	th.x = xx;
	th.y = yy;
	th.set_pole_pos(xx, yy, cur_view);
	set_Alpha(th.under_layer, alpha);
	th.need_cache = 1;
	if (data.frame<totalf){
		return true;
	};
	if (data.phase=='go_out'){
		th.x = data.dest_x;
		th.y = data.dest_y;
		th.set_pole_pos(th.x, th.y, data.attack_view);
		set_Alpha(th.under_layer, 0);
		data.phase = 'go_in';
		data.frame = 0;
		return true;
	};
	if (data.phase=='go_in'){
		set_Alpha(th.under_layer, 1);
		data.phase = 'attack';
		data.frame = 0;
		th.doing = "attack";
		th.lastdoing = "";
		th.frame = 0;
		return true;
	};
	if (data.phase=='back_out'){
		th.x = data.start_x;
		th.y = data.start_y;
		th.set_pole_pos(th.x, th.y, data.start_view);
		set_Alpha(th.under_layer, 0);
		data.phase = 'back_in';
		data.frame = 0;
		return true;
	};
	if (data.phase=='back_in'){
		set_Alpha(th.under_layer, 1);
		finish_shoot_teleport_fallback(th);
	}
	return true;
}


function add_image_for_obj(link, ver, filename, fallback_link){

	var i = filename;
	if (hwm_je2d_is_battle_loader_cancelled(image_obj[i]))
	{
		try { delete image_obj[i]; } catch (_) { image_obj[i] = undefined; }
	}
	if (typeof image_obj[i] !== 'undefined')
	{
		if (typeof image_obj[i].objs === 'undefined')
		{
			image_obj[i].objs = Array();
		}
		image_obj[i].objs.push(this);
		this.init_this_obj();
		return image_obj[i];
	}

	var fallback_path = 0;
	if (fallback_link){
		fallback_path = fallback_link+'?v='+ver;
	};

	loadImage(this, i, link, link+'?v='+ver, 0, 0, fallback_link, fallback_path, false);
	
	
	
	return image_obj[i];
};





// ================= MULTI-ATLAS SUPPORT =================
// razmetka[fname].atlases = N  (set by converter). Atlas #0 uses <fname>.png, atlas #1 uses <fname>_a1.png, etc.
// Each razmetka[i][mqc['atlas']] stores atlas index for that frame/part.
//
// image_obj keys:
//   atlas 0: image_obj[fname]
//   atlas k: image_obj[fname + '_a' + k]
function get_atlas_image_obj(fname, atlas_id){
    if (!atlas_id) return image_obj[fname];
    var key = fname + '_a' + atlas_id;
    if (typeof image_obj[key] !== 'undefined') return image_obj[key];
    return image_obj[fname];
}

function get_required_atlas_count(fname){
    try{
        if ((typeof razmetka !== 'undefined') && (razmetka[fname] != undefined) && (razmetka[fname].atlases != undefined)){
            var c = parseInt(razmetka[fname].atlases, 10);
            if (isNaN(c) || c < 1) c = 1;
            return c;
        }
    }catch(e){}
    return 1;
}

// Ensures that all extra atlas images are loaded before obj_init.
// Returns true if ready, false if still loading.
function ensure_unit_atlases_loaded(obj){
    var fname = obj.filename;
    var need = get_required_atlas_count(fname);
    if (need <= 1) return true;

    for (var a = 1; a < need; a++){
        var key = fname + '_a' + a;

        if ((typeof image_obj[key] !== 'undefined') && (image_obj[key].loaded)){
            continue;
        }

        // If already loading -> just subscribe
        if (typeof image_obj[key] !== 'undefined'){
            if (typeof image_obj[key].objs === 'undefined') image_obj[key].objs = Array();
            image_obj[key].objs.push(obj);
            return false;
        }

        // Build URL for extra atlas based on already-loaded base atlas
        if ((typeof image_obj[fname] === 'undefined') || (!image_obj[fname].src)) return false;

        var src = image_obj[fname].src;
        var qpos = src.indexOf('?');
        var query = '';
        var base = src;
        if (qpos >= 0){
            query = src.substr(qpos);
            base = src.substr(0, qpos);
        }
        // Replace ending ".png" with "_a{a}.png"
        var base2 = base.replace(/\.png$/i, '_a' + a + '.png');
        var path = base2 + query;

        // link param (for error logs) should be without query
        loadImage(obj, key, base2, path, 0);
        return false;
    }
    return true;
}
// ================= END MULTI-ATLAS SUPPORT =================

function init_this_obj(){
		if (hwm_je2d_is_battle_loader_cancelled(this)) return 0;
		if ((typeof cordova_client !== 'undefined')&&(cordova_client)&&(typeof war_scr !== 'undefined')&&(war_scr == '')) return 0;

		if ((this.lname)&&(this.lname.indexOf('2014/')==0)&&(typeof statix[this.lname] !== 'undefined')&&(typeof razmetka[this.lname] !== 'undefined')){
			statix[this.filename] = statix[this.lname];
			razmetka[this.filename] = razmetka[this.lname];
			if ((typeof anim !== 'undefined')&&(typeof anim[this.lname] !== 'undefined')) anim[this.filename] = anim[this.lname];
		};
        var portrait_key = this.portrait_key ? this.portrait_key : this.filename+'p';
		if ((!this.inited_image)&&(typeof image_obj[this.filename] !== 'undefined')&&(image_obj[this.filename].loaded)&&((!this.it_unit)||((typeof image_obj[portrait_key] !== 'undefined')&&(image_obj[portrait_key].loaded)))&&(typeof statix !== 'undefined')&&(typeof razmetka !== 'undefined')){
			if 	((typeof this.filename !== 'undefined')&&(typeof statix[this.filename] !== 'undefined')&&(typeof razmetka[this.filename] !== 'undefined')){

//				if ((war_scr)&&(!inited_land_const)) return 0;
				if (!ensure_unit_atlases_loaded(this)) return 0;
				this.obj_init();
			};
		};

};



function add_image(name, filename, ext, version, subpath, subdir_load){
		
	var i = filename;
	if (typeof subdir_load === 'undefined') var subdir_load = subdir;


	link = subpath+'png'+subdir_load+'/'+filename+'.'+ext;
	
	if (hwm_je2d_is_battle_loader_cancelled(image_obj[i]))
	{
		try { delete image_obj[i]; } catch (_) { image_obj[i] = undefined; }
	}
	if (typeof image_obj[i] !== 'undefined')
	{
		this[name] = image_obj[i];
		if (typeof image_obj[i].objs === 'undefined') image_obj[i].objs = Array();
		if (image_obj[i].objs.indexOf(this) == -1) image_obj[i].objs.push(this);
		if ((image_obj[i].loaded)&&(typeof this.init_this_obj === 'function')) this.init_this_obj();
		return i;
	}
   
	loadImage(this, i, link, link+'?v='+version, 0, name);


	return i;
};

function hwmengine_clear_cache(obj){
   if (currentTip==1){
      set_cache(obj, false);
   }else{
      obj.clearCache();
   };

};

function add_obj(name, obj_filename, version, subpath, shadow, callback, not_unit, layer_name, subdir_load){
try{
	hwm_je2d_mark_battle_loader(this);
	this.name = name;
	this.set_data = set_data;
	this.obj_init = obj_init;
	this.set_statix = set_statix;
	this.animate_continue = animate_continue;
	this.show_obj = show_obj;
	this.show_obj_konva = show_obj_konva;
	this.show_obj_pixi = show_obj_pixi;
	this.init_this_obj = init_this_obj;
	this.loadScript_obj = loadScript_obj;
	this.init_obj_image = init_obj_image;
	this.statix_to_dynamic = statix_to_dynamic;
	this.save_cur_dynamic = save_cur_dynamic;
	this.saved_to_dynamic = saved_to_dynamic;
	this.obj_inited = obj_inited;
	this.set_pos = set_pos;
	this.add_image_for_obj = add_image_for_obj;
	this.callback_function = callback;
	
	if (typeof this.scaling === 'undefined') this.scaling = 1;
//	if ((zamena!='')&&(obj_filename == 'dd_ani')) obj_filename = zamena;
//	if ((zamena!='')&&(obj_filename == 'lichani')) obj_filename = zamena;
//	if (obj_filename == 'dd_ani') obj_filename = 'masteriksani';
//	if (obj_filename == 'dd_ani') obj_filename = 'elfani';
//	if (obj_filename == 'dd_ani') obj_filename = 'archerani';

	var fname = obj_filename;
/*	var kk = fname.indexOf('/');
	if (kk>0){
		fname = fname.substr(kk+1);
	};*/

	this['filename'] = fname;

	this.inited_image = false;

	this.shadow = shadow;

	layer = Make_Sprite();
	under_layer = Make_Sprite();
	this.under_layer = under_layer;

	under_layer2 = Make_Sprite();
	this.under_layer2 = under_layer2;

	under_layer2a = Make_Sprite();
	this.under_layer2a = under_layer2a;

	under_layer3 = Make_Sprite();
	this.under_layer3 = under_layer3;


	this.layer = layer;

	this.layer.it_has_shadow = true;
	this.under_layer3.calc_bounds = this.obj_index;
	this.under_layer3.calc_bounds_link = under_layer2;

	Make_addChild(this.layer, under_layer3);
	Make_addChild(under_layer3, under_layer2);
	Make_addChild(under_layer2, under_layer2a);
	Make_addChild(under_layer2a, under_layer);
//	Make_addChild(under_layer2, under_layer);

	arrow_layer = Make_Sprite();
	arrow_under_layer = Make_Sprite();
	this.arrow_under_layer = arrow_under_layer;
	this.arrow_layer = arrow_layer;
	this.arrow_layer.it_has_shadow = true;
	Make_addChild(this.arrow_layer, arrow_under_layer);

	this.layer.z_ok = true;
	this.arrow_layer.z_ok = true;


	if (layer_name){
		Make_addChild(stage[this.container][layer_name], this.layer);
		Make_addChild(stage[this.container][layer_name], this.arrow_layer);
	}else{
		Make_addChild(stage[this.container].unit_layer, this.layer);
		Make_addChild(stage[this.container].unit_layer, this.arrow_layer);
	};
	
	
	if (!this.magic_spell){

		uron_layer = Make_Sprite();
		uron_under_layer = Make_Sprite();
		this.uron_under_layer = uron_under_layer;
		this.uron_layer = uron_layer;
		this.uron_layer.it_has_shadow = true;
		this.uron_layer.z_ok = true;
		Make_addChild(this.uron_layer, uron_under_layer);
		if (layer_name){
			Make_addChild(stage[this.container][layer_name], this.uron_layer);
		}else{
			Make_addChild(stage[this.container].unit_layer, this.uron_layer);
		};
	};

	mobject_arrow = Make_Sprite();
	this.mobject_arrow = mobject_arrow;
	Make_addChild(this.arrow_under_layer, mobject_arrow);

//	mobject = new KonvaGroup({hitGraphEnabled : false, listening: false, visible: 1});
	mobject = Make_Sprite();

	this.mobject = mobject;

//	mobject_arrow = new KonvaGroup({hitGraphEnabled : false, listening: false, visible: 1});

	
//	unit = new KonvaGroup({hitGraphEnabled : false, listening: false, visible: 1});
	unit_top = Make_Sprite();
	this.unit_top = unit_top;
	unit = Make_Sprite();
	this.unit = unit;
	
/*	this.layer.interactive = true;
	this.layer.interactiveChildren = true;
	if (this.obj_index){
		this.layer.obj_index = this.obj_index;
		this.layer.on('mouseover', (event) => {
			interactive_obj = this.obj_index;
			var i = 0;
			for (i in event.currentTarget) {
				if (event.currentTarget.hasOwnProperty(i)){
					console.log(i, event.currentTarget[i]);
				};
			};
			
			console.log(interactive_obj);
		});
		this.layer.on('mouseout', (event) => {
			interactive_obj = 0;
			console.log(interactive_obj);

		});
	};*/
	

	Make_addChild(this.unit_top, unit);
	this.unit.sortableChildren = true;
	Make_addChild(this.under_layer, mobject);
	//	this.shadow = 0;
	if (this.shadow){

		var shadow_layer = Make_Sprite();
		var shadow_layer_under = Make_Sprite();
		this.shadow_layer = shadow_layer;
		this.shadow_layer_under = shadow_layer_under;
		
		if (this.shadow_layer.konva_obj){
			this.shadow_layer.filters([Konva.Filters.Black, Konva.Filters.Blur]);
			this.shadow_layer.blurRadius(shadowblur);
			this.shadow_layer.setAttr('opacity', shadow_alpha);
		};
		if (this.shadow_layer.pixi_obj){
			shadow_filter = new PIXI.filters.ColorMatrixFilter();
			alpha_filter = new PIXI.filters.AlphaFilter(shadow_alpha);
			blur_filter = new PIXI.filters.BlurFilter(0.5, 1);
			blur_filter.repeatEdgePixels   = true;

			shadow_filter.brightness(-100);
				
			this.shadow_layer.filters = [shadow_filter, blur_filter, alpha_filter];
		};
		Make_addChild(this.shadow_layer_under, this.shadow_layer);
		Make_addChild(this.mobject, this.shadow_layer_under);
		if (!this.shadow) set_visible(this.shadow_layer_under, 0);
	};

	Make_addChild(this.mobject, this.unit_top);
	if (typeof subdir_load === 'undefined') var subdir_load = subdir;

    if (not_unit==true){
        this.it_unit = false;
    }else{
        this.it_unit = true;
    };

    this.portrait_key = fname+'p';
    this.custom_portrait_filename = '';
    var custom_portrait_filename = '';
    if ((this.it_unit)&&(this.custom_image)){
        custom_portrait_filename = get_custom_portrait_filename(this.custom_image);
        if (custom_portrait_filename){
            this.custom_portrait_filename = custom_portrait_filename;
            this.portrait_key = 'custom_portrait:' + custom_portrait_filename;
        };
    };

	this.image_link = this.add_image_for_obj(subpath+'png'+subdir_load+'/'+obj_filename+'.png', version, fname);
	this.image_link.it_unit = this.it_unit;
	if (this.it_unit){
		subdir_p = subdir;
		if ((classic_chat)&&(like_flash)&&(subdir_p>30)&&(stage_width<=1920)) subdir_p = 30;
		if ((subdir_p>30)&&(stage_width*MainPixelRatio>1920)&&(!small_portraits)&&(!android)){
			subdir_p = 60;

/*			if (stage_width>2880)
			{
				subdir_p = 80;
			}*/
		};
//		if (typeof portrait_dir !== 'undefined') subdir_p = portrait_dir;
		var default_portrait_link = subpath+get_portraits_dir(obj_filename)+obj_filename+'p'+subdir_p+'.png';
		var default_portrait_fallback_link = 0;
		if (get_portraits_dir(obj_filename) != portraits_default){
			default_portrait_fallback_link = subpath+portraits_default+obj_filename+'p'+subdir_p+'.png';
		};
        var portrait_link = default_portrait_link;
		var portrait_fallback_link = default_portrait_fallback_link;
        if (custom_portrait_filename){
            portrait_link = dcdn_path+'i/custom_objects/' + custom_portrait_filename;
            portrait_fallback_link = default_portrait_fallback_link ? default_portrait_fallback_link : default_portrait_link;
		};
		this.portrait_link = this.add_image_for_obj(portrait_link, version, this.portrait_key, portrait_fallback_link);
		this.portrait_link.it_unit = true;
	};
	var anim_data_key = fname;
	var anim_data_alias = (obj_filename == 'effs_demo');
	if (anim_data_alias) anim_data_key = 'effs';
	if (!anim_data_alias) hwm_loader_alias_anim_data(anim_data_key, fname);
	if ((obj_filename.substr(0, 5) != 'land_')&&(!hwm_loader_anim_data_key_ok(fname))){
		this.loadScript_obj(subpath+'anim_data'+subdir_load+'/'+obj_filename+'.js'+'?v='+version, 0, this, anim_data_key, fname);
	};
	stage[this.container].check_initialized();
}catch(e){
	my_alert(e.stack);
};
};



function init_obj_image(){
		var imgs_cnt = 0, i = 0;
		var baseImageObj = image_obj[this.filename];

try{
		if (!this.doing) this.doing = '';
		this.frame = 0;
		this.lastdoing = '';
		this['walkspeed'] = 1000;
		this.inited_image = true;

		var fname = this['filename'];		
		this.statix_d = Array();
		if (!statix[fname]['numstones']){ this.attach_stone = 0; };
		if (this.attach_stone){
			if (statix[fname]['numstones']==1){ var st = 'stone1'; }else var st = 'stone'+(this.attach_stone%statix[fname]['numstones']+1);
			var my_statix = {};
			my_statix.nano_arts = {};
			my_statix["obj_scale"] = 100/sub_scale;
			my_statix['c_length'] = 3;
			var c = 0;
			for (i=statix[fname]['c_length'];i>=1;i--) {
				if (statix[fname][i]['name']==st) {
					var c=0;
					my_statix['depths'] = Array();
					my_statix['depths'][0] = 3;
					for (var k=i;k>=i-2;k--){
						c++;
						my_statix[c] = statix[fname][k];
						my_statix[c]['parent'] = c-1;
						my_statix['depths'][c] = c;
					};
					my_statix[c]['curframe'] = i-2;
					break;
				}
			}
			this.statix_d = my_statix;
		}else{
			this.statix_d = statix[fname];
		};

		var statix_len = this.statix_d['c_length'];
		this['statix_len'] = statix_len;
		this['art_w'] = 0; this['art_a'] = 0; this['art_i'] = 0;

		if ((typeof magic !== 'undefined')&&(this.obj_index)&&(magic[this.obj_index])) {
			if (magic[this.obj_index]['naa']){ this['art_w'] = Math.min(2, magic[this.obj_index]['naa']['effect']); };
			if (magic[this.obj_index]['nad']){ this['art_a'] = Math.min(2, magic[this.obj_index]['nad']['effect']); };
			if (magic[this.obj_index]['nai']){ this['art_i'] = Math.min(2, magic[this.obj_index]['nai']['effect']); };
			if (magic[this.obj_index]['meg']){ this['art_w'] = 2; this['art_a'] = 2; this['art_i'] = 2; };
		}
		if (this.magic) {
			if (this.magic['naa']){ this['art_w'] = this.magic['naa']['effect']; };
			if (this.magic['nad']){ this['art_a'] =this.magic['nad']['effect']; };
			if (this.magic['nai']){ this['art_i'] = this.magic['nai']['effect']; };
			if (this.magic['meg']){ this['art_w'] = 2; this['art_a'] = 2; this['art_i'] = 2; };
		}

		this['n_data'] = Array();
		this.razmetka = Array();
		this.razmetka = razmetka[fname];
		
		this.dynamic = Array();
		this.dynamic['depths']=Array();
		for (var k=0;k<=this.statix_d['depths'][0];k++) {
			this.dynamic['depths'][k]=this.statix_d['depths'][k];
		}

		if (this.attach_stone){ this.anim = ''; }else{ this.anim = fname; };

        // Build the replacement map for the exact parts that should be replaced.
        var replacements_map = {};
        this.custom_replacements_map = replacements_map;
        var created_parts = {};     
        this.custom_load_counter = 0;

        if (this.custom_image) {
            
            for (var st_key in this.statix_d) {
                if (!this.statix_d.hasOwnProperty(st_key)) continue;
                var part_def = this.statix_d[st_key];
                var p_id = parseInt(st_key);
                var cfg = get_custom_image_for_part(this.custom_image, this.statix_d, p_id);
                if (cfg) {
                    replacements_map[p_id] = cfg;

                    if (custom_replacement_has_filename(cfg)) {
                        this.custom_load_counter++; 
                        if ((this.shadow)&&(old_shadow)) this.custom_load_counter++;
                    }
                }
            }
        }

        if (this.custom_load_counter > 0) {
            set_visible(this.layer, 0);
        }

        // Keep replacement depth close to the original parent part.
        if (this.custom_image) {
            for (var rep_id in replacements_map) {
                if (!custom_replacement_has_filename(replacements_map[rep_id])) continue;
                rep_id = parseInt(rep_id);
                var k_parent = -1;
                var k_best_child = 99999; 

                for (var k = 1; k <= this.dynamic['depths'][0]; k++) {
                    var curr_id = this.dynamic['depths'][k];
                    if (curr_id == rep_id) { k_parent = k; }
                    if (this.statix_d[curr_id] && this.statix_d[curr_id].parent == rep_id) {
                        if (k < k_best_child) k_best_child = k;
                    }
                }
                if (k_parent !== -1 && k_best_child < 99999 && k_best_child < k_parent) {
                    var child_id = this.dynamic['depths'][k_best_child];
                    this.dynamic['depths'][k_best_child] = rep_id;
                    this.dynamic['depths'][k_parent] = child_id;
                }
            }
        }

        var max_k = (this.razmetka && this.razmetka[0]) ? this.razmetka[0] : statix_len;
        if (statix_len > max_k) max_k = statix_len;

        // Create sprites for original and replacement parts.
		for (var k = max_k; k>=1; k--)
		{
			i = k;
			if (this.attach_stone) {
				if (i!=this.statix_d[3]['curframe']) continue;
			}

            var is_replacement = replacements_map[i];
            var replacement_has_texture = custom_replacement_has_filename(is_replacement);
             
            // Custom replacement part.
            if (replacement_has_texture) {
                var dummy_img = new Image(); 
                var new_part = My_Image({
                    x: 0, y: 0, image: dummy_img, width: 1, height: 1, 
                    visible: 0, listening: false, perfectDrawEnabled: false 
                });

                var orig_params = (this.razmetka && this.razmetka[i]) ? this.razmetka[i] : null;
                load_custom_part_texture(new_part, replacements_map[i], orig_params, this, true);

                // GlowFilter from the SWF converter is stored in razmetka[i][mqc['glow']].
                var _gd = (orig_params) ? orig_params[mqc['glow']] : undefined;
                if (_gd && (typeof _gd === 'object') && (_gd.length)) {
                    apply_flash_glow(new_part, _gd);
                }

                this['image'+i] = new_part;
                if (!this['image'+i].bomb_meta) this['image'+i].bomb_meta = {};
                this['image'+i].bomb_meta.part_id = i;
                this['image'+i].arrowed = false;
                
                Make_addChild(this.unit, new_part);
                
                this['image_link'+imgs_cnt] = i;
                imgs_cnt++;
                this['image_cnt'] = imgs_cnt;
                
                created_parts[i] = true;

                if ((this.shadow)&&(old_shadow)){
                    var new_shadow = My_Image({
                        x: 0, y: 0, image: dummy_img, width: 1, height: 1,
                        visible: 0, listening: false, perfectDrawEnabled: false 
                    });
                    load_custom_part_texture(new_shadow, replacements_map[i], orig_params, this, false);
                    this['2image'+i] = new_shadow;
                    Make_addChild(this.shadow_layer, new_shadow);
                }
                continue; 
            }

            // Original atlas part.
			if ((typeof this.razmetka[i] !== 'undefined') && (this.razmetka[i] != 0))
			{
				if (typeof this.razmetka[i][0] === 'undefined') {
					var tempa = Array(); for (var m=0;m<mqc_n.length;m++) { tempa[m] = this.razmetka[i][mqc_n[m]]; }
					this.razmetka[i] = Array(); for (var m=0;m<mqc_n.length;m++) { this.razmetka[i][m] = tempa[m]; }
				}

				
				// Multi-atlas: choose correct atlas image for this part
				var atlasId = 0;
				if ((typeof this.razmetka[i][mqc['atlas']] !== 'undefined') && (this.razmetka[i][mqc['atlas']] != 0)){
					atlasId = this.razmetka[i][mqc['atlas']];
				}
				var imageObj = get_atlas_image_obj(this.filename, atlasId);

img_temp = My_Image({x: 0, y: 0, image: imageObj, width: this.razmetka[i][7], 
					height: this.razmetka[i][8], crop:{x: this.razmetka[i][0], y: this.razmetka[i][1], 
					width: this.razmetka[i][7], height: this.razmetka[i][8]}, visible:0, listening: false, perfectDrawEnabled: false });

                set_visible(img_temp, 0);

                // GlowFilter from the SWF converter: razmetka[i][mqc['glow']].
                var _gd2 = this.razmetka[i][mqc['glow']];
                if (_gd2 && (typeof _gd2 === 'object') && (_gd2.length)) {
                    apply_flash_glow(img_temp, _gd2);
                }
                if (custom_image_color_has_filter(replacements_map[i])) {
                    custom_image_apply_color_filter(img_temp, replacements_map[i]);
                }

				this['image'+i]=img_temp;
				this['image'+i].bomb_meta = {
					part_id: i,
					image_obj: imageObj,
					crop: {
						x: this.razmetka[i][mqc['x']],
						y: this.razmetka[i][mqc['y']],
						width: this.razmetka[i][mqc['xs']],
						height: this.razmetka[i][mqc['ys']]
					},
					width: this.razmetka[i][mqc['xs']],
					height: this.razmetka[i][mqc['ys']]
				};
				this['image'+i].arrowed = false;
				this['image_link'+imgs_cnt] = i;
				imgs_cnt++;
				this['image_cnt'] = imgs_cnt;

				Make_addChild(this.unit, img_temp);
				created_parts[i] = true;
				
				if ((this.shadow)&&(old_shadow)){
					img_temp2 = My_Image({x: 0, y: 0, image: imageObj, width: this.razmetka[i][mqc['xs']], height: this.razmetka[i][mqc['ys']],
						crop:{x: this.razmetka[i][mqc['x']], y: this.razmetka[i][mqc['y']], width: this.razmetka[i][mqc['xs']], height: this.razmetka[i][mqc['ys']], visible: 0, perfectDrawEnabled: false }, 
						listening: false
						});
						
					set_visible(img_temp2, 0);
					this['2image'+i]=img_temp2;
					Make_addChild(this.shadow_layer, img_temp2);
				};
			}
		} 

		this.n_data = Array();

        // FIX NANOARTS
		this.hide = Array();

	    var n = Array('w', 'a', 'i');
		var siz = 0, j = 0;
		for (i=0;i<=2;i++)
		{
			siz = Object.size(this['statix_d']['nano_arts'][n[i]]);
			if (siz>0)
			{
				for (k=0;k<siz;k++)
				{
					for (j=0;j<=2;j++)
					{
						if ((this['statix_d']['nano_arts'][n[i]][k][j]>0)&&(1)){
							if (this['art_'+n[i]]!=j){
								this['hide'][this['statix_d']['nano_arts'][n[i]][k][j]] = 0;
							}else{
								this['hide'][this['statix_d']['nano_arts'][n[i]][k][j]] = 1;
							};
						};
					}
				}
			}	
		};

        if (this.custom_image) {
             for (var rep_id in replacements_map) {
                 rep_id = parseInt(rep_id);
                 if (!custom_replacement_has_filename(replacements_map[rep_id])) continue;
                 if (this.hide[rep_id]) this.hide[rep_id] = 0; 
                 delete this.hide[rep_id];
             }
        }

		for (var k=this['statix_len'];k>=1;k--)
		{
			var matr = new MatrixTransform();
			matr.m[0] = this.statix_d[k].a;
			matr.m[1] = this.statix_d[k].b;
			matr.m[2] = this.statix_d[k].c;
			matr.m[3] = this.statix_d[k].d;
			matr.m[4] = this.statix_d[k].tx;
			matr.m[5] = this.statix_d[k].ty;
			this.dynamic[k] = Array();
			
			this.statix_d[k]['matrix'] = new MatrixTransform();
			this.statix_d[k]['matrix'].m  = (matr.m.slice()) || [1, 0, 0, 1, 0, 0];
			this.statix_d['swapit']=1;			
			if (typeof this.statix_d[k]['curframe'] === 'undefined') this.statix_d[k]['curframe']  = 0;
			this.statix_d[k]['lastframe'] = this.statix_d[k]['curframe'];
			this.statix_d[k]['_xscale'] = this.statix_d[k]['bxscale'];
			this.statix_d[k]['_yscale'] = this.statix_d[k]['byscale'];

			if (this.statix_d[k]['_visible'])
			{
				this.statix_d[k]['_visible']=1;
			}else{
				this.statix_d[k]['_visible']=0;
			};
	    };
		
		this.statix_to_dynamic();
        this.set_statix(this.dynamic);

}catch(e){
	my_alert(e.stack);
};
	};




	function statix_to_dynamic(){
		if ((this.dualforms)&&(magic[this.obj_index])&&(this.saved_d)&&(magic[this.obj_index]['dua'])&&(magic[this.obj_index]['dua']['effect']==1)){
			this.saved_to_dynamic();
			return 0;
		};
		for (var k=this['statix_len'];k>=1;k--)
		{
			this.dynamic['swapit']=this.statix_d['swapit'];
			if (!this.dynamic[k]) continue;
			this.dynamic[k]['lastframe'] = this.dynamic[k]['curframe'];
			this.dynamic[k]['curframe'] = this.statix_d[k]['curframe'];

//			this.dynamic[k]['matrix'] = this.statix_d[k]['matrix'].copy();
			if (!this.dynamic[k]['matrix'])
			{
				this.dynamic[k]['matrix'] = new MatrixTransform();
			}
			this.dynamic[k]['matrix'].m  = (this.statix_d[k]['matrix'].m.slice()) || [1, 0, 0, 1, 0, 0];
			this.dynamic[k]['_x'] = this.statix_d[k]['_x'];
			this.dynamic[k]['_y'] = this.statix_d[k]['_y'];
			this.dynamic[k]['_xscale'] = this.statix_d[k]['_xscale'];
			this.dynamic[k]['_yscale'] = this.statix_d[k]['_yscale'];
			this.dynamic[k]['_visible'] = this.statix_d[k]['_visible'];
	    };
	};

	function save_cur_dynamic(){
		this.saved_d = Array();
		for (var k=this['statix_len'];k>=1;k--)
		{
			this.saved_d['swapit'] = this.dynamic['swapit'];
			this.saved_d[k] = Array();
			this.saved_d[k]['lastframe'] = this.dynamic[k]['curframe'];
			this.saved_d[k]['curframe'] = this.dynamic[k]['curframe'];
//			this.saved_d[k]['matrix'] = this.dynamic[k]['matrix'].copy();
			this.saved_d[k]['matrix'] = new MatrixTransform();
		    this.saved_d[k]['matrix'].m  = (this.dynamic[k]['matrix'].m.slice()) || [1, 0, 0, 1, 0, 0];
			this.saved_d[k]['_x'] = this.dynamic[k]['_x'];
			this.saved_d[k]['_y'] = this.dynamic[k]['_y'];
			this.saved_d[k]['_xscale'] = this.dynamic[k]['_xscale'];
			this.saved_d[k]['_yscale'] = this.dynamic[k]['_yscale'];
			this.saved_d[k]['_visible'] = this.dynamic[k]['_visible'];
	    };
	};


	function saved_to_dynamic(){
		for (var k=this['statix_len'];k>=1;k--)
		{
			this.dynamic['swapit'] = this.saved_d['swapit'];
			this.dynamic[k]['lastframe'] = this.saved_d[k]['lastframe'];
			this.dynamic[k]['curframe'] = this.saved_d[k]['curframe'];
//			this.dynamic[k]['matrix'] = this.saved_d[k]['matrix'].copy();
			if (!this.dynamic[k]['matrix']){
				this.dynamic[k]['matrix'] = new MatrixTransform();
			};
		    this.dynamic[k]['matrix'].m  = (this.saved_d[k]['matrix'].m.slice()) || [1, 0, 0, 1, 0, 0];

			this.dynamic[k]['_x'] = this.saved_d[k]['_x'];
			this.dynamic[k]['_y'] = this.saved_d[k]['_y'];
			this.dynamic[k]['_xscale'] = this.saved_d[k]['_xscale'];
			this.dynamic[k]['_yscale'] = this.saved_d[k]['_yscale'];
			this.dynamic[k]['_visible'] = this.saved_d[k]['_visible'];
	    };
	};


	function getrot(x, y) {
		var r = 0, sin = 0, a = 0;
		if (Math.abs(x)>Math.abs(y)) {
			sin = -y/x;
			a = Math.asin(sin)*180/Math.PI;
		} else {
			sin = -x/y;
			a = Math.acos(sin)*180/Math.PI;
		}
		if (x<0) {
			a += 180;
		}
		a -= 90;
		return a;
	}

	function get_rectangle_points(x1, y1, x2, y2, thik){
				var grad = -getrot(x2-x1, y2-y1);
				var xp = thik*Math.cos(grad*Math.PI/180);
				var yp = thik*Math.sin(grad*Math.PI/180);
				var points = Array();
									
				points.push(x1-xp, y1-yp);
				points.push(x1+xp, y1+yp);
				points.push(x2+yp, y2+yp);
				points.push(x2-xp, y2-yp);
				points.push(x1-xp, y1-yp);

				return points;
	};

	function get_molnia_points(x1, y1, x2, y2, j){
				var points = Array();
									
				points.push(x1, y1);
				var k = Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))*2;
				for (var i = 0; i<=k; i += 100) {
					points.push(x1+(x2-x1)*i/k+(Math.random()-0.5)*7*j, y1+(y2-y1)*i/k+(Math.random()-0.5)*14*j);
				}

				return points;
	};


	function getHexColor(number){
		return "#" + ('000000' + ((number)>>>0).toString(16)).slice(-6);
	}


	function set_statix(statix){
	  var sx=0, sy=0, px=0, py=0, parent = 0, rp=0, i=0, k=0, j=0;
	  var scaleMatrix = new MatrixTransform();
	  var scaleMatrix2 = new MatrixTransform();
	  var scaleMatrix3 = new MatrixTransform();
	  var scaleMatrix4 = new MatrixTransform();
	  var diff = false;
	  var check_arrow = false;
	  var check_arrow_len = 0;
	  var swapit = 0;
	  var need_draw_chain = false;
	  var doing = this.doing;
	  var check_s_arrowed = false;

	  swapit = statix['swapit'];


//	  for (var i=this['statix_len'];i>=1;i--)

	  if ((this.doing)&&(this.doing!='')&&(anim[this.anim][this.doing])&&(anim[this.anim][this.doing][1])){
		  if (anim[this.anim][this.doing][1][0][3])
		  {
			  check_arrow = true;
			  var check_arrow_len = anim[this.anim][doing][1][0][3].length;
			  this.skip_frame = 0;
		  }
		  if (this.draw_chain){
			  need_draw_chain = true;
		  };
	  };

	  
	  for (var i=1;i<=this['statix_len'];i++)
	  {
	    k = statix['depths'][i];

		
		if (!statix[k])
		{
			continue;
		}


		this.n_data[k] = Array();
		this.n_data[k][nda['curframe']] = statix[k]['curframe'];
		this.n_data[k][nda['lastframe']] = statix[k]['lastframe'];
		if (statix[k][nda['curframe']]!=statix[k]['lastframe'])
		{
			swapit=1;
		}
		parent = this.statix_d[k].parent;
		parent2 = this.statix_d[k].parent;

//		this.n_data[k]['frame'] = 0;
		this.n_data[k][nda['_visible']] = statix[k]['_visible'];
		if ((typeof this['hide'] !== 'undefined')&&(typeof this['hide'][k] !== 'undefined'))
		{
			this.n_data[k][nda['_visible']]=this['hide'][k];
		}
//		if (this.n_data[k]['_visible']==2) this.n_data[k]['_visible']=0;
		if (typeof statix[k]['_alpha'] !== 'undefined') {
			this.n_data[k][nda['_alpha']] = statix[k]['_alpha'];
		}else this.n_data[k][nda['_alpha']] = 100;

		if ((parent>0)){
			this.n_data[k][nda['_xscale']]=this.n_data[parent][nda['_xscale']];
			this.n_data[k][nda['_yscale']]=this.n_data[parent][nda['_yscale']];
			this.n_data[k][nda['_alpha']]*=this.n_data[parent][nda['_alpha']]/100;
			if ((!this.n_data[parent][nda['_visible']])||(this.n_data[parent][nda['curframe']]>0)) this.n_data[k][nda['_visible']] = 0;
		}else{
			this.n_data[k][nda['_xscale']]=100;
			this.n_data[k][nda['_yscale']]=100;
		};


		if ((parent2>0)&&((!this.n_data[parent2][nda['_visible']])||(this.n_data[parent2][nda['curframe']]>0))) this.n_data[k][nda['_visible']] = 0;


		if ((statix[k]['curframe']>0)&&(typeof this.razmetka[statix[k]['curframe']] !== 'undefined')&&(this.razmetka[statix[k]['curframe']][mqc['mxscale']])){
			this.n_data[k][nda['_xscale']]=this.razmetka[statix[k]['curframe']][mqc['mxscale']];
			this.n_data[k][nda['_yscale']]=this.razmetka[statix[k]['curframe']][mqc['myscale']];
		}else{
			this.n_data[k][nda['_xscale']]*=this.statix_d[k]['_xscale']/100;
			this.n_data[k][nda['_yscale']]*=this.statix_d[k]['_yscale']/100;
		};

		if (this.n_data[k][nda['no_shadow']]){
			check_s_arrowed = 1;
		};



		this.n_data[k][nda['no_shadow']] = 0;

		if (parent>0){
//		  scaleMatrix  = statix[k]['matrix'].copy();
// 		  scaleMatrix3 = this.n_data[parent][nda['matrix']].copy();
		  scaleMatrix.m  = (statix[k]['matrix'].m.slice()) || [1, 0, 0, 1, 0, 0];
 		  scaleMatrix3.m = (this.n_data[parent][nda['matrix']].m.slice()) || [1, 0, 0, 1, 0, 0];
/*		  if (((this.statix_d[k]['name']=='head')||((this.statix_d[k].parent2)&&(this.statix_d[this.statix_d[k].parent2]['name']=='head'))||(this.statix_d[k]['name']=='phead')||(this.statix_d[k]['name']=='shead4')||(((this.statix_d[k]['name']=='rarm2')||(this.statix_d[k]['name']=='larm2'))&&((this.filename=='scorpupani')||(this.filename=='scorpani'))))&&((this.statix_d[parent]['name']!='ctelo')||((this.filename!='paladinani')&&(this.filename!='knightani')&&(this.filename!='championani')))&&(this.statix_d[parent]['name']!='head')){
			  scaleMatrix4.m  = [2.2, 0, 0, 2.2, 0, 0];
			  scaleMatrix.multiply(scaleMatrix4);
			  scaleMatrix4.m  = [1, 0, 0, 1, 0, 0];
		  };*/
			
		  if (need_draw_chain)
		  {
				if ((this.statix_d[k]['name']=='light')&&(this.statix_d[parent]['name']=='all')){
							  if (!this.arrow_line){
//								this.arrow_line = new KonvaGroup({hitGraphEnabled : false});
//								this.arrow_line1 = new KonvaLine({hitGraphEnabled : false});
								this.arrow_line = Make_Sprite();
								this.arrow_line1 = Make_Drawing();
								Make_addChild(this.arrow_line, this.arrow_line1);
								Make_addChild(this.mobject_arrow, this.arrow_line);
								Make_setZIndex(this.arrow_line, -1);

							  };
								this.arrow_line.link = k;

								var scale_koef = 1/get_scaleY(this.mobject)*scaleMatrix3.m[3]*this.scaling;
								var color = 0;
								var stroke_width = 1;
								var stroke_enable = true;
								var closed = false;

									for (var j=4;j>=1;j--)
									{
										var points = Array();
										var xx = 0;
										var yy = 0;
										for (var n=0;n<this.draw_chain.length;n++){
											var x2 = this.draw_chain[n].x/get_scaleX(this.mobject);
											var y2 = this.draw_chain[n].y/get_scaleY(this.mobject);
											var points_now = get_molnia_points(xx, yy, x2, y2, j);
											xx = x2;
											yy = y2;
											points = points.concat(points_now);
										};
										
										

										if (!this['arrow_line'+j]){
											this['arrow_line'+j] = Make_Drawing();
											Make_addChild(this.arrow_line, this['arrow_line'+j]);
										};
										stroke_width = 8/j*scale_koef;
										color = 255*65536+(200+Math.floor(55/j))*256+255;
										var alpha = Math.min(1,3/j);
										if (currentTip == 0) color = getHexColor(color);

										Make_lineStyle(this['arrow_line'+j], {stroke: color, closed: closed, strokeWidth: stroke_width, strokeEnabled: stroke_enable, opacity: Math.min(1,3/j)});
										drawLine(this['arrow_line'+j], points, color, stroke_width, alpha);	


									}
								

								this.draw_chain = 0;
				};
				
		  }

		  if (check_arrow){
			  var per_x = 0, real_x = 0, mult_x = 0, xpp = 0;
			  var per_y = 0, real_y = 0, mult_y = 0, ypp = 0;
			  this.n_data[k][nda['no_shadow']] = this.n_data[parent][nda['no_shadow']];
				
			  
			  for (var a=0;a<check_arrow_len;a++)
			  {
				  if (anim[this.anim][doing][1][0][3][a]['link']==k){
					  if ((this.frame>=anim[this.anim][doing][1][0][3][a]['start_frame'])&&(this.frame<=anim[this.anim][doing][1][0][3][a]['fin_frame']))
					  {
						  this.arrow_fly = true;
						  if ((anim[this.anim][doing][1][0][3][a]['type']==1)&&
							  
							  (
								  ((anim[this.anim][doing][1][0][3][a]['att_frame'])&&(this.frame<=anim[this.anim][doing][1][0][3][a]['att_frame']))||((!anim[this.anim][doing][1][0][3][a]['att_frame'])&&(this.frame<=anim[this.anim][doing][1][0][3][a]['fin_frame'])))
							  ){
									this.skip_frame = this.skip_delta;
							   };

						  if ((anim[this.anim][doing][1][0][3][a]['type']==1)&&(this.frame==anim[this.anim][doing][1][0][3][a]['start_frame'])){
								anim[this.anim][doing][1][0][3][a]['x1'] = scaleMatrix3.m[4] +  scaleMatrix.m[4];
								anim[this.anim][doing][1][0][3][a]['y1'] = scaleMatrix3.m[5] +  scaleMatrix.m[5];
							

//							    anim[this.anim][doing][1][0][3][a]['delta_x'] = scaleMatrix.m[4] - anim[this.anim][doing][1][0][3][a]['start_x'];
//							    anim[this.anim][doing][1][0][3][a]['delta_y'] = scaleMatrix.m[5] - anim[this.anim][doing][1][0][3][a]['start_y'];
								anim[this.anim][doing][1][0][3][a]['start_x'] = scaleMatrix.m[4];
								anim[this.anim][doing][1][0][3][a]['start_y'] = scaleMatrix.m[5];
						  }else{
							  if (!anim[this.anim][doing][1][0][3][a]['delta_x']){
								  anim[this.anim][doing][1][0][3][a]['delta_x'] = 0;
								  anim[this.anim][doing][1][0][3][a]['delta_y'] = 0;
							  };
						  };
/*						  if (anim[this.anim][doing][1][0][3][a]['type']==1){
							  if (this.frame==anim[this.anim][doing][1][0][3][a]['start_frame']){
									anim[this.anim][doing][1][0][3][a]['start_x'] = scaleMatrix.m[4];
									anim[this.anim][doing][1][0][3][a]['start_y'] = scaleMatrix.m[5];
							  };
						  };*/
						  if (anim[this.anim][doing][1][0][3][a]['type']==0){
							  if (anim[this.anim][doing][1][0][3][a]['start_x']==anim[this.anim][doing][1][0][3][a]['fin_x']){
								  var found = false;
								  for (var b=0;b<check_arrow_len;b++)
								  {
									  if ((a!=b)&&(anim[this.anim][doing][1][0][3][a]['fin_x']==anim[this.anim][doing][1][0][3][b]['fin_x'])&&(anim[this.anim][doing][1][0][3][a]['start_x']!=anim[this.anim][doing][1][0][3][b]['start_x']))
									  {
										  found = true;
										  anim[this.anim][doing][1][0][3][a]['start_x'] = anim[this.anim][doing][1][0][3][b]['start_x'];
										  anim[this.anim][doing][1][0][3][a]['start_y'] = anim[this.anim][doing][1][0][3][b]['start_y'];
									  }
								  }
								  found = false;
								  if (!found)
								  {
									  anim[this.anim][doing][1][0][3][a]['start_x'] = 0;
									  anim[this.anim][doing][1][0][3][a]['start_y'] = 0;
								  }
							  };

						  };


						  if (!anim[this.anim][doing][1][0][3][a]['scale_x']){
							  anim[this.anim][doing][1][0][3][a]['scale_x'] = 1;
							  anim[this.anim][doing][1][0][3][a]['scale_y'] = 1;
						  };
						  if (!anim[this.anim][doing][1][0][3][a]['tscale_x']){
							  anim[this.anim][doing][1][0][3][a]['tscale_x'] = 1;
							  anim[this.anim][doing][1][0][3][a]['tscale_y'] = 1;
						  };
//						  var tsx = Math.pow(scaleMatrix.m[0]*scaleMatrix.m[0]+scaleMatrix.m[1]*scaleMatrix.m[1], 0.5);
//						  var tsy = Math.pow(scaleMatrix.m[2]*scaleMatrix.m[2]+scaleMatrix.m[3]*scaleMatrix.m[3], 0.5);

						  tsx = anim[this.anim][doing][1][0][3][a]['tscale_x'];
						  tsy = anim[this.anim][doing][1][0][3][a]['tscale_y'];

						  var tsx2 = Math.pow(scaleMatrix3.m[0]*scaleMatrix3.m[0]+scaleMatrix3.m[1]*scaleMatrix3.m[1], 0.5);
						  var tsy2 = Math.pow(scaleMatrix3.m[2]*scaleMatrix3.m[2]+scaleMatrix3.m[3]*scaleMatrix3.m[3], 0.5);						  


						  real_x = anim[this.anim][doing][1][0][3][a]['shoot_x']/100*this.n_data[k][nda['_xscale']]*get_scaleX(this.mobject)/anim[this.anim][doing][1][0][3][a]['scale_x'];
						  real_y = anim[this.anim][doing][1][0][3][a]['shoot_y']/100*this.n_data[k][nda['_yscale']]*get_scaleY(this.mobject)/anim[this.anim][doing][1][0][3][a]['scale_y'];
						  var mx = 1/100*this.n_data[k][nda['_xscale']]*get_scaleX(this.mobject)/tsx;
						  var my = 1/100*this.n_data[k][nda['_yscale']]*get_scaleY(this.mobject)/tsy;
						 
						  var mx = 1/100*this.n_data[k][nda['_xscale']]*get_scaleX(this.mobject)/tsx;
						  var my = 1/100*this.n_data[k][nda['_yscale']]*get_scaleY(this.mobject)/tsy;
						  var sx = this.shoot_x;
						  var sy = this.shoot_y;
						  if (this.doing=='multishoot'){
							  if (this.statix_d[k]['name']=='arrow1'){
								  var sx = this.shoot_x3;
								  var sy = this.shoot_y3;
							  };
							  if (this.statix_d[k]['name']=='arrow2'){
								  var sx = this.shoot_x2;
								  var sy = this.shoot_y2;
							  };
						  };
						

						  mult_x = sx/real_x;
						  mult_y = sy/real_y;

						  var x1 = anim[this.anim][doing][1][0][3][a]['start_x'];
						  var y1 = anim[this.anim][doing][1][0][3][a]['start_y'];

						  var now = (scaleMatrix.m[4]-anim[this.anim][doing][1][0][3][a]['start_x'])/(anim[this.anim][doing][1][0][3][a]['fin_x']-anim[this.anim][doing][1][0][3][a]['start_x']);
						  var nowy = (scaleMatrix.m[5]-anim[this.anim][doing][1][0][3][a]['start_y'])/(anim[this.anim][doing][1][0][3][a]['fin_y']-anim[this.anim][doing][1][0][3][a]['start_y']);
						  var x2 = anim[this.anim][doing][1][0][3][a]['fin_x']*mult_x;
						  var y2 = anim[this.anim][doing][1][0][3][a]['fin_y']*mult_y;
							
//						  scaleMatrix.m[4] = x1+x2*now-x1*now*mult_x;
//						  scaleMatrix.m[5] = y1+y2*now-y1*now*mult_y;

//						  scaleMatrix.m[4] = x1+x2*now-x1*now;
///						  scaleMatrix.m[5] = y1+y2*now-y1*now;
						  var div_x = anim[this.anim][doing][1][0][3][a]['fin_x']/(sx/mx);
						  var div_y = (anim[this.anim][doing][1][0][3][a]['fin_y'])/(sy/my);
//						  var div_y = (anim[this.anim][doing][1][0][3][a]['start_y']-anim[this.anim][doing][1][0][3][a]['fin_y'])/(this.shoot_y/my);



						  if (anim[this.anim][doing][1][0][3][a]['type']==2){
							  if (this.frame>anim[this.anim][doing][1][0][3][a]['start_frame']) continue;

							  var alpha = 1;

							  if (!this.arrow_line){
								this.arrow_line = Make_Sprite();
								this.arrow_line1 = Make_Drawing();
								Make_addChild(this.arrow_line, this.arrow_line1);
								Make_addChild(this.mobject_arrow, this.arrow_line);
								Make_setZIndex(this.arrow_line, -1);

							  };
								this.arrow_line.link = k;
								var x2 = sx/get_scaleX(this.mobject);
								var y2 = -sy/get_scaleY(this.mobject);

//								scaleMatrix4 = scaleMatrix3.copy();
								scaleMatrix4.m  = (scaleMatrix3.m.slice()) || [1, 0, 0, 1, 0, 0];
								scaleMatrix4.multiply(scaleMatrix);

								var x1 = scaleMatrix4.m[4];
								var y1 = scaleMatrix4.m[5];
								var scale_koef = 1/get_scaleY(this.mobject)*scaleMatrix4.m[3]*this.scaling;
								var thik = 20;
								if ( anim[this.anim][doing][1][0][3][a]['lthikness'])
								{
									thik = anim[this.anim][doing][1][0][3][a]['lthikness'];
								}
								thik = thik*scale_koef*0.7;

								if (currentTip==0){
									var color =getHexColor(anim[this.anim][doing][1][0][3][a]['lstyle'][1]);
								};
								if (currentTip==1){
									var color =anim[this.anim][doing][1][0][3][a]['lstyle'][1];
								};
								var stroke_width = anim[this.anim][doing][1][0][3][a]['lstyle'][0]*scale_koef*0.7;
								var stroke_enable = true;
								var closed = false;

								
								if (anim[this.anim][doing][1][0][3][a]['molnia']){
									for (var j=4;j>=1;j--)
									{
										var points = get_molnia_points(x1, y1, x2, y2, j);
										if (!this['arrow_line'+j]){
											this['arrow_line'+j] = Make_Drawing();
											Make_addChild(this.arrow_line, this['arrow_line'+j]);
										};
										stroke_width = 8/j*scale_koef;
										color = 255*65536+(200+Math.floor(55/j))*256+255;

										if (currentTip==0) color = getHexColor(color);
										Make_lineStyle(this['arrow_line'+j], {stroke: color, closed: closed, strokeWidth: stroke_width, strokeEnabled: stroke_enable, opacity: Math.min(1,3/j)});
										
										drawLine(this['arrow_line'+j], points, color, stroke_width, alpha);	


									}
								}else{
									var points = get_rectangle_points(x1, y1, x2, y2, thik);
								};

								if (anim[this.anim][doing][1][0][3][a]['lstyle'][2]==0){
									stroke_enable = false;
								};
								if (anim[this.anim][doing][1][0][3][a]['bFill']){
										this.arrow_line1.closed = true;
										if (currentTip==0) var color2 = getHexColor(anim[this.anim][doing][1][0][3][a]['bFill'][0]);
										if (currentTip==1) var color2 = anim[this.anim][doing][1][0][3][a]['bFill'][0];

										Make_lineStyle(this.arrow_line1, {fill: color2, opacity: anim[this.anim][doing][1][0][3][a]['bFill'][1]/100});
										closed = true;
								};
								if (anim[this.anim][doing][1][0][3][a]['bGFill']){
									if (anim[this.anim][doing][1][0][3][a]['bGFill'][0]=='radial'){
										this.arrow_line1.closed = true;
										Make_lineStyle(this.arrow_line1, {closed: true, fill: anim[this.anim][doing][1][0][3][a]['bGFill'][1][0]});

									};
								};
								Make_lineStyle(this.arrow_line1, {stroke: color, closed: closed, strokeWidth: stroke_width, strokeEnabled: stroke_enable});
								drawLine(this['arrow_line1'], points, color, stroke_width, alpha);	
							    continue;
						  };


						  if (anim[this.anim][doing][1][0][3][a]['type']==0){
							  scaleMatrix.m[4] = (scaleMatrix.m[4])/div_x;
							  scaleMatrix.m[5] = -(scaleMatrix.m[5])/div_y;
							  scaleMatrix3.m[4] = 0;
							  scaleMatrix3.m[5] = 0;

						  }else{
							  var xx = x1*(1-now)+(scaleMatrix.m[4]-x1*(1-now))/div_x;
							  var yy = scaleMatrix.m[5]+(-sy/my-anim[this.anim][doing][1][0][3][a]['fin_y'])*(now);
							  if (this.chain_shot_start){
								  xx = this.chain_x + (sx/mx-this.chain_x)*now;
								  yy = this.chain_y + (-sy/my-this.chain_y)*now;
							  };
							  scaleMatrix.m[4] = xx;
							  scaleMatrix.m[5] = yy;


							  
							  scaleMatrix3.m[4] = scaleMatrix3.m[4]*(1-now);
							  scaleMatrix3.m[5] = scaleMatrix3.m[5]*(1-now);
							  if (this.chain_shot_start){
								  scaleMatrix3.m[4] = 0;
								  scaleMatrix3.m[5] = 0;
							  
							  };

						  };

						 var ax2 = anim[this.anim][doing][1][0][3][a]['fin_x']/div_x;
						 var ay2 = -anim[this.anim][doing][1][0][3][a]['fin_y']/div_y;
						 var ax1 = anim[this.anim][doing][1][0][3][a]['x1'];
						 var ay1 = anim[this.anim][doing][1][0][3][a]['y1'];


						  if ((this.shoot_def>0)&&((this.statix_d[k]['name']=='body')||(this.statix_d[k]['name']=='telo'))){
//								if (this.z!=zz){
									this.last_z = this.z;
									if (!this.was_z_change){
										var zz = stage[war_scr].obj[this.shoot_def].z+3;
										this.was_z_change = 1;
										var no_z = false;
										for (var v=1;v<=this['statix_len'];v++)
										{
											b = statix['depths'][v];
											if ((b!=k)&&(this.statix_d[k].parent == this.statix_d[b].parent)&&(statix[b]['_visible'])&&(statix[b]['_alpha']>0)){
												no_z = true;
											};
										};

										no_z = false;//pers_gnom mod
										if (!no_z){
											this.z = zz;
//											stage[war_scr].Zsort();
											need_sort = true;
										};
									};
									var xdir = this.last_scaleX/Math.abs(this.last_scaleX);
									var xy_a = getxa(this.x, this.y);
									p1 = xy_a.p;
									xy_a = getxa(stage[war_scr].obj[this.shoot_def].x, stage[war_scr].obj[this.shoot_def].y);
									p2 = xy_a.p;
									var nowscale = p1 + (p2 - p1)*now;
									var deltascale = nowscale/p1;
									scaleMatrix.scale(deltascale, deltascale);
									scaleMatrix.m[4] /= deltascale;
									scaleMatrix.m[5] /= deltascale;
//								};
						  };

						 

	

//						  scaleMatrix.m[4] = x1+this.shoot_x*now/mx-x1*now;

						  mycounter++;
						  var sx2 = sx, sy2 = sy;
						  if (this.chain_shot_start)
						  {
							  sx2 = sx/mx-this.chain_x;
							  sy2 = (-sy/my - this.chain_y)
							  ax2 = sx/mx;
							  ay2 = -sy/my;
							  ax1 = this.chain_x;
							  ay1 = this.chain_y;
						  }

						  if (anim[this.anim][doing][1][0][3][a]['fix_angle']==1)
						  {
							    
								//need_rot = Math.atan2(sy2, sx2)*180/Math.PI;

								var dy = -(ay2-ay1);
								if (sx2<0)
								{
									dy = -dy;
								}
								need_rot = Math.atan2(dy, ax2-ax1)*180/Math.PI;
								angle = anim[this.anim][doing][1][0][3][a]['angle_a']*90+need_rot*anim[this.anim][doing][1][0][3][a]['angle_b'];
								angle = angle*Math.PI/180;
/*								var scaleMatrixA = new MatrixTransform();
								scaleMatrixA.m[0] = Math.cos(angle);
								scaleMatrixA.m[1] = Math.sin(angle);
								scaleMatrixA.m[2] = -Math.sin(angle);
	
								scaleMatrixA.m[3] = Math.cos(angle);*/
								
//								scaleMatrixA.m[4] = (scaleMatrix.m[4] - anim[this.anim][doing][1][0][3][a]['start_x'])*mult_x+anim[this.anim][doing][1][0][3][a]['start_x'];
//								scaleMatrixA.m[5] = (scaleMatrix.m[5] - anim[this.anim][doing][1][0][3][a]['start_y'])*mult_y+anim[this.anim][doing][1][0][3][a]['start_y'];
								var dx = anim[this.anim][doing][1][0][3][a]['fin_x']-anim[this.anim][doing][1][0][3][a]['start_x'];
								dx = sx2;
								if ((anim[this.anim][doing][1][0][3][a]['angle_b']==-1)&&(anim[this.anim][doing][1][0][3][a]['angle_a']==0)){
									if (dx<0) angle = -angle;
								}else{
									if (dx<0){
//										scaleMatrixA.m[2] = -scaleMatrixA.m[2];
										angle = Math.PI+angle;
										angle = -angle;
									};
								};
	
								scaleMatrix.rotate(angle);
//								scaleMatrix.multiply(scaleMatrixA);
								
						  }


						  this.n_data[k][nda['no_shadow']] = 1;
						  check_s_arrowed = 1;

						  if ((this.chainshot)&&(this.frame==anim[this.anim][doing][1][0][3][a]['att_frame']-1)&&(this.statix_d[k]['name']=='arrow')){
								if (command.substr(0,4)=='Schs'){
									this.attacker = false;
									this.chain_shot_start = true;
									var v = getxa(this.x, this.y);
									var x1 = v.xc;var y1 = v.yc;
									var ti=tointeger(command.substr(7,3));
									var big = stage[war_scr].obj[ti].big;
									v = getxa(stage[war_scr].obj[ti].x+big*0.5, stage[war_scr].obj[ti].y+big*0.5);
									var x2 = v.xc - x1;
									var y2  =v.yc - y1;
									this.setshoot(x2, -y2);
									this.chain_x = xx;
									this.chain_y = yy;
									command = command.substr(19);
									this.attacker = true;
									this.set_frame = anim[this.anim][doing][1][0][3][a]['start_frame'];
									stage[war_scr].doComs();
									this.attacker = false;
								}else{
									this.chain_shot_start = false;
								};
						  };

					  }else{
						  if ((this.frame==anim[this.anim][doing][1][0][3][a]['fin_frame']+1)&&(this.was_z_change)){
							    this.was_z_change = 0;
								this.z = this.get_obj_z(this.y);
//								stage[war_scr].Zsort();
								need_sort = true;
						  };
					  };
				  };
			  }
				
		  };			



			scaleMatrix3.multiply(scaleMatrix);
		}else{
//			scaleMatrix3 = statix[k]['matrix'].copy();
			scaleMatrix3.m  = (statix[k]['matrix'].m.slice()) || [1, 0, 0, 1, 0, 0];
		};


		if ((this.arrow_line)&&(this.arrow_line.link == k))
		{
			set_visible(this.arrow_line, this.n_data[k][nda['_visible']]);
			set_Alpha(this.arrow_line, this.n_data[k][nda['_alpha']]/100);
			if (!this.n_data[k][nda['_visible']])
			{
				this.arrow_line.link = 0;
			}
		}



		scaleMatrix2 = new MatrixTransform();



scaleMatrix2 = new MatrixTransform();
        
        // Use custom transform parameters for replacement sprites.
        var custom_cfg = null;
        if (this.custom_image && this.custom_replacements_map && this.custom_replacements_map[k] && custom_replacement_has_filename(this.custom_replacements_map[k])) {
             custom_cfg = this.custom_replacements_map[k];
        }

        if (custom_cfg) {
            // Custom offset, scale, and rotation.
            var cx = (typeof custom_cfg.offset_x !== 'undefined') ? custom_cfg.offset_x : 0;
            var cy = (typeof custom_cfg.offset_y !== 'undefined') ? custom_cfg.offset_y : 0;
            var csx = (typeof custom_cfg.scale_x !== 'undefined') ? custom_cfg.scale_x : 1;
            var csy = (typeof custom_cfg.scale_y !== 'undefined') ? custom_cfg.scale_y : 1;
            var crot = (typeof custom_cfg.rotation !== 'undefined') ? custom_cfg.rotation : 0;

            // Keep the parent transform orientation and separate its scale.
            var pM = (scaleMatrix3.m.slice()) || [1, 0, 0, 1, 0, 0];
            var pSx = Math.sqrt(pM[0]*pM[0] + pM[1]*pM[1]);
            var pSy = Math.sqrt(pM[2]*pM[2] + pM[3]*pM[3]);
            var avgS = (pSx + pSy) / 2; 
            if (avgS < 0.001) avgS = 1;

            // Normalize parent scale before applying custom image scale.
            scaleMatrix3.m[0] /= pSx; scaleMatrix3.m[1] /= pSx;
            scaleMatrix3.m[2] /= pSy; scaleMatrix3.m[3] /= pSy;

            // Translate in the original part coordinate space.
            scaleMatrix2.translate(cx, cy);

            // Rotate the replacement image.
            if (crot !== 0) {
                scaleMatrix2.rotate(crot * (Math.PI / 180));
            }

            // Scale the replacement image.
            if (csx !== 1 || csy !== 1) {
                scaleMatrix2.scale(csx * avgS, csy * avgS);
            } else {
                scaleMatrix2.scale(avgS, avgS);
            }

        } else {
            // Original part transform.
            if ((statix[k]['curframe']>0)&&(typeof this.razmetka[statix[k]['curframe']] !== 'undefined')&&(this.razmetka[statix[k]['curframe']]!=0)){
                j = statix[k]['curframe'];
                sdx = this.razmetka[j][mqc['sdx']];
                sdy = this.razmetka[j][mqc['sdy']];
                var _as = this.razmetka[j][mqc['anim_scale']];
                if ((_as != undefined) && (_as != 0)){
                        sdx*=_as;
                        sdy*=_as;
                        this.n_data[k][nda['_xscale']]*=_as;
                        this.n_data[k][nda['_yscale']]*=_as;
                };
            }else{
                sdx = this.statix_d[k].sdx;
                sdy = this.statix_d[k].sdy;
            };
            scaleMatrix2.translate(sdx, sdy);	
            scaleMatrix2.scale(100/this.n_data[k][nda['_xscale']], 100/this.n_data[k][nda['_yscale']]);
        }

//		scaleMatrix = scaleMatrix3.copy();
		scaleMatrix.m  = (scaleMatrix3.m.slice()) || [1, 0, 0, 1, 0, 0];

		scaleMatrix.multiply(scaleMatrix2);
		diff = false;

		
		


		if (!this.n_data[k][nda['matrix']]){
			this.n_data[k][nda['matrix']] = new MatrixTransform();
		};
		if (!this.n_data[k][nda['matrix2']]){
			this.n_data[k][nda['matrix2']] = new MatrixTransform();
		};
		this.n_data[k][nda['matrix']].m  = (scaleMatrix3.m.slice()) || [1, 0, 0, 1, 0, 0];
		this.n_data[k][nda['matrix2']].m  = (scaleMatrix.m.slice()) || [1, 0, 0, 1, 0, 0];
//		this.n_data[k][nda['matrix']].m[6] = checksum;






		
		if ((typeof this.n_data[k][nda['lastframe']] !== 'undefined')&&(this.n_data[k][nda['curframe']]!=this.n_data[k][nda['lastframe']])){
			  j = this.n_data[k][nda['lastframe']];
			  if (j==0) j = k;
			  if ((typeof this['image'+j] !== 'undefined')&&(old_shadow)) {
				  set_visible(this['image'+j], 0);
				  if (this.shadow) set_visible(this['2image'+j], 0);
			  };
		};



	  }

	  if (this.attach_stone) swapit = 0;

      check_s_arrowed = 1;

	  if ((swapit==1)&&(true)){
		  this.dynamic['swapit'] = 0;
		  for (var k = this['statix_len']; k>=1; k--)
		  {
			i = statix['depths'][k];

			if (!this.n_data[i]) continue;

			if (this.n_data[i][nda['curframe']]>0){
			    j = this.n_data[i][nda['curframe']];
			}else{
			    j = i;
			};	
			
var img = this['image'+j];
if (typeof img !== 'undefined') {
  if ((!this.magic_spell) && check_s_arrowed) {
    if (this.n_data[i][nda['no_shadow']]) {
      if (!img.arrowed) { img.arrowed = true; Make_setParent(img, this.mobject_arrow); }
    } else {
      if (img.arrowed) { img.arrowed = false; Make_setParent(img, this.unit); }
    }
  }
  Make_setZIndex(img, 1000 - k);
}

		  };
	  };

	  if (this.set_frame){
		  this.frame = this.set_frame;
		  this.set_frame = 0;
	  };
	  
	
	};
   function engine_rand(){
       if (typeof engine_rand_var === 'undefined') {
          if (typeof warid !== 'undefined')
          {
               engine_rand_var = warid;
          }else{
             return Math.random();
          };
       };

       var t = (engine_rand_var*10001+3)%19417;
       engine_rand_var = Math.floor(t);
       return  Math.abs(t/19417);
   };


	function animate_continue(deep, nocache, no_back_frame, no_sound){
		var j = 0;
		var k = 0;
		var swapit = 0;
		var changed = false;
		var scaleMatrix = new Konva.Transform();
		var cframe = 0;
		var doing = '';
		var restore_rise_visibility = false;
		var rise_summoned = false;
		if (this.attachstone)
		{
			return 0;
		}
		doing = this.doing;
		if (typeof this.frame === 'undefined')
		{
			this.frame=0;
		}
		
		if (doing=="")
		{
			this.lastdoing = "";
			return 0;
		}
		if ((this.shoot_teleport_fallback)&&((doing=="shootteleport_go")||(doing=="shootteleport_back"))){
			animate_shoot_teleport_fallback(this);
			return 0;
		};
		if ((!this.shoot_teleport_fallback)&&(can_use_shoot_teleport_fallback(this, doing))){
			if (init_shoot_teleport_fallback(this)){
				this.doing = "shootteleport_go";
				this.lastdoing = "";
				this.frame = 0;
				animate_shoot_teleport_fallback(this);
				return 0;
			};
		};
      if (this.doing=="shoot")
      {
         if (typeof anim[this.anim]["shoot"] === "undefined"){
            this.doing = "attack";
            doing = "attack";
         };
      }
		if ((this.doing=="shoot")&&(this.special_attack)){
			if (typeof anim[this.anim]["spec_shoot"] !== 'undefined'){
				this.doing = "spec_shoot";
			};
			this.special_attack = false;
		};

		if ((this.doing.substr(0, 6)=="attack")&&(this.bite)){
			this.doing = "cast";
		};
		if ((this.doing.substr(0, 6)=="attack")&&(this.fire_attack)){
			this.doing = "cast";
		};
		if ((this.doing.substr(0, 6)=="attack")&&(this.bash_attack)&&(typeof anim[this.anim]["bashattack"] !== 'undefined')){
			this.doing = "bashattack";
         doing = "bashattack";
         this.bash_attack = false;
		};


		if ((this.doing=="cast")&&((this.bite)||(this.fire_attack))&&(this.frame>0)&&(typeof anim[this.anim][doing][this.frame+1] === 'undefined')){
			this.bite = false;
			this.fire_attack = false;
			this.attacker = 1;
		};


		if ((this.doing.substr(0, 4) == "rise")&&(this.frame==0)&&(!no_back_frame)){
			rise_summoned = ((magic[this.obj_index])&&(magic[this.obj_index]['sum']));
			if (rise_summoned){
				restore_rise_visibility = true;
				this.mvisible = true;
				set_visible(this.layer, 1);
				set_visible(this.mobject, 1);
				if (this.under_layer3) set_visible(this.under_layer3, 1);
				this.cached = false;
				this.need_refresh = 1;
				this.need_cache = 1;
			};
			doing = "die";
			if ((magic[this.obj_index])&&(magic[this.obj_index]['dua'])&&(magic[this.obj_index]['dua']['effect']==1))
			{
				doing += "2";
			}
			this.doing = doing;
			this.frame = anim[this.anim][doing].length-1;
			this.back_frame = 1;
		};


		if ((this.doing == "return")&&(this.frame==0)&&(!no_back_frame)){
			doing = "invis";
			this.doing = doing;
			this.frame = anim[this.anim][doing].length-1;
			this.back_frame = 1;
		};

		if ((this.back_frame)&&(!no_back_frame)){
			this.statix_to_dynamic();
			this.set_statix(this.dynamic);
			this.frame_was = this.frame;
			this.frame = 0;
			this.back_frame = 0;

			this.doing_was = this.doing;
			while ((this.frame<this.frame_was)&&(this.doing!='')){
				this.animate_continue(1, 0, 1, 1);
			};
			this.doing = this.doing_was;
			this.back_frame = 1;
			this.frame = this.frame_was;
			if (restore_rise_visibility){
				this.mvisible = true;
				set_visible(this.layer, 1);
				set_visible(this.mobject, 1);
				if (this.under_layer3) set_visible(this.under_layer3, 1);
				this.cached = false;
				this.need_refresh = 1;
				this.need_cache = 1;
			};
		};

		if ((this.lastdoing)&&(this.lastdoing.substr(0, 4) == 'free')&&(this.was_free == 1)&&(this.doing!="")&&(this.doing.substr(0, 4)!="free")){
			this.was_free = 0;
			this.def_pos();
		};
		if (((this.lastdoing=="")||(this.back_frame))&&(doing!="")){
			if (currentTip==0){
			  this.layer.clearCache();
			  this.mobject.clearCache();
//			  this.unit.clearCache();
			  this.under_layer.clearCache();
			  this.under_layer2.clearCache();
			  this.under_layer3.clearCache();
			};
		};
		animation_check(this);
		this.lastdoing=doing;

		if (this.back_frame) this.frame--;else this.frame++;

		var frame = this.frame;
		if ((frame == 1)&&(doing == 'cast')&&(typeof anim[this.anim][doing][frame+1] === 'undefined')){
			if (this.darkattack){
			}else{
				doing = 'attack';
				this.doing = doing;
			};
		};
		if ((frame == 1)&&(doing == 'attack')&&(typeof anim[this.anim][doing][frame+1] === 'undefined')){
            if ((typeof anim[this.anim]['shoot'] !== 'undefined')&&(typeof anim[this.anim]['shoot'][frame+1] !== 'undefined'))
            {
               doing = 'shoot';
               this.doing = doing;
            }
		};

		if ((frame==1)&&(this.dualforms)&&(doing.substr(0, 5)!='trans')&&(magic[this.obj_index])&&(magic[this.obj_index]['dua'])&&(magic[this.obj_index]['dua']['effect']==1)&&(!no_back_frame)){
			doing += '2';
			this.doing = doing;
		};
		if (this.ddx){
			var totalf = anim[this.anim][doing].length-1;
			for (var z = 1;z<totalf;z++){
				if (anim[this.anim][doing][z]['attacker'] == 1){
					totalf = z+1;
					break;
				};
			};
						var xx=this.fx+(this.ddx-this.fx)*frame/totalf;
						var yy=this.fy+(this.ddy-this.fy)*frame/totalf;
						if (frame==totalf){
							this.x=xx;
							this.y=yy;
							this.ddx = 0;
							var bb = 1;
							if ((this.bb)&&(this.bb==-1)) bb = -1;
						}else{
							var bb = 1;
							if (this.fx>this.ddx) bb = -1;
							this.bb = bb;
						};

						var yk=0.5-Math.abs((frame/totalf-0.5));
						this.set_pole_pos(xx, yy-yk*2.5, bb);
		};

		if (this.doing=="invis"){
			this.setInvis = Math.min(45, this.frame*2);
			this.init_filters();
			if (this.is_enemy) {
//				this.layer.setAttr('opacity', Math.max(0, 1-this.frame/20));
				set_Alpha(this.under_layer, Math.max(0, 1-this.frame/20));
			};
		};

		if (this.doing=="hide"){
			if (this.frame<this.cur_frame_need){
				this.frame++;
				
//				this.layer.setAttr('opacity', Math.max(0, 1-this.frame/this.cur_frame_need));
				set_Alpha(this.under_layer, Math.max(0, 1-this.frame/this.cur_frame_need));
				return 0;
			}else{
				this.y = -100;
			};
		};



		if ((typeof this.anim !== 'undefined')&&((typeof anim[this.anim][doing] === 'undefined')||(typeof anim[this.anim][doing][frame] === 'undefined') || (typeof anim[this.anim][doing][frame][0] === 'undefined') ||(typeof anim[this.anim][doing][frame][0][0] === 'undefined')||((anim[this.anim][doing][frame][0]==0)&&(typeof anim[this.anim][doing][frame+1] === 'undefined'))))
		{
			if ((this.shoot_teleport_fallback)&&(this.shoot_teleport_fallback.phase=='attack')&&(doing.substr(0, 6)=='attack')){
				this.shoot_teleport_fallback.phase = 'back_out';
				this.shoot_teleport_fallback.frame = 0;
				this.doing = "shootteleport_back";
				this.lastdoing = "";
				this.frame = 0;
				animate_shoot_teleport_fallback(this);
				return 0;
			};
			if (this.doing.substr(0, 5)=='trans'){
				this.save_cur_dynamic();
			};
			this.invis_was = false;
			if ((this.doing=="invis")&&(this.is_enemy)&&(!this.back_frame)&&(!no_back_frame)) {
				this.x = -10;
				this.y = -100;
				this.set_pole_pos(this.x, this.y);
			};

			if (((this.doing.substr(0, 3)!="die")||(this.back_frame))&&(this.doing!="down")&&(!this.magic_spell)&&(!this.bonus)){
				this.statix_to_dynamic();
				this.set_statix(this.dynamic);
			}else{
				if ((this.hide_after_use)||((this.spellname=='firewall')&&(this.doing.substr(0,3)=='die'))||(this.hero)||((magic[this.obj_index])&&(magic[this.obj_index]['sum'])
					&&((this.spellname!='demongate')||(this.doing.substr(0,3)=="die"))&& ((!this.bonus)||(this.doing.substr(0,3)=="die"))  ) )
				{
					this.mvisible = false;
					set_visible(this.mobject, 0);
//					this.mobject.visible(0);
				};			
			};

			if (this.doing=='upcast'){
					this.mvisible = false;
					set_visible(this.mobject, 0);
//					this.mobject.visible(0);
					this.x = -10;
					this.y = -10;
					this.set_pole_pos(this.x, this.y);
			};
			if (this.mvisible) this.need_cache = 1;
			this.frame = 0;
		    this.arrow_fly = false;
			this.was_free = 0;
			this.back_frame = 0;
			this.stage = 0;
			this.at = 0;
			if ((typeof bomb_die !== 'undefined')&&(bomb_die)&&(this.it_unit)&&(!this.magic_spell)&&(!this.skip_bomb_die)&&(doing.substr(0, 3)=="die")){
				this.bomb_die_hold = 1;
				this.bomb_die_progress = 1;
			};
			this.doing = "";
			this.lastdoing = "";
			this.skip_frame = 0;
			this.was_active = true;
			if ((this.shoot_requested)||(this.shoot_teleport_fallback)){
				set_Alpha(this.under_layer, 1);
			};
			this.shoot_requested = false;
			this.shoot_teleport_fallback = false;
			return 0;
		};
		if ((frame == 1)&&(!this.dualforms)&&((doing=='attack')||(doing=='cast')||(doing.substr(0, 5)=='shoot'))){
			this.cast_start = 0;
			if (typeof this['last_'+doing] === 'undefined'){
				this['last_'+doing] = 1;
  	  	  	   if ((Object.size(anim[this.anim][doing+'2'])>1)&&(engine_rand()<=0.5)&&(!this.magic_spell))
				{
      				this['last_'+doing] = 2;
                  this.doing = doing+'2';
				}
			}else{
				if (this['last_'+doing]==1){
					this['last_'+doing] = 2;
					if (Object.size(anim[this.anim][doing+'2'])>1)
					{
						doing = doing+'2';
						this.doing = doing;
					}
				}else{
					this['last_'+doing] = 1;
				};
			};
			if (((this.pawstrike)||(this.assault))&&(doing.substr(0, 6)=='attack')){
				doing = 'attack';
				if ((this.at == 1)&&(Object.size(anim[this.anim][doing+'2'])>1)) doing = 'attack2';
            if (this.id == 1346)
            {
   				if (Object.size(anim[this.anim][doing+'2'])>1) doing = 'attack2';
	   			if (this.at == 1) doing = 'attack';
            }
            this.at = 0;
				this.doing = doing;
			};
			if ((doing.substr(0, 5) == 'shoot')&&(this.shoot_y!=0)){
//				doing = 'shoot2';
//				this.doing = doing;
				if (this.shoot_y<0){
					if (anim[this.anim]['shootsomedown']){
						doing = 'shootsomedown';
						this.doing = doing;
					};
					if ((Math.abs(this.shoot_x)/this.shoot_y>=-6.5)&&(anim[this.anim]['shootdown'])){
						doing = 'shootdown';
						this.doing = doing;
					};

				}else{
					if ((Math.abs(this.shoot_x)/this.shoot_y<=4.5)&&(this.shoot_y>0)&&(anim[this.anim]['shootup'])){
						doing = 'shootup';
						this.doing = doing;
					};
				};
			};
		};
		if (typeof this.anim === 'undefined')
		{
			return 0;
		}
		len = anim[this.anim][doing][frame][0][0];
		if ((anim[this.anim][doing][frame]['attacker'] == 1)&&((this.fire_attack)||(this.bite)||(doing.substr(0, 4)!='cast'))){
			if (this.obj_attacker){
				stage[this.container].obj[this.obj_attacker].attacker = true;
			};
			this.bite = false;
			this.fire_attack = false;
			this.attacker = 1;
		};
		if ((anim[this.anim][doing][frame]['sound'])&&(soundeff)&&(!no_sound)&&(!this.back_frame)){
			var volume = 100;
			var sound_back = 0;
			if (anim[this.anim][doing][frame]['sound_vol']) volume = anim[this.anim][doing][frame]['sound_vol'];
			if (anim[this.anim][doing][frame]['sound_back']) sound_back = anim[this.anim][doing][frame]['sound_back'];
			playsound(this.obj_index, anim[this.anim][doing][frame]['sound'], volume, sound_back);
		};
	
		if ((anim[this.anim][doing][frame]['waiting_start'] == 1)||((this.no_magic)&&(anim[this.anim][doing][frame]['attacker'] == 1)&&(doing.substr(0, 4)=='cast'))){
			if (this.portal)
			{
				if (this.mvisible) this.need_cache = 1;
				this.frame = 0;
				this.arrow_fly = false;
				this.was_free = 0;
				this.back_frame = 0;
				this.stage = 0;
				this.at = 0;
				this.doing = "";
				this.lastdoing = "";
				this.skip_frame = 0;
				this.was_active = true;
			}
			if (this.no_magic){
				this.attacker = 1;
			}else{
				this.cast_start = 1;
			};
		};
		if (anim[this.anim][doing][frame]['swalk'] == 1){
//			this.prihod = false;
			this.stage = 2;
		};

		this.dynamic['swapit'] = 0;
		if (anim[this.anim][doing][frame][0][1])
		{
			for (var k=1;k<=anim[this.anim][doing][frame][0][1][0];k++)
			{
				this.dynamic['depths'][k]=anim[this.anim][doing][frame][0][1][k];
			}
			this.dynamic['swapit'] = 1;
		}

		for (var i=len;i>=1;i--)
		{
			if (anim[this.anim][doing][frame][i])
			{
				k = anim[this.anim][doing][frame][i][0];	
				if (!this.dynamic[k])
				{
					continue;
				}
				this.dynamic[k]['_visible'] = anim[this.anim][doing][frame][i][7];
				if (this.dynamic[k]['_visible']){
					for (j=1;j<=6;j++)	scaleMatrix.m[j-1] = anim[this.anim][doing][frame][i][j];
					if (typeof anim[this.anim][doing][frame][i] !== 'undefined') {
						this.dynamic[k]['_alpha'] = anim[this.anim][doing][frame][i][8];
					} else this.dynamic[k]['_alpha'] = 100;
					cframe = 0;
					if (typeof anim[this.anim][doing][frame][i][9] !== 'undefined'){cframe = anim[this.anim][doing][frame][i][9];};
					/*DELETE*/
					if (typeof anim[this.anim][doing][frame][i][10] !== 'undefined'){this.dynamic[k]['_xscale'] = anim[this.anim][doing][frame][i][10];};
					if (typeof anim[this.anim][doing][frame][i][11] !== 'undefined'){this.dynamic[k]['_yscale'] = anim[this.anim][doing][frame][i][11];};

					this.dynamic[k]['lastframe'] = this.dynamic[k]['curframe'];
					this.dynamic[k]['curframe'] = cframe;

				};
//				this.dynamic[k]['matrix'] = scaleMatrix.copy();
				this.dynamic[k]['matrix'].m  = (scaleMatrix.m.slice()) || [1, 0, 0, 1, 0, 0];

			}
		}
		if (no_back_frame==1) return 0;


		if ((doing.substr(0, 4)=='walk')||(doing.substr(0, 8)=='stopwalk')){
			if (typeof anim[this.anim][doing][frame][0][2] !== 'undefined'){
				if (doing.substr(0, 4)=='walk')
				{
					this['walkspeed'] = Math.min(this['walkspeed'], anim[this.anim][doing][frame][0][2]);
				}else{
					this['walkspeed'] = Math.max(this['walkspeed'], anim[this.anim][doing][frame][0][2]);
				};
			}else{
				this['walkspeed'] = this.statix_d['walkspeed'];
			};
		};

		if (typeof anim[this.anim][doing][frame]['goto'] !== 'undefined')
		{
			this.frame=anim[this.anim][doing][frame]['goto'];
		}

		if ((typeof anim[this.anim][doing][frame]['swalk'] !== 'undefined')&&(this.next_doing=='stopwalk'))
		{
			this.frame=0;
			this.doing = 'stopwalk';
			this.next_doing = '';
		}

		this.set_statix(this.dynamic);
		var skip_frame = 0;
		if (!no_back_frame) no_back_frame = 0;
		if (this.skip_frame) {skip_frame = this.skip_frame;};
		if ((deep<animspeed+skip_frame)&&(doing!='free1')&&(doing!='free2')&&(!no_back_frame)&&(typeof anim[this.anim][doing][frame+1] !== 'undefined')&&((!this.magic_spell)||((this.active_spell)&&(!this.slow_spell))))
		{	
			this.animate_continue(deep+1, nocache, no_back_frame, no_sound);	
		}else{
//			if ((this.fast_continue)&&(this.doing=='stopwalk')&&(deep<2*animspeed)){
//				this.animate_continue(this.doing, deep+1);
//			};
		};
	};





	function set_data(no_reset){	  
	  var xs=0, ys=0, rot=0, j=0, k=0, m = 0;
	  if (currentTip == 1) var pm = new PIXI.Matrix;
	  var bomb_state = get_bomb_die_state(this);
	  var matrix2 = 0;

	  for (var i=1;i<=this['statix_len'];i++)
	  {
		  if (!this.n_data[i])
		  {
			  continue;
		  }
		  if ((typeof this.n_data[i][nda['curframe']] !== 'undefined')&&(this.n_data[i][nda['curframe']]>0)){
			  j = this.n_data[i][nda['curframe']];
		  }else{
			  j = i;
		  };

		  if ((typeof this.n_data[i][nda['lastframe']] !== 'undefined')&&(this.n_data[i][nda['curframe']]!=this.n_data[i][nda['lastframe']])){
			  k = this.n_data[i][nda['lastframe']];
			  if (k==0) k = i;
		  };
		  if (typeof this['image'+j] !== 'undefined'){
			  if (this.n_data[i][nda['_visible']]==1)
			  {
				  matrix2 = this.n_data[i][nda['matrix2']];
				  var bomb_fragmented = false;
				  if (bomb_state){
					  bomb_fragmented = show_bomb_fragments_for_part(this, i, this['image'+j], matrix2, this.n_data[i][nda['_alpha']]/100, bomb_state, no_reset);
					  if (!bomb_fragmented){
						  matrix2 = get_bomb_die_matrix(this, i, matrix2, bomb_state);
					  };
				  }else{
					  hide_bomb_fragments_for_part(this, i);
					  hide_bomb_part_blood_for_part(this, i);
				  };


				  if (!bomb_fragmented){
					  if (currentTip == 0){
	  					  this['image'+j].visible(1);

						  this['image'+j].matrix = matrix2;
					  }else if (currentTip == 1){
						  pm.a = matrix2.m[0];
						  pm.b = matrix2.m[1];
						  pm.c = matrix2.m[2];
						  pm.d = matrix2.m[3];
						  pm.tx = matrix2.m[4];
						  pm.ty = matrix2.m[5];
						  this['image'+j].transform.setFromMatrix(pm);
						  this['image'+j].visible = 1;
					  };
		  
					  set_Alpha(this['image'+j], this.n_data[i][nda['_alpha']]/100);
					  
					  if (!no_reset) this['image'+j]._cache = {};
					  custom_image_apply_part_color_filter(this, i, this['image'+j]);
					  if (bomb_state){
						  var bomb_blood_part = ensure_bomb_part_blood_for_part(this, i, this['image'+j]);
						  if (bomb_blood_part){
							  var blood_alpha = Math.min(1, (this.n_data[i][nda['_alpha']]/100)*(0.9 + bomb_die_rand((this.bomb_die_seed || 0) + i*71)*0.16));
							  apply_bomb_overlay_matrix(bomb_blood_part.sprite, matrix2, blood_alpha, no_reset);
						  }else{
							  hide_bomb_part_blood_for_part(this, i);
						  };
					  }else{
						  hide_bomb_part_blood_for_part(this, i);
					  };
				  }else{
					  set_visible(this['image'+j], 0);
					  hide_bomb_part_blood_for_part(this, i);
				  };

				  if ((this.shadow)&&(old_shadow)){
					  if ((bomb_fragmented)||(this.n_data[i][nda['no_shadow']])){
						  set_visible(this['2image'+j], 0);
					  }else{
				  
						  if (currentTip == 0){
							this['2image'+j].matrix = matrix2;
							this['2image'+j].visible(1);
						  }else if (currentTip == 1){
							  this['2image'+j].visible = 1;
							  this['2image'+j].transform.setFromMatrix(pm);
						  };


						//  this['2image'+j].transform  = this.n_data[i][nda['matrix2']];
						  set_Alpha(this['2image'+j], this.n_data[i][nda['_alpha']]/100);
		
						  this['2image'+j]._cache = {};
					  };
				  };

			  }else{
				  hide_bomb_fragments_for_part(this, i);
				  hide_bomb_part_blood_for_part(this, i);
				  if (currentTip == 0){
					this['image'+j].visible(0);
					if ((this.shadow)&&(old_shadow)) this['2image'+j].visible(0);
				  };
				  if (currentTip == 1){
					this['image'+j].visible = 0;
					if ((this.shadow)&&(old_shadow)) this['2image'+j].visible = 0;
				  };
			  };
		  };
	  }
	  if (this.shadow_layer_under){
		  set_visible(this.shadow_layer_under, (this.shadow)&&(!bomb_state));
	  };
	  this.show_obj();
	};
//var cccc=0;



	function show_obj_konva(shadow_ref){
	  if ((this.mvisible!=false)&&(this.layer.visible()))
	  {
		  this.mobject.visible(1);
		  this.under_layer3.visible(1);
		  if ((this.magic_spell)&&(this.doing!='')){
			  return 0;
		  }
		  if ((!this.magic_spell)&&(this.unit_layer)&&(this.unit_layer.it_is_unit_layer)&&(!((this.x<60)&&(this.x>-9)&&(this.y>-5)&&(this.y<60)))){
			  this.mobject.visible(0);
			  this.under_layer3.visible(0);
			  return 0;
		  };
		  if ((!this.unit_layer)&&(!this.shadow)) return 0;
		  

		  var offset = 0;
 		  if ((!this.need_cache)&&(this.doing!="")){
			  if (this.shadow){

				  this.shadow_layer.cache({pixelRatio: shadow_pixel_ratio});
			  };
		  };
		  var unit_filters = null;
		  try{
			  if ((this.unit)&&(this.unit.konva_obj)&&(this.unit.filters)) unit_filters = this.unit.filters();
		  }catch(e){};
		  if ((unit_filters)&&(unit_filters.length)&&((this.doing!='')||(this.need_refresh)||(this.need_cache))){
			  set_cache(this.unit, false);
			  this.unit.cache();
		  };
		  no_filter = true;
		  if (((this.underFilter)||(this.shadowed))&&((this.doing!='')||(this.need_refresh)||(this.need_cache)))
		  {
			  set_cache(this.under_layer, false);	
			  this.under_layer.cache();
		  };
		  if (this.need_refresh){
 			  set_cache(this.under_layer3, false);
			  if (!this.need_cache){
				  if (this.shadow_refresh){
					  this.shadow_refresh = 0;
				  };
			  };
			  this.need_refresh = 0;
		  };
		  if ((this.doing=="")||(this.need_cache)){
			  if (this.shadow){
				  this.shadow_layer.cache({pixelRatio: shadow_pixel_ratio})
			  };
			  this.under_layer3.no_filter = true;
			  this.under_layer3.cache();
			  this.need_cache = 0;
			  this.shadow_refresh = 0;
		  };



	  }else{
		  this.under_layer3.visible(0);
	  };
	};




	function show_obj_pixi(shadow_ref){
	  if (this.magic_spell){
		  this.layer.visible = this.mvisible;
	  };

	  
	  if ((this.mvisible!=false)&&(this.layer.visible))
	  {

		  if ((this.doing != '')||(this.active)){
				  if (this.doing!='')
				  {
					  this.was_walk = true;
				  }
				  if (this.cached){
					  this.under_layer3.cacheAsBitmap = false;
					  this.cached = false;
					  if ((this.x<60)&&(this.x>-9)&&(this.y>-5)&&(this.y<60)){
//							if (!this.magic_spell) set_cache(this.under_layer3, true);
//							this.cached = true;
							this.need_refresh = 0;
					  };
				  };
		   }else {
				  if (!this.cached){
						  if ((this.x<60)&&(this.x>-9)&&(this.y>-5)&&(this.y<60)){
								 if (this.under_shadow) this.under_layer3.under_shadow = true; else this.under_layer3.under_shadow = false;
								 if (!this.magic_spell) {
									 set_cache(this.under_layer3, true);
							  	     this.cached = true;
								 };
								 this.need_refresh = 0;
						  };
				  };
		  };
		  if ((this.magic_spell)&&(this.doing!='')) return 0;

		  var offset = 0;
//		  if (this.shadowed){
//			  offset = shadow_glow_radius/2;
//		  };



		  if ((this.need_refresh)&&((this.doing=='')||(this.need_refresh==2))){
			  if ((this.layer.visible)&&(this.x<60)&&(this.x>-9)&&(this.y>-5)&&(this.y<60))
			  {
					  if (this.under_shadow) this.under_layer3.under_shadow = true; else this.under_layer3.under_shadow = false;
				      if (!this.magic_spell) {
						  set_cache(this.under_layer3, true);
						  this.cached = true;
					  };
			  }else{
				  this.layer.visible = false;
			  };
			  this.need_refresh = 0;
		  };

	  };
	  if ((this.x>60)||(this.x<-9)||(this.y<-5)||(this.y>60)||(!this.mvisible)){
		  this.layer.visible = false;
	  };
	  


	};

	function pixi_re_cache(sprite){
		sprite.cacheAsBitmap = false;
		sprite.cacheAsBitmap = true;
	};

		  
			
	function set_pos(x, y, xscale, yscale){
		var kf = 1;
/*		if ((!this.building)&&(!this.rock)&&(!this.statix)){
			kf = 1.5;
		};*/
		xscale = xscale/100/this.statix_d['obj_scale']*100*this.scaling/kf;
		yscale = yscale/100/this.statix_d['obj_scale']*100*this.scaling/kf;
		this.size_scale = yscale;
		if (this.magic_spell){
			set_X(this.under_layer, x);
			set_Y(this.under_layer, y);
		}else{
			set_X(this.layer, Math.floor(x));
			set_Y(this.layer, Math.floor(y));
		};
		this._x = x;
		this._y = y;
		set_scaleX(this.mobject, xscale);
		set_scaleY(this.mobject, yscale);
		if (this.mobject_arrow){
			set_X(this.arrow_under_layer, x);
			set_Y(this.arrow_under_layer, y);
			set_scaleX(this.mobject_arrow, xscale);
			set_scaleY(this.mobject_arrow, yscale);
		};
		if (this.uron_layer){
			set_X(this.uron_under_layer, x);
			set_Y(this.uron_under_layer, y);
//			set_scaleX(this.mobject_arrow, xscale);
//			set_scaleY(this.mobject_arrow, yscale);
		};
		if ((this.number)&&(this.number.outside)){
			set_number_outside(this);
		};
	};
	
function obj_init(){

   try{
		  if (hwm_je2d_is_battle_loader_cancelled(this)) return 0;
		  if (this.inited) return 0;
		  this.inited = true;
        if ((this.custom_image)&&(!inited_tweaker)&&(typeof initTweaker !== 'undefined')){
           inited_tweaker = true;
           initTweaker();
        };
		  this.init_obj_image();
		  this.set_statix(this.statix_d);
		  if (this.doing=='die'){
			  var skip_bomb_die_was = this.skip_bomb_die;
			  this.skip_bomb_die = 1;
			  while(this.doing!='')
			  {
				this.animate_continue(1, 0, 0, 1);
			  };
			  this.skip_bomb_die = skip_bomb_die_was;
			  this.bomb_die_hold = 0;
			  this.bomb_die_progress = 0;
		  }

		  this.set_data();

		  this.callback_function();
}catch(e){
	my_alert(this.filename+' '+e.stack);
};
	};

	function obj_inited(j){
	};

   
	var script_cnt = 0;
	var scripts = Array();


var maxTries = 30;
var hwm_loader_retry_delay = 1000;
var hwm_loader_primary_attempts = 5;
var hwm_loader_image_decode_timeout = 10000;
var hwm_loader_finished_event_grace = 10000;
var hwm_loader_local_ver_prefix = 'hwm_battle_asset_local_ver_v2:';
var hwm_loader_local_ver_invalid_prefix = 'hwm_battle_asset_local_ver_invalid_v2:';
var hwm_loader_local_ver_legacy_prefix = 'hwm_battle_asset_local_ver_v1:';
var hwm_loader_local_ver_ttl = 7*24*60*60*1000;
var hwm_loader_local_ver_max_entries = 100;
var hwm_loader_local_ver_memory = {};
var hwm_loader_local_ver_cleanup_done = false;
var hwm_loader_anim_requests = {};

function hwm_loader_remove_named_param(path, name) {
	var hash = '';
	var hash_pos = path.indexOf('#');
	if (hash_pos >= 0) {
		hash = path.substr(hash_pos);
		path = path.substr(0, hash_pos);
	}
	var pattern = new RegExp('([?&])' + name + '=[^&#]*(&?)', 'g');
	path = path.replace(pattern, function(match, prefix, suffix) {
		if ((prefix == '?') && suffix) return '?';
		return suffix ? prefix : '';
	});
	path = path.replace(/[?&]$/, '');
	return path + hash;
}

function hwm_loader_remove_retry_param(path) {
	return hwm_loader_remove_named_param(path, 'hwm_retry');
}

function hwm_loader_remove_local_ver_param(path) {
	return hwm_loader_remove_named_param(path, 'local_ver');
}

function hwm_loader_set_param(path, name, value) {
	var hash = '';
	path = hwm_loader_remove_named_param(path, name);
	var hash_pos = path.indexOf('#');
	if (hash_pos >= 0) {
		hash = path.substr(hash_pos);
		path = path.substr(0, hash_pos);
	}
	return path + (path.indexOf('?') >= 0 ? '&' : '?') + name + '=' + encodeURIComponent(value) + hash;
}

function hwm_loader_get_param(path, name) {
	var match = path.match(new RegExp('[?&]' + name + '=([^&#]*)'));
	if (!match) return '';
	try {
		return decodeURIComponent(match[1]);
	} catch (ignore) {
		return match[1];
	}
}

function hwm_loader_asset_path_pos(path) {
	var pos = path.indexOf('/i/');
	if (pos >= 0) return pos + 1;
	if (path.indexOf('i/') == 0) return 0;
	return -1;
}

function hwm_loader_is_reserve_path(path) {
	return path.indexOf(subpath_reserve) >= 0;
}

function hwm_loader_is_primary_asset_path(path) {
	return (hwm_loader_asset_path_pos(path) >= 0) && !hwm_loader_is_reserve_path(path);
}

function hwm_loader_local_ver_resource_key(path) {
	path = hwm_loader_remove_retry_param(path);
	path = hwm_loader_remove_local_ver_param(path);
	var hash_pos = path.indexOf('#');
	if (hash_pos >= 0) path = path.substr(0, hash_pos);
	var asset_pos = hwm_loader_asset_path_pos(path);
	if (asset_pos < 0) return '';
	return path.substr(asset_pos);
}

function hwm_loader_local_ver_storage() {
	try {
		if ((typeof window === 'undefined') || !window.localStorage) return null;
		return window.localStorage;
	} catch (ignore) {
		return null;
	}
}

function hwm_loader_local_ver_record_ok(record, now) {
	if ((!record) || (typeof record !== 'object')) return false;
	var n = parseInt(record.n, 10);
	var expires = parseInt(record.expires, 10);
	return (record.success === true) && (typeof record.nonce === 'string') && (record.nonce.length > 0) && !isNaN(n) && (n > 0) && (n < 1000000000) && !isNaN(expires) && (expires > now);
}

function hwm_loader_local_ver_invalid_key(resource_key, nonce) {
	return hwm_loader_local_ver_invalid_prefix + encodeURIComponent(resource_key) + ':' + encodeURIComponent(nonce);
}

function hwm_loader_local_ver_invalidation_ok(record, resource_key, nonce, now) {
	if ((!record) || (typeof record !== 'object')) return false;
	var expires = parseInt(record.expires, 10);
	return (record.resource_key === resource_key) && (record.nonce === nonce) && !isNaN(expires) && (expires > now);
}

function hwm_loader_local_ver_cleanup(force) {
	if (hwm_loader_local_ver_cleanup_done && !force) return;
	hwm_loader_local_ver_cleanup_done = true;
	var storage = hwm_loader_local_ver_storage();
	if (!storage) return;
	try {
		var now = Date.now();
		var entries = [];
		var remove_keys = [];
		for (var i=0; i<storage.length; i++) {
			var storage_key = storage.key(i);
			if ((storage_key)&&(storage_key.indexOf(hwm_loader_local_ver_legacy_prefix) == 0)) {
				remove_keys.push(storage_key);
				continue;
			}
			if ((storage_key)&&(storage_key.indexOf(hwm_loader_local_ver_invalid_prefix) == 0)) {
				var invalid_record = null;
				try { invalid_record = JSON.parse(storage.getItem(storage_key)); } catch (ignore) {}
				var invalid_resource_key = invalid_record ? invalid_record.resource_key : '';
				var invalid_nonce = invalid_record ? invalid_record.nonce : '';
				if (!hwm_loader_local_ver_invalidation_ok(invalid_record, invalid_resource_key, invalid_nonce, now)) {
					remove_keys.push(storage_key);
				} else {
					var success_record = null;
					try { success_record = JSON.parse(storage.getItem(hwm_loader_local_ver_prefix + encodeURIComponent(invalid_resource_key))); } catch (ignore) {}
					if ((!hwm_loader_local_ver_record_ok(success_record, now)) || (success_record.nonce != invalid_nonce)) remove_keys.push(storage_key);
				}
				continue;
			}
			if ((!storage_key) || (storage_key.indexOf(hwm_loader_local_ver_prefix) != 0)) continue;
			var record = null;
			try { record = JSON.parse(storage.getItem(storage_key)); } catch (ignore) {}
			if (!hwm_loader_local_ver_record_ok(record, now)) {
				remove_keys.push(storage_key);
			} else {
				entries.push({key: storage_key, time: parseInt(record.lastSuccess, 10) || 0});
			}
		}
		entries.sort(function(a, b) { return a.time-b.time; });
		while (entries.length > hwm_loader_local_ver_max_entries) remove_keys.push(entries.shift().key);
		for (var j=0; j<remove_keys.length; j++) storage.removeItem(remove_keys[j]);
	} catch (ignore) {
	}
}

function hwm_loader_get_saved_local_ver_record(path) {
	var resource_key = hwm_loader_local_ver_resource_key(path);
	if (!resource_key) return null;
	var now = Date.now();
	var memory_record = hwm_loader_local_ver_memory[resource_key];
	hwm_loader_local_ver_cleanup();
	var storage = hwm_loader_local_ver_storage();
	if (!storage) {
		if (hwm_loader_local_ver_record_ok(memory_record, now)) return memory_record;
		delete hwm_loader_local_ver_memory[resource_key];
		return null;
	}
	try {
		var storage_key = hwm_loader_local_ver_prefix + encodeURIComponent(resource_key);
		var stored_value = storage.getItem(storage_key);
		var record = stored_value ? JSON.parse(stored_value) : null;
		if (!hwm_loader_local_ver_record_ok(record, now)) {
			if (stored_value !== null) storage.removeItem(storage_key);
			delete hwm_loader_local_ver_memory[resource_key];
			return null;
		}
		var invalid_record = null;
		try { invalid_record = JSON.parse(storage.getItem(hwm_loader_local_ver_invalid_key(resource_key, record.nonce))); } catch (ignore) {}
		if (hwm_loader_local_ver_invalidation_ok(invalid_record, resource_key, record.nonce, now)) {
			delete hwm_loader_local_ver_memory[resource_key];
			return null;
		}
		hwm_loader_local_ver_memory[resource_key] = record;
		return record;
	} catch (ignore) {
		if (hwm_loader_local_ver_record_ok(memory_record, now)) return memory_record;
		delete hwm_loader_local_ver_memory[resource_key];
		return null;
	}
}

function hwm_loader_get_saved_local_ver(path) {
	var record = hwm_loader_get_saved_local_ver_record(path);
	return record ? parseInt(record.n, 10) : 0;
}

function hwm_loader_create_retry_context(path) {
	var resource_key = hwm_loader_local_ver_resource_key(path);
	var record = hwm_loader_get_saved_local_ver_record(path);
	return {resource_key: resource_key, saved_nonce: record ? record.nonce : '', saved_ver: record ? parseInt(record.n, 10) : 0, saved_expires: record ? parseInt(record.expires, 10) : 0};
}

function hwm_loader_next_local_ver(path) {
	var current_path_ver = parseInt(hwm_loader_get_param(path, 'local_ver'), 10);
	if (isNaN(current_path_ver)) current_path_ver = 0;
	return current_path_ver + 1;
}

function hwm_loader_invalidate_saved_local_ver(path, retry_context) {
	var resource_key = hwm_loader_local_ver_resource_key(path);
	if ((!resource_key) || (!retry_context) || (retry_context.resource_key != resource_key) || (!retry_context.saved_nonce)) return;
	var memory_record = hwm_loader_local_ver_memory[resource_key];
	if ((memory_record)&&(memory_record.nonce == retry_context.saved_nonce)) delete hwm_loader_local_ver_memory[resource_key];
	var storage = hwm_loader_local_ver_storage();
	if (!storage) return;
	try {
		var now = Date.now();
		var expires = parseInt(retry_context.saved_expires, 10);
		if (isNaN(expires) || (expires <= now)) expires = now+hwm_loader_local_ver_ttl;
		var invalid_key = hwm_loader_local_ver_invalid_key(resource_key, retry_context.saved_nonce);
		if (storage.getItem(invalid_key) === null) storage.setItem(invalid_key, JSON.stringify({resource_key: resource_key, nonce: retry_context.saved_nonce, lastFailure: now, expires: expires}));
	} catch (ignore) {
		try {
			var storage_key = hwm_loader_local_ver_prefix + encodeURIComponent(resource_key);
			var current_record = JSON.parse(storage.getItem(storage_key));
			if ((current_record)&&(current_record.nonce == retry_context.saved_nonce)) storage.removeItem(storage_key);
		} catch (ignore_remove) {
		}
	}
}

function hwm_loader_create_local_ver_nonce(now) {
	return now.toString(36) + '-' + Math.random().toString(36).substr(2, 10);
}

function hwm_loader_remember_successful_local_ver(path) {
	if (!hwm_loader_is_primary_asset_path(path)) return;
	var resource_key = hwm_loader_local_ver_resource_key(path);
	if (!resource_key) return;
	var path_ver = parseInt(hwm_loader_get_param(path, 'local_ver'), 10);
	if (isNaN(path_ver) || (path_ver <= 0)) return;
	var now = Date.now();
	var record = {n: path_ver, success: true, nonce: hwm_loader_create_local_ver_nonce(now), lastSuccess: now, expires: now+hwm_loader_local_ver_ttl};
	hwm_loader_local_ver_memory[resource_key] = record;
	var storage = hwm_loader_local_ver_storage();
	if (storage) {
		try {
			hwm_loader_local_ver_cleanup();
			var storage_key = hwm_loader_local_ver_prefix + encodeURIComponent(resource_key);
			var is_new_record = storage.getItem(storage_key) === null;
			storage.setItem(storage_key, JSON.stringify(record));
			if (is_new_record) hwm_loader_local_ver_cleanup(true);
		} catch (ignore) {
		}
	}
}

function hwm_loader_apply_saved_local_ver(path, retry_context) {
	if (!hwm_loader_is_primary_asset_path(path)) return path;
	var resource_key = hwm_loader_local_ver_resource_key(path);
	var saved_ver = ((retry_context)&&(retry_context.resource_key == resource_key)) ? parseInt(retry_context.saved_ver, 10) : hwm_loader_get_saved_local_ver(path);
	if (isNaN(saved_ver)) saved_ver = 0;
	var path_ver = parseInt(hwm_loader_get_param(path, 'local_ver'), 10);
	if (isNaN(path_ver)) path_ver = 0;
	var local_ver = Math.max(saved_ver, path_ver);
	if (local_ver <= 0) return path;
	return hwm_loader_set_param(path, 'local_ver', local_ver);
}

function hwm_loader_add_retry_param(path, numTries) {
	return hwm_loader_set_param(path, 'hwm_retry', numTries);
}

function hwm_loader_get_retry_path(path, numTries, retry_context) {
	var retry_path = hwm_loader_remove_retry_param(path);
	if (hwm_loader_is_primary_asset_path(retry_path)) {
		if (numTries < hwm_loader_primary_attempts) {
			var next_local_ver = hwm_loader_next_local_ver(retry_path);
			retry_path = hwm_loader_set_param(retry_path, 'local_ver', next_local_ver);
			return retry_path;
		} else {
			hwm_loader_invalidate_saved_local_ver(retry_path, retry_context);
			retry_path = hwm_loader_remove_local_ver_param(retry_path);
			var asset_pos = hwm_loader_asset_path_pos(retry_path);
			retry_path = subpath_reserve + retry_path.substr(asset_pos + 2);
		}
	}
	return hwm_loader_add_retry_param(retry_path, numTries);
}

function hwm_loader_anim_data_key(path) {
	path = hwm_loader_remove_retry_param(path);
	path = hwm_loader_remove_local_ver_param(path);
	var query_pos = path.indexOf('?');
	if (query_pos >= 0) path = path.substr(0, query_pos);
	var hash_pos = path.indexOf('#');
	if (hash_pos >= 0) path = path.substr(0, hash_pos);
	var match = path.replace(/\\/g, '/').match(/\/anim_data\d*\/(.+)\.js$/i);
	if (!match) return '';
	try {
		return decodeURIComponent(match[1]);
	} catch (ignore) {
		return match[1];
	}
}

function hwm_loader_anim_data_key_ok(key) {
	if (!key) return false;
	if ((typeof statix === 'undefined') || (typeof razmetka === 'undefined')) return false;
	var statix_data = statix[key];
	var razmetka_data = razmetka[key];
	if ((!statix_data) || (typeof statix_data !== 'object')) return false;
	if ((!razmetka_data) || (typeof razmetka_data !== 'object')) return false;
	var statix_len = parseInt(statix_data['c_length'], 10);
	var razmetka_len = parseInt(razmetka_data[0], 10);
	return !isNaN(statix_len) && (statix_len > 0) && !isNaN(razmetka_len) && (razmetka_len > 0);
}

function hwm_loader_alias_anim_data(source_key, target_key) {
	if ((!source_key) || (!target_key)) return false;
	if (!hwm_loader_anim_data_key_ok(source_key)) return false;
	if (source_key != target_key) {
		statix[target_key] = statix[source_key];
		razmetka[target_key] = razmetka[source_key];
		if ((typeof anim !== 'undefined')&&(typeof anim[source_key] !== 'undefined')) anim[target_key] = anim[source_key];
	}
	return hwm_loader_anim_data_key_ok(target_key);
}

function hwm_loader_reset_anim_data(key) {
	if (!key) return;
	if (typeof statix !== 'undefined') statix[key] = undefined;
	if (typeof razmetka !== 'undefined') razmetka[key] = undefined;
}

function hwm_loader_anim_data_snapshot(key) {
	return {
		key: key,
		statix_exists: (typeof statix !== 'undefined')&&(typeof statix[key] !== 'undefined'),
		statix_data: (typeof statix !== 'undefined') ? statix[key] : undefined,
		razmetka_exists: (typeof razmetka !== 'undefined')&&(typeof razmetka[key] !== 'undefined'),
		razmetka_data: (typeof razmetka !== 'undefined') ? razmetka[key] : undefined,
		anim_exists: (typeof anim !== 'undefined')&&(typeof anim[key] !== 'undefined'),
		anim_data: (typeof anim !== 'undefined') ? anim[key] : undefined
	};
}

function hwm_loader_restore_anim_data(snapshot) {
	if (!snapshot) return;
	if (typeof statix !== 'undefined') {
		if (snapshot.statix_exists) statix[snapshot.key] = snapshot.statix_data;
		else statix[snapshot.key] = undefined;
	}
	if (typeof razmetka !== 'undefined') {
		if (snapshot.razmetka_exists) razmetka[snapshot.key] = snapshot.razmetka_data;
		else razmetka[snapshot.key] = undefined;
	}
	if (typeof anim !== 'undefined') {
		if (snapshot.anim_exists) anim[snapshot.key] = snapshot.anim_data;
		else anim[snapshot.key] = undefined;
	}
}

function hwm_loader_anim_request_restore_source(request) {
	if ((!request) || (!request.source_snapshot) || request.source_restored) return;
	hwm_loader_restore_anim_data(request.source_snapshot);
	request.source_restored = true;
}

function hwm_loader_anim_request_key(path, expected_key) {
	if (!hwm_loader_anim_data_key(path)) return '';
	var resource_key = hwm_loader_local_ver_resource_key(path);
	if (!resource_key) return '';
	return resource_key + '|' + (expected_key || hwm_loader_anim_data_key(path));
}

function hwm_loader_anim_request_add_subscriber(request, obj_link, target_key) {
	if ((!request) || (!obj_link)) return;
	for (var i=0; i<request.subscribers.length; i++) {
		if ((request.subscribers[i].obj_link === obj_link)&&(request.subscribers[i].target_key == target_key)) return;
	}
	hwm_je2d_mark_battle_loader(obj_link);
	request.subscribers.push({obj_link: obj_link, target_key: target_key});
}

function hwm_loader_anim_request_clear(request) {
	if (!request) return;
	if (hwm_loader_anim_requests[request.key] === request) delete hwm_loader_anim_requests[request.key];
	request.finished = true;
	request.current_element = null;
	request.retry_timer = 0;
}

function hwm_loader_anim_request_cancel(request) {
	if (!request) return;
	if (request.retry_timer) clearTimeout(request.retry_timer);
	if (request.current_element) hwm_loader_cancel_element(request.current_element);
	hwm_loader_anim_request_restore_source(request);
	hwm_loader_anim_request_clear(request);
	request.subscribers = [];
}

function hwm_loader_anim_request_notify(request, obj_link, expected_key, target_key) {
	if (!request) {
		hwm_loader_alias_anim_data(expected_key, target_key || expected_key);
		if ((!hwm_je2d_is_battle_loader_cancelled(obj_link))&&(obj_link)&&(typeof obj_link.init_this_obj === 'function')) obj_link.init_this_obj();
		return;
	}
	hwm_loader_anim_request_clear(request);
	for (var i=0; i<request.subscribers.length; i++) {
		var subscriber = request.subscribers[i];
		if (hwm_je2d_is_battle_loader_cancelled(subscriber.obj_link)) continue;
		hwm_loader_alias_anim_data(request.expected_key, subscriber.target_key || request.expected_key);
		if (typeof subscriber.obj_link.init_this_obj === 'function') subscriber.obj_link.init_this_obj();
	}
	hwm_loader_anim_request_restore_source(request);
	request.subscribers = [];
}

function hwm_loader_validate_anim_data(path, expected_key) {
	var path_key = hwm_loader_anim_data_key(path);
	if (!path_key) return true;
	return hwm_loader_anim_data_key_ok(expected_key || path_key);
}

function hwm_loader_image_dimensions_ok(image) {
	if ((!image) || (!image.complete)) return false;
	var natural_width = (typeof image.naturalWidth === 'number') ? image.naturalWidth : image.width;
	var natural_height = (typeof image.naturalHeight === 'number') ? image.naturalHeight : image.height;
	return (natural_width > 0) && (natural_height > 0) && (image.width > 0) && (image.height > 0);
}

function hwm_loader_validate_image(image, callback) {
	if (!hwm_loader_image_dimensions_ok(image)) {
		callback(false);
		return;
	}
	if (typeof image.decode !== 'function') {
		callback(true);
		return;
	}
	var finished = false;
	function finish(ok) {
		if (finished) return;
		finished = true;
		if (image.hwm_decode_timer) clearTimeout(image.hwm_decode_timer);
		image.hwm_decode_timer = 0;
		callback(ok && hwm_loader_image_dimensions_ok(image));
	}
	image.hwm_decode_timer = setTimeout(function() { finish(false); }, hwm_loader_image_decode_timeout);
	try {
		var decode_result = image.decode();
		if ((!decode_result) || (typeof decode_result.then !== 'function')) {
			finish(true);
			return;
		}
		decode_result.then(function() { finish(true); }, function() { finish(false); });
	} catch (ignore) {
		finish(false);
	}
}

function hwm_loader_cancel_element(e) {
	if (!e) return;
	e.hwm_je2d_battle_load_cancelled = true;
	e.my_loading = false;
	if (e.hwm_decode_timer) clearTimeout(e.hwm_decode_timer);
	e.hwm_decode_timer = 0;
	try {
		if ((e !== null) && (e.parentNode !== null)) e.parentNode.removeChild(e);
	} catch (ignore) {
	}
}

function hwm_loader_get_url(e) {
	if (!e) return '';
	return e.src || e.href || e.link || '';
}

function hwm_loader_request_finished(e) {
	try {
		if ((typeof performance === 'undefined') || (typeof performance.getEntriesByName !== 'function')) return false;
		var url = hwm_loader_get_url(e);
		if (!url) return false;
		var entries = performance.getEntriesByName(url);
		return (entries && entries.length > 0);
	} catch (ignore) {
		return false;
	}
}

function hwm_loader_finished_event_timed_out(e, now) {
	if (!hwm_loader_request_finished(e)) {
		e.hwm_request_finished_at = 0;
		return false;
	}
	if (!e.hwm_request_finished_at) {
		e.hwm_request_finished_at = now;
		return false;
	}
	return (now-e.hwm_request_finished_at >= hwm_loader_finished_event_grace);
}

function loadScript_obj(path, numTries, obj_linkage, expected_key, target_key, anim_request, retry_context) {
	var e = null;
	try{
		var obj_link = (typeof obj_linkage === 'undefined') ? this : obj_linkage;
		if (anim_request) {
			anim_request.retry_timer = 0;
			if (anim_request.finished) return false;
			if (hwm_je2d_is_battle_loader_cancelled(anim_request)) {
				hwm_loader_anim_request_cancel(anim_request);
				return false;
			}
		}else if (hwm_je2d_is_battle_loader_cancelled(obj_link)) {
			return false;
		}

		numTries = numTries || 0;
		if (!retry_context) retry_context = hwm_loader_create_retry_context(path);
		if (!numTries) path = hwm_loader_apply_saved_local_ver(path, retry_context);
		var path_anim_key = hwm_loader_anim_data_key(path);
		expected_key = expected_key || path_anim_key;
		target_key = target_key || expected_key;
		var request_key = hwm_loader_anim_request_key(path, expected_key);
		if (request_key) {
			if (!anim_request) {
				var pending_request = hwm_loader_anim_requests[request_key];
				if (pending_request && (pending_request.finished || hwm_je2d_is_battle_loader_cancelled(pending_request))) {
					hwm_loader_anim_request_cancel(pending_request);
					pending_request = null;
				}
				if (pending_request) {
					hwm_loader_anim_request_add_subscriber(pending_request, obj_link, target_key);
					return false;
				}
				anim_request = {key: request_key, expected_key: expected_key, subscribers: [], finished: false, current_element: null, retry_timer: 0, source_snapshot: null, source_restored: false};
				if (target_key != expected_key) anim_request.source_snapshot = hwm_loader_anim_data_snapshot(expected_key);
				hwm_je2d_mark_battle_loader(anim_request);
				hwm_loader_anim_requests[request_key] = anim_request;
				hwm_loader_anim_request_add_subscriber(anim_request, obj_link, target_key);
			}
		}

		var doc = document;
		var pathStripped = path.replace(/^(css|img)!/, '');
		var isCss = false;
		if (/(^css!|\.css$)/.test(path)) {
			isCss = true;
			e = doc.createElement('link');
			e.rel = 'stylesheet';
			e.href = pathStripped;
		}else if (/(^img!|\.(png|gif|jpg|svg)$)/.test(path)) {
			e = doc.createElement('img');
			e.src = pathStripped;
		}else{
			if (path_anim_key) {
				if (anim_request && anim_request.source_snapshot) anim_request.source_restored = false;
				hwm_loader_reset_anim_data(expected_key);
			}
			e = doc.createElement('script');
			e.src = path;
			e.async = true;
		}
		e.obj_link = obj_link;
		e.link = path;
		e.loaded = false;
		e.numTries = numTries;
		e.expected_key = expected_key;
		e.target_key = target_key;
		e.anim_request = anim_request;
		e.hwm_load_settled = false;
		hwm_je2d_mark_battle_loader(e);
		hwm_je2d_mark_battle_loader(e.obj_link);
		if (anim_request) anim_request.current_element = e;

		loading_stack[loading_stack.length] = e;
		e.my_loading = true;
		e.loading_checks = 0;
		e.check_load_now = 0;

		e.onload = e.onerror = function (ev) {
			try{
				if (this.hwm_load_settled) return false;
				var request_cancelled = this.anim_request && hwm_je2d_is_battle_loader_cancelled(this.anim_request);
				if (hwm_je2d_is_battle_loader_cancelled(this) || request_cancelled || ((!this.anim_request)&&hwm_je2d_is_battle_loader_cancelled(this.obj_link))) {
					this.hwm_load_settled = true;
					hwm_loader_cancel_element(this);
					if (request_cancelled) hwm_loader_anim_request_cancel(this.anim_request);
					return false;
				}
				var result = (ev && ev.type) ? ev.type[0] : 'e';
				this.my_loading = false;

				if (isCss && 'hideFocus' in this) {
					try {
						if (!this.sheet.cssText.length) result = 'e';
					} catch (x) {
						result = 'e';
					}
				}
				if ((result != 'e') && !hwm_loader_validate_anim_data(path, this.expected_key)) result = 'e';

				if (result == 'e') {
					this.hwm_load_settled = true;
					hwm_loader_anim_request_restore_source(this.anim_request);
					numTries += 1;
					if (numTries < maxTries) {
						var retry_path = hwm_loader_get_retry_path(path, numTries, retry_context);
						var retry_timer = setTimeout(this.obj_link.loadScript_obj, hwm_loader_retry_delay, retry_path, numTries, this.obj_link, this.expected_key, this.target_key, this.anim_request, retry_context);
						if (this.anim_request) this.anim_request.retry_timer = retry_timer;
						hwm_loader_cancel_element(this);
						return false;
					}
					if (this.anim_request) hwm_loader_anim_request_cancel(this.anim_request);
					else hwm_loader_cancel_element(this);
					loading_Error(this.link, path);
					return false;
				}

				this.hwm_load_settled = true;
				hwm_loader_remember_successful_local_ver(path);
				this.loaded = true;
				hwm_loader_anim_request_notify(this.anim_request, this.obj_link, this.expected_key, this.target_key);
			}catch(err){
				if (this.anim_request) hwm_loader_anim_request_cancel(this.anim_request);
				else hwm_loader_cancel_element(this);
				my_alert(err.stack);
			}
		};

		doc.head.appendChild(e);
		if ((typeof e.obj_link.init_this_obj === 'function')&&(e.loaded)) e.obj_link.init_this_obj();
	}catch(err){
		if (anim_request) hwm_loader_anim_request_cancel(anim_request);
		else if (e) hwm_loader_cancel_element(e);
		my_alert(err.stack);
		return false;
	}
}

function hwm_loader_cancel_image_element(e, image_key) {
	if (!e) return;
	e.hwm_load_settled = true;
	hwm_loader_cancel_element(e);
	try {
		if ((typeof image_obj !== 'undefined')&&(image_obj[image_key] === e)) delete image_obj[image_key];
	} catch (ignore) {
	}
}

function hwm_loader_force_error(e, ev) {
	if (!e) return false;
	if (typeof e.hwm_loader_onerror === 'function') return e.hwm_loader_onerror.call(e, ev);
	if (typeof e.onerror === 'function') return e.onerror.call(e, ev);
	return false;
}

var test_timeout = 1000;
function loadImage(paren, i, link, path, numTries, g_name, fallback_link, fallback_path, fallback_used, retry_context, retry_objs) {
	try{
		if (hwm_je2d_is_battle_loader_cancelled(paren)) {
			if ((typeof image_obj !== 'undefined')&&(image_obj[i])&&(hwm_je2d_is_battle_loader_cancelled(image_obj[i]))) hwm_loader_cancel_image_element(image_obj[i], i);
			return false;
		}
	  var doc = document,
		  isCss,
		  e;
		numTries = numTries || 0;
		fallback_used = fallback_used || false;
		if (!retry_context) retry_context = hwm_loader_create_retry_context(path);
		if (!numTries) path = hwm_loader_apply_saved_local_ver(path, retry_context);

		e = new Image();
		e.link = link;  
		e.crossOrigin = 'Anonymous';
		
		e.i = i;
	//	e.loaded = false;
		e.paren = paren;
		e.numTries = numTries;
		e.gname = g_name;
		e.loaded = false;
		e.hwm_load_settled = false;
		e.hwm_request_finished_at = 0;
		hwm_je2d_mark_battle_loader(e);
		hwm_je2d_mark_battle_loader(paren);
		
		var temp_array = 0;
		var had_temp_array = false;

		if ((retry_objs)&&(retry_objs.length)){
			temp_array = retry_objs.slice(0);
			had_temp_array = true;
		}else if ((image_obj[i])&&(image_obj[i].objs)){
			var temp_array = Array();
			temp_array = image_obj[i].objs;
			had_temp_array = true;
		};
		image_obj[i] = e;
			if (g_name) {
				paren[g_name] = image_obj[i];
				paren.gname = g_name;
			}else{
				paren.gname = 0;
			};


		image_obj[i]['link'] = link;
	//	image_obj[i].crossOrigin = 'Anonymous';
		if (typeof image_obj[i].objs === 'undefined')
		{
			image_obj[i].objs = Array();
		}
		if (temp_array) image_obj[i].objs = temp_array;
		
		

		if ((!had_temp_array)&&(paren)) image_obj[i].objs.push(paren);

		loading_stack[loading_stack.length] = e;
		e.my_loading = true;
		e.loading_checks = 0;
		e.check_load_now = 0;
	}catch(err){
		my_alert(err.stack);
	};

	function finish_image_attempt(ok) {
		try{
			if (e.hwm_load_settled) return false;
			if (hwm_je2d_is_battle_loader_cancelled(e) || hwm_je2d_is_battle_loader_cancelled(e.paren)) {
				hwm_loader_cancel_image_element(e, i);
				return false;
			}
			e.hwm_load_settled = true;
			e.my_loading = false;
			if (!ok) {
			  var next_objs = (e.objs && e.objs.length) ? e.objs.slice(0) : Array(e.paren);
			  if ((!fallback_used)&&(fallback_path)&&(path != fallback_path)) {
				loadImage(e.paren, i, fallback_link, fallback_path, 0, e.gname, 0, 0, true, 0, next_objs);
				hwm_loader_cancel_element(e);
				return false;
			  }
			  numTries += 1;
			  if (numTries < maxTries) {
				var retry_path = hwm_loader_get_retry_path(path, numTries, retry_context);
				setTimeout(loadImage, hwm_loader_retry_delay, e.paren, i, link, retry_path, numTries, e.gname, fallback_link, fallback_path, fallback_used, retry_context, next_objs);
				hwm_loader_cancel_element(e);
				return false;
			  }else{
				 hwm_loader_cancel_element(e);
				 loading_Error(e.link, path);
				 return false;
			  };
			}

			hwm_loader_remember_successful_local_ver(path);
			e.loaded = true;
			if (e.paren.gname){
	//			e.paren[e.paren.gname].loaded = true;
			};
			for (var key in e.objs) {
				e.objs[key].init_this_obj();
			}
		}catch(err){
			my_alert(err.stack);
		};
	}

	e.hwm_loader_onerror = function () {
		finish_image_attempt(false);
	};
	e.hwm_loader_onload = function () {
		if (hwm_je2d_is_battle_loader_cancelled(this) || hwm_je2d_is_battle_loader_cancelled(this.paren)) {
			finish_image_attempt(false);
			return false;
		}
		this.my_loading = false;
		hwm_loader_validate_image(this, finish_image_attempt);
	};
	if (e.addEventListener){
		e.addEventListener('error', e.hwm_loader_onerror, false);
		e.addEventListener('load', e.hwm_loader_onload, false);
	}else{
		e.onerror = e.hwm_loader_onerror;
		e.onload = e.hwm_loader_onload;
	};

	 e.src = path;
	 for (var key in e.objs) {
		if (typeof e.objs[key].init_this_obj === "function") {
			e.objs[key].init_this_obj();
		};
	 }

	 doc.head.appendChild(e);
}

var was_error_alert = false;
function loading_Error(link, path){
	if (!was_error_alert){
		was_error_alert = true;
		alert('Loading error. Please, refresh the page '+link+' '+path);
        window.location.reload();
	};
};


function check_load(){
	var i = 0;
	var ok = true;
	check_load_cnt++;
	while (ok){
		ok = false;
		var len = loading_stack.length;
		for (i=0;i<len;i++)
		{
			if (loading_stack[i].my_loading == false)
			{
				loading_stack.splice(i, 1);
				ok = true;
				break;
			}else{
				if (hwm_je2d_is_battle_loader_cancelled(loading_stack[i])) {
					if ((typeof loading_stack[i].hwm_loader_onerror === 'function')||(typeof loading_stack[i].onerror === 'function')) hwm_loader_force_error(loading_stack[i], {type: 'error'});
					else hwm_loader_cancel_element(loading_stack[i]);
					if (loading_stack[i].my_loading == false) {
						loading_stack.splice(i, 1);
						ok = true;
						break;
					}
				}
					if (loading_stack[i].check_load_now != check_load_cnt){
					loading_stack[i].check_load_now = check_load_cnt;
					loading_stack[i].loading_checks++;
					var load_now = Date.now();
					if (((loading_stack[i].loading_checks>1) && hwm_loader_finished_event_timed_out(loading_stack[i], load_now)) || (loading_stack[i].loading_checks>75)){
						if (!error_sender.loading){
							error_sender.open('POST', 'save_html_load_error.php', true);
							error_sender.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
							error_sender.onreadystatechange = function() {};
							error_sender.send('error_url='+encodeURIComponent(hwm_loader_get_url(loading_stack[i])));
							error_sender.loading = true;
						};
						var ev = Array();
						ev.type = Array();
						ev.type[0] = 'e';
						hwm_loader_force_error(loading_stack[i], ev);
					};
				};

			};
		}
	};
};



function loadImage_url(i, path, numTries, battle_load_token, retry_context) {
  var doc = document,
      isCss,
      e;
	numTries = numTries || 0;
	if (typeof battle_load_token === 'undefined') battle_load_token = hwm_je2d_get_battle_load_token();
	var current_battle_load_token = hwm_je2d_get_battle_load_token();
	if ((battle_load_token !== null)&&(current_battle_load_token !== null)&&(battle_load_token !== current_battle_load_token)) {
		if ((typeof image_obj !== 'undefined')&&(image_obj[i])&&(hwm_je2d_is_battle_loader_cancelled(image_obj[i]))) hwm_loader_cancel_image_element(image_obj[i], i);
		return false;
	}
	if (!retry_context) retry_context = hwm_loader_create_retry_context(path);
	if (!numTries) path = hwm_loader_apply_saved_local_ver(path, retry_context);

    e = new Image();
	e.crossOrigin = 'Anonymous';
	e.i = i;
	e.numTries = numTries;
	e.link = path;
	e.loaded = false;
	e.hwm_load_settled = false;
	hwm_je2d_mark_battle_loader(e);
	
	var temp_array = 0;

	image_obj[i] = e;

	if (typeof image_obj[i].objs === 'undefined')
	{
		image_obj[i].objs = Array();
	}
	loading_stack[loading_stack.length] = e;
	e.my_loading = true;
	e.loading_checks = 0;
	e.check_load_now = 0;

	function finish_image_url_attempt(ok) {
		if (e.hwm_load_settled) return false;
		if (hwm_je2d_is_battle_loader_cancelled(e)) {
			hwm_loader_cancel_image_element(e, i);
			return false;
		}
		e.hwm_load_settled = true;
		e.my_loading = false;
		if (!ok) {
			numTries += 1;
			if (numTries < maxTries) {
				var retry_path = hwm_loader_get_retry_path(path, numTries, retry_context);
				setTimeout(loadImage_url, hwm_loader_retry_delay, i, retry_path, numTries, battle_load_token, retry_context);
				hwm_loader_cancel_element(e);
				return false;
			}
			hwm_loader_cancel_element(e);
			loading_Error(e.link, path);
			return false;
		}
		hwm_loader_remember_successful_local_ver(path);
		e.loaded = true;
		check_init();
	}

	e.hwm_loader_onerror = function () {
		finish_image_url_attempt(false);
	};
	e.hwm_loader_onload = function () {
		if (hwm_je2d_is_battle_loader_cancelled(this)) {
			finish_image_url_attempt(false);
			return false;
		}
		this.my_loading = false;
		hwm_loader_validate_image(this, finish_image_url_attempt);
	};
	if (e.addEventListener){
		e.addEventListener('error', e.hwm_loader_onerror, false);
		e.addEventListener('load', e.hwm_loader_onload, false);
	}else{
		e.onerror = e.hwm_loader_onerror;
		e.onload = e.hwm_loader_onload;
	};

	 e.src = path;

	 check_init();


	 doc.head.appendChild(e);
}



  MatrixTransform = function(m) {
    this.m = (m && m.slice()) || [1, 0, 0, 1, 0, 0];
  };

  MatrixTransform.prototype = {
    copy: function() {
      return new MatrixTransform(this.m);
    },
    point: function(point) {
      var m = this.m;
      return {
        x: m[0] * point.x + m[2] * point.y + m[4],
        y: m[1] * point.x + m[3] * point.y + m[5]
      };
    },
    translate: function(x, y) {
      this.m[4] += this.m[0] * x + this.m[2] * y;
      this.m[5] += this.m[1] * x + this.m[3] * y;
      return this;
    },
    scale: function(sx, sy) {
      this.m[0] *= sx;
      this.m[1] *= sx;
      this.m[2] *= sy;
      this.m[3] *= sy;
      this.m[4] *= sx;
      this.m[5] *= sy;
      return this;
    },
    rotate: function(rad) {
      var c = Math.cos(rad);
      var s = Math.sin(rad);
      var m11 = this.m[0] * c + this.m[2] * s;
      var m12 = this.m[1] * c + this.m[3] * s;
      var m21 = this.m[0] * -s + this.m[2] * c;
      var m22 = this.m[1] * -s + this.m[3] * c;
      this.m[0] = m11;
      this.m[1] = m12;
      this.m[2] = m21;
      this.m[3] = m22;
      return this;
    },
    getTranslation: function() {
      return {
        x: this.m[4],
        y: this.m[5]
      };
    },
    skew: function(sx, sy) {
      var m11 = this.m[0] + this.m[2] * sy;
      var m12 = this.m[1] + this.m[3] * sy;
      var m21 = this.m[2] + this.m[0] * sx;
      var m22 = this.m[3] + this.m[1] * sx;
      this.m[0] = m11;
      this.m[1] = m12;
      this.m[2] = m21;
      this.m[3] = m22;
      return this;
    },
    multiply: function(matrix) {
      var m11 = this.m[0] * matrix.m[0] + this.m[2] * matrix.m[1];
      var m12 = this.m[1] * matrix.m[0] + this.m[3] * matrix.m[1];

      var m21 = this.m[0] * matrix.m[2] + this.m[2] * matrix.m[3];
      var m22 = this.m[1] * matrix.m[2] + this.m[3] * matrix.m[3];

      var dx = this.m[0] * matrix.m[4] + this.m[2] * matrix.m[5] + this.m[4];
      var dy = this.m[1] * matrix.m[4] + this.m[3] * matrix.m[5] + this.m[5];

      this.m[0] = m11;
      this.m[1] = m12;
      this.m[2] = m21;
      this.m[3] = m22;
      this.m[4] = dx;
      this.m[5] = dy;
      return this;
    },
    invert: function() {
      var d = 1 / (this.m[0] * this.m[3] - this.m[1] * this.m[2]);
      var m0 = this.m[3] * d;
      var m1 = -this.m[1] * d;
      var m2 = -this.m[2] * d;
      var m3 = this.m[0] * d;
      var m4 = d * (this.m[2] * this.m[5] - this.m[3] * this.m[4]);
      var m5 = d * (this.m[1] * this.m[4] - this.m[0] * this.m[5]);
      this.m[0] = m0;
      this.m[1] = m1;
      this.m[2] = m2;
      this.m[3] = m3;
      this.m[4] = m4;
      this.m[5] = m5;
      return this;
    },
    getMatrix: function() {
      return this.m;
    },
    setAbsolutePosition: function(x, y) {
      var m0 = this.m[0],
        m1 = this.m[1],
        m2 = this.m[2],
        m3 = this.m[3],
        m4 = this.m[4],
        m5 = this.m[5],
        yt = (m0 * (y - m5) - m1 * (x - m4)) / (m0 * m3 - m1 * m2),
        xt = (x - m4 - m2 * yt) / m0;

      return this.translate(xt, yt);
    }
  };

  function Make_Sprite(tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
		};
		if (tip == 0) /*konva*/
		{
			var tmp = new Konva.Group({hitGraphEnabled : false, listening: false});
			tmp.konva_obj = true;
			tmp.pixi_obj = false;
			return tmp;
		};
		if (tip == 1){ /*pixi*/
			var tmp = new PIXI.Sprite();
			tmp.konva_obj = false;
			tmp.pixi_obj = true;
			return tmp;
		};
  };

  function Make_Layer(tip, options){
		if (typeof tip === 'undefined'){
			tip = currentTip;
		};
		if (tip == 0) /*konva*/
		{
			var config = {hitGraphEnabled : false, listening: false};
			if (options){
				for (var key in options){
					if (options.hasOwnProperty(key)){
						config[key] = options[key];
					};
				};
				if ((typeof options.alpha !== 'undefined')&&(!config.contextAttrs)){
					config.contextAttrs = {alpha: options.alpha};
				};
			};
			var tmp = new Konva.Layer(config);
			tmp.konva_obj = true;
			tmp.pixi_obj = false;
			return tmp;
		};
		if (tip == 1){ /*pixi*/
			var tmp = new PIXI.Sprite();
			tmp.konva_obj = false;
			tmp.pixi_obj = true;
			return tmp;
		};

  };

  function Make_Image(tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
		};
		if (tip == 0) /*konva*/
		{
			var tmp = new Konva.Image({hitGraphEnabled : false, listening: false});
			tmp.konva_obj = true;
			tmp.pixi_obj = false;
			return tmp;
		};
		if (tip == 1){ /*pixi*/
			var tmp = new PIXI.Sprite();
			tmp.konva_obj = false;
			tmp.pixi_obj = true;
			return tmp;
		};

  };


  function Make_Drawing(tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
		};
		if (tip == 0) /*konva*/
		{
			var tmp = new Konva.Line({hitGraphEnabled : false});
			tmp.konva_obj = true;
			tmp.pixi_obj = false;
			return tmp;
		};
		if (tip == 1){ /*pixi*/
			var tmp = new PIXI.Graphics();
			tmp.konva_obj = false;
			tmp.pixi_obj = true;
			return tmp;
		};
  };


function set_parent(where, parent){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) /*konva*/
		{
			where.moveTo(parent);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.setParent(parent);
			return 0;
		};

};

	var unit_children = Array();
  function Make_addChild(where, child, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) /*konva*/
		{
			where.add(child);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			if (where.it_is_unit_layer){
				unit_children.push(child);
			};
			where.addChild(child);
			return 0;
		};
  };

  function Make_addChildAt(where, child, at, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) /*konva*/
		{
			where.add(child);
			child.setZIndex(at);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			if (where.it_is_unit_layer){
				unit_children.push(child);
			};
			where.addChildAt(child, at);
			return 0;
		};
  };

  function Make_setParent(where, parent, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/
		{
			where.remove();
			parent.add(where);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.setParent(parent);
			return 0;
		};
  };



function My_Image(option, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;

		};
		if (tip==0){
			img_temp = new Konva.Image(option);
			img_temp.konva_obj = true;
			img_temp.pixi_obj = false;
			return img_temp;
		};
		if (tip==1){
			var tsprite = new PIXI.Sprite.from(option.image, {width: option.image.width, height: option.image.height});
			var texture = new PIXI.Texture(tsprite.texture);

			if (option.crop)
		    {
				var crop = new PIXI.Rectangle(option.crop.x, option.crop.y, option.crop.width, option.crop.height);
				texture.frame = crop;
		    }

			var img_temp2 = new PIXI.Sprite(texture);
			if (typeof option.x !== 'undefined') img_temp2.x = option.x;
			if (typeof option.y !== 'undefined') img_temp2.y = option.y;
			if (typeof option.width !== 'undefined') {
				img_temp2.width = option.width;
				img_temp2.width2 = option.width;
			};
			if (typeof option.height !== 'undefined'){
				img_temp2.height = option.height;
				img_temp2.height2 = option.height;
			};
			if (typeof option.visible !== 'undefined') img_temp2.visible = option.visible;
			if (typeof option.offsetX !== 'undefined'){
				img_temp2.anchor.set(option.offsetX/option.width, option.offsetY/option.height);
			};
			img_temp2.konva_obj = false;
			img_temp2.pixi_obj = true;

			return img_temp2;
		};
};


function set_Alpha(where, alpha, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) /*konva*/{
         if (where.innerShadow){
            if (where.getAttr('opacity')!=alpha){
               where.line.setAttr('opacity', alpha);
               where.clearCache();
               where.cache({pixelRatio: 0.5});
            };

         }else
   			where.setAttr('opacity', alpha);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			if ((typeof need_redraw_ground !== 'undefined')&&(where.ground_obj)&&(where.alpha!=alpha)){
				need_redraw_ground = true;
			};
			where.alpha = alpha;
			return 0;
		};
};

function get_scaleX(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			return where.scaleX();
		};
		if (tip == 1){ /*pixi*/
			return where.scale.x;
		};

};

function get_text(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			return where.getText();
		};
		if (tip == 1){ /*pixi*/
			return where.text;
		};

};


function get_scaleY(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			return where.scaleY();
		};
		if (tip == 1){ /*pixi*/
			return where.scale.y;
		};

};

function set_scaleX(where, scale, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			where.scaleX(scale);
		};
		if (tip == 1){ /*pixi*/
			where.scale.x = scale;
		};

};

function set_skewX(where, scale, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			where.skewX(scale);
		};
		if (tip == 1){ /*pixi*/
			where.skew.x = scale;
		};

};


function set_scaleY(where, scale, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			where.scaleY(scale);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.scale.y = scale;
			return 0;
		};

};

function get_X(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			return where.x();
		};
		if (tip == 1){ /*pixi*/
			return where.x;
		};

};

function get_Y(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			return where.y();
		};
		if (tip == 1){ /*pixi*/
			return where.y;
		};

};

function set_X(where, scale, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			where.setX(scale);
		};
		if (tip == 1){ /*pixi*/
			where.x = scale;
		};

};


function set_Y(where, scale, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			where.setY(scale);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.y = scale;
			return 0;
		};

};

function Remove_App(cont, tip){
	if (typeof tip === 'undefined'){
			tip = currentTip;
	};
	if (tip == 0){
		if (typeof stage[cont].destroyChildren === 'function') stage[cont].destroyChildren();
		if (typeof stage[cont].destroy === 'function') stage[cont].destroy();
		stage[cont] = null;
	};
	if (tip == 1)
	{
		pixis[cont].destroy(true);
		pixis[cont] = null;
		stage[cont] = null;
	}
};


function Make_App(cont, stage_width, stage_height, MainPixelRatio, tip){
	if (typeof tip === 'undefined'){
			tip = currentTip;
	};
	var make_opaque_canvas = false;
	if ((typeof one_canvas_active !== 'undefined')&&(one_canvas_active)){
		make_opaque_canvas = true;
	};
	if ((typeof cont2 !== 'undefined')&&(cont2)&&(cont == cont2)){
		make_opaque_canvas = true;
	};
	if (typeof stage === 'undefined') stage = {};
	if (tip == 0) /*konva*/{
//		MainPixelRatio = 1;
		Konva.pixelRatio = MainPixelRatio;
		
  	    stage[cont] = new Konva.Stage({
			  container: cont,
			  no_filter: true,
			  width: stage_width,
			  listening: false,
			  hitGraphEnabled: false,
			  height: stage_height,
			  contextAttrs: {alpha: (!make_opaque_canvas)},
			  name: "war_stage"+cont
		});
		stage[cont].konva_obj = 1;
		stage[cont].pixi_obj = 0;
	};
	if (tip == 1){ /*pixi*/
		if (typeof pixis === 'undefined') pixis = {};
//		MainPixelRatio = 1;
      try{


      if (android){
         pixis[cont] = new PIXI.Application({
              autoStart: false,
              container: cont,
              width: stage_width,
              height: stage_height,
              resolution: MainPixelRatio,
              antialias: false, 
              forceFXAA: false,
              forceCanvas: false,
              autoDensity: true,
              preserveDrawingBuffer: false,
              clearBeforeRender: false,
              transparent: (!make_opaque_canvas),
              backgroundAlpha: make_opaque_canvas ? 1 : 0,
              backgroundColor: 0x000000,
         });
      }else{
         pixis[cont] = new PIXI.Application({
              autoStart: false,
              container: cont,
              width: stage_width,
              height: stage_height,
              resolution: MainPixelRatio,
              antialias: false, 
              forceFXAA: false,
              forceCanvas: false,
              autoDensity: true,
              preserveDrawingBuffer: false,
              clearBeforeRender: false,
              powerPreference: "high-performance",
              transparent: (!make_opaque_canvas),
              backgroundAlpha: make_opaque_canvas ? 1 : 0,
              backgroundColor: 0x000000,
         });
      };
		if (no_webgl)
		{
			return 0;
		}
      

		stage[cont] = pixis[cont].stage;
		stage[cont].app = pixis[cont];
		document.getElementById(cont).appendChild(pixis[cont].view);
		pixis[cont].view.style.position = 'absolute';
		pixis[cont].view.style.left = '0px';
		pixis[cont].view.style.top = '0px';

      pixis[cont].view.addEventListener("webglcontextlost", hmw_webglContextLost, false);
      pixis[cont].view.addEventListener("webglcontextrestored", hmw_webglContextRestored, false);
      }catch(e){
         	no_webgl = true;
            webgl_fail_code = 5;
         	console.log('WebGL fail code #5', e.stack);
            return 0;
      };

		stage[cont].pixi_obj = 1;
		stage[cont].konva_obj = 0;
      


	};



};

function hmw_webglContextLost(){
   console.log('webgl lost hwm func');
   webgl_redraw = false;
//   if ((typeof war_scr !== 'undefined')&&(war_scr)&&(war_scr!='')){
//      if ((typeof stage[war_scr] !== 'undefined')&&(typeof stage[war_scr].resized_war_scr === 'function')) {
//      stage[war_scr].resized_war_scr(1);
//   };
};

function hmw_webglContextRestored(){
   console.log('webgl restored hwm func');
   webgl_redraw = true;
};

function Make_lineStyle(where, option, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip==0){
			if (typeof option.closed !== 'undefined') where.closed = option.closed;
			if ((typeof option.fill !== 'undefined')&&(typeof option.fill === 'number')) option.fill = '#'+to6hex(option.fill);
			if ((typeof option.stroke !== 'undefined')&&(typeof option.stroke === 'number')) option.stroke = '#'+to6hex(option.stroke);
			where.setAttrs(option);
			return 0;
		};
		if (tip==1){
			var color = 0;
			var stroke_width = 1;
			var alpha = 1;
			var style = 1;

			if (typeof option.closed !== 'undefined') where.closed = option.closed;
			if (typeof option.strokeWidth !== 'undefined') stroke_width = option.strokeWidth;
			if (typeof option.stroke !== 'undefined') color = option.stroke;
			if (typeof option.opacity !== 'undefined') alpha = option.opacity;
			if (typeof option.fill !== 'undefined') where.fillc = option.fill;
			if (option.style) style = option.style;

			if ((typeof option.strokeEnabled !== 'undefined')&&(!option.strokeEnabled)) stroke_width = 0;
			where.lineStyle(stroke_width, color, alpha);

			return 0;
		};

};

function Make_setZIndex(where, ind, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) {
			where.setZIndex(ind);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.zIndex = ind;
			return 0;
		};
};

function set_ZIndex(where, ind, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) {
			where.setZIndex(ind);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.zIndex = ind;
			return 0;
		};
};


function Make_draw(where, what, tip){

		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) {
			what.draw();
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.app.renderer.render(what);
			return 0;
		};

};


function Make_batch_draw(where, what, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) {
			what.batchDraw();
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.app.renderer.render(what);
			return 0;
		};

};

function Make_resizeApp(where, set_width, set_height, tip){
		set_width = Math.round(set_width);
		set_height = Math.round(set_height);
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) {
			if ((where.width()!=set_width)||(where.height()!=set_height)){
				where.setAttrs({width: set_width, height: set_height});
			};
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.app.renderer.resize(set_width, set_height)
			return 0;
		};

};





	function show_obj(shadow_ref, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;

		};
		if (tip == 0) {
			this.show_obj_konva(shadow_ref);
			if ((this.custom_rock)&&(typeof custom_rock_hide_base === 'function')) custom_rock_hide_base(this);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			this.show_obj_pixi(shadow_ref);
			if ((this.custom_rock)&&(typeof custom_rock_hide_base === 'function')) custom_rock_hide_base(this);
			return 0;
		};

	};


function get_visible(where, tip){
      if (!where) return false;
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			return where.visible();
		};
		if (tip == 1){ /*pixi*/
			return where.visible;
		};

};

function set_visible(where, isvis, tip){
		if (typeof where !== 'undefined'){
			if (typeof tip === 'undefined'){
				tip = currentTip;
				if (where.konva_obj)
				{
					tip = 0;
				}
				if (where.pixi_obj){
					tip = 1;
				};

			};
			if (tip == 0) /*konva*/{
				if ((!need_redraw_ground)&&(where.ground_obj)&&(where.visible()!=isvis)){
/*               if (where.innerShadow){
                  if (isvis) where.cache({pixelRatio: 0.5});
               };*/
					need_redraw_ground = true;
				};
				where.visible(isvis);
			};
			if (tip == 1){ /*pixi*/
				if ((typeof need_redraw_ground !== 'undefined')&&(where.ground_obj)&&(where.visible!=isvis)){
					need_redraw_ground = true;
				};
				where.visible = isvis;
			};
		};
};

function get_width(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			if (!where.getAttr){
				return where.width;
			}else
				return where.getAttr('width');
		};
		if (tip == 1){ /*pixi*/
			return where.width;
		};

};

function get_height(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) /*konva*/{
			if (!where.getAttr){
				return where.height;
			}else
				return where.getAttr('height');
		};
		if (tip == 1){ /*pixi*/
			return where.height;
		};

};


function set_Width(where, val, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) /*konva*/{
			where.setAttr('width', val);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.width = val;
			return 0;
		};

};

function set_Height(where, val, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) /*konva*/{
			where.setAttr('height', val);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.height = val;
			return 0;
		};

};



function My_image_setAttrs(im, options, tip){
	if (typeof tip === 'undefined'){
		tip = currentTip;
			if (im.konva_obj)
			{
				tip = 0;
			}
			if (im.pixi_obj){
				tip = 1;
			};
		
	};
	if (tip == 0) /*konva*/{
		im.setAttrs(options);
	};
	if (tip == 1){
		if (typeof options.crop !== 'undefined')
		{
			im.crop = new PIXI.Rectangle(options.crop.x, options.crop.y, options.crop.width, options.crop.height);
			im.texture.frame = im.crop;
		}
		if (typeof options.width !== 'undefined')
		{
			im.width = options.width;
		}
		if (typeof options.height !== 'undefined')
		{
			im.height = options.height;
		}
	};

};

function Make_Text(text, option, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (text.konva_obj)
			{
				tip = 0;
			}
			if (text.pixi_obj){
				tip = 1;
			};

		};
		if (tip==0){
			if ((option.stroke>=0)&&(typeof option.stroke === 'number')) option.stroke = '#'+to6hex(option.stroke);
			if ((option.fill)&&(typeof option.fill === 'number')) option.fill = '#'+to6hex(option.fill);
			if (option.dropShadowColor){
				option.shadowColor = option.dropShadowColor;
				if (typeof option.shadowColor === 'number') option.shadowColor = '#'+to6hex(option.shadowColor);
			};
			if (option.dropShadowBlur) option.shadowBlur = option.dropShadowBlur;
			if (option.dropShadowOpacity) option.shadowOpacity = option.dropShadowOpacity;
			if (option.strokeThickness) option.strokeWidth = option.strokeThickness;
			if (option.fontStyle_konva) option.fontStyle = option.fontStyle_konva;
			option.text = text;
			return new Konva.Text(option);
		};
		if (tip==1){
			return new PIXI.Text(text, option);
		};
};

function get_stage_width(cont, tip){
		if ((typeof stage === 'undefined')||(!cont)||(!stage[cont])){
			return 0;
		};
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (stage[cont].konva_obj)
			{
				tip = 0;
			}
			if (stage[cont].pixi_obj){
				tip = 1;
			};
		};
		if (tip==0){
			return get_width(stage[cont])
		};
		if (tip==1){
			return get_width(pixis[cont]);
		};
};


function get_stage_height(cont, tip){
		if ((typeof stage === 'undefined')||(!cont)||(!stage[cont])){
			return 0;
		};
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (stage[cont].konva_obj)
			{
				tip = 0;
			}
			if (stage[cont].pixi_obj){
				tip = 1;
			};
		};
		if (tip==0){
			return get_height(stage[cont])
		};
		if (tip==1){
			return get_height(pixis[cont]);
		};
};

function set_Stage_Width(cont, val, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (stage[cont].konva_obj)
			{
				tip = 0;
			}
			if (stage[cont].pixi_obj){
				tip = 1;
			};
		};
		if (tip==0){
			set_Width(stage[cont], val);
			return 0;
		};
		if (tip==1){
			set_Width(pixis[cont], val);
			return 0;
		};
};

function set_Stage_Height(cont, val, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (stage[cont].konva_obj)
			{
				tip = 0;
			}
			if (stage[cont].pixi_obj){
				tip = 1;
			};
		};
		if (tip==0){
			set_Height(stage[cont], val);
			return 0;
		};
		if (tip==1){
			set_Height(pixis[cont], val);
			return 0;
		};
};



function init_pixi_filters(){
	FiltersGlowTest = new PIXI.filters.ColorMatrixFilter();
	FiltersGlowTest.matrix[0] = 1.15;
	FiltersGlowTest.matrix[6] = 1.15;
//	FiltersGlowTest2 = new PIXI.filters.ColorMatrixFilter();
//	FiltersGlowTest2 = new PIXI.filters.GlowFilter(7, 2, 0, 0xFFFF00, 0.1);
	FiltersGlowTest2 = new PIXI.filters.DropShadowFilter ({rotation: 0, distance: 0, color: 0xFFFF00, alpha: 1, blur: 2, quality: 3});

};

function get_GlowFilter(){
		tip = currentTip;
		if (tip==0){
			return [Konva.Filters.GlowTest];
		};
		if (tip==1){
			return [FiltersGlowTest, FiltersGlowTest2];
		};
	
};


// Apply a saved Flash GlowFilter to one atlas part frame.
// glowData format: [color, alpha, blurX, blurY, strength, quality, inner(0/1), knockout(0/1)]
function apply_flash_glow(where, glowData, tip){
    // glowData (Flash GlowFilter): [color, alpha, blurX, blurY, strength, quality, inner(0/1), knockout(0/1)]
    if (!where || glowData == undefined) return 0;
    // Guard against exported auto-filled arrays where glowData can become numeric 0.
    if ((typeof glowData !== 'object') || (glowData.length == undefined) || (glowData.length <= 0)) return 0;

    if (tip == undefined){
        if (where.konva_obj) tip = 0;
        if (where.pixi_obj) tip = 1;
        if (tip == undefined) tip = currentTip;
    }

    var color   = glowData[0];
    var alpha   = (glowData[1] != undefined) ? glowData[1] : 1;
    var blurX   = (glowData[2] != undefined) ? glowData[2] : 6;
    var blurY   = (glowData[3] != undefined) ? glowData[3] : 6;
    var strength= (glowData[4] != undefined) ? glowData[4] : 2;
    var quality = (glowData[5] != undefined) ? glowData[5] : 1;
    var inner   = (glowData[6] != undefined) ? glowData[6] : 0;
    // knockout is ignored for now.
    // var knockout= (glowData[7] != undefined) ? glowData[7] : 0;

    // sanitize
    alpha = Math.max(0, Math.min(1, alpha));
    if (isNaN(blurX)) blurX = 0;
    if (isNaN(blurY)) blurY = 0;
    if (isNaN(strength)) strength = 1;
    strength = Math.max(0, strength);

    // Flash blurX/blurY -> use the average value.
    var blur = (Math.max(0, blurX) + Math.max(0, blurY)) / 2;

    // Konva/Canvas: when blur == 0 and offset == 0, the image fully covers the shadow,
    // so the minimum blur is 1px to keep the glow visible.
    var minBlur = 1;

    // Glow strength.
    var opacity = Math.max(0, Math.min(1, alpha * strength));

    // --- Konva ---
    if (tip == 0){
        var kBlur = Math.max(minBlur, blur);

        // Konva Group has no shadow* properties:
        // - Shape/Image gets shadow directly.
        // - Container/Group applies shadow recursively to child Shape/Image nodes.
        var applyToKonvaNode = function(node){
            if (!node) return;

            if (typeof node.shadowColor === 'function'){
                node.shadowColor(getHexColor(color));
                node.shadowBlur(kBlur);
                node.shadowOpacity(opacity);
                if (typeof node.shadowOffset === 'function'){
                    node.shadowOffset({x: 0, y: 0});
                }else{
                    if (typeof node.shadowOffsetX === 'function') node.shadowOffsetX(0);
                    if (typeof node.shadowOffsetY === 'function') node.shadowOffsetY(0);
                }
                if (typeof node.shadowEnabled === 'function') node.shadowEnabled(true);
                return;
            }

            // container
            if (typeof node.getChildren === 'function'){
                var kids;
                try{ kids = node.getChildren(); }catch(e){ kids = undefined; }
                if (kids && kids.length){
                    for (var i=0; i<kids.length; i++){
                        applyToKonvaNode(kids[i]);
                    }
                }
            }
        };

        // inner glow 
        applyToKonvaNode(where);
        return 0;
    }

    // --- Pixi ---
    var blur_quality = Math.max(1, Math.round(Math.min(3, quality)));
    var use_outer = (inner == 0);

    // PIXI GlowFilter 
    try{
        if ((typeof PIXI !== 'undefined') && PIXI.filters && PIXI.filters.GlowFilter){
            var f = new PIXI.filters.GlowFilter({
                distance: Math.max(1, blur),
                outerStrength: (use_outer ? strength : 0),
                innerStrength: (!use_outer ? strength : 0),
                color: color,
                quality: blur_quality
            });

            // Apply alpha when the filter supports it.
            if (f.alpha != undefined) f.alpha = opacity;

            if (where.filters && where.filters.length){
                var existing = where.filters.slice(0);
                existing.push(f);
                where.filters = existing;
            }else{
                where.filters = [f];
            }
            if (where._bounds && where._boundsID != undefined) where._boundsID++;
            return 0;
        }
    }catch(e){}

    // Fallback: DropShadow plus a small highlight, matching the older behavior.
    try{
        if ((typeof PIXI !== 'undefined') && PIXI.filters && PIXI.filters.DropShadowFilter){
            var ds = new PIXI.filters.DropShadowFilter({
                distance: 0,
                rotation: 0,
                color: color,
                alpha: opacity,
                blur: Math.max(1, blur),
                quality: blur_quality
            });
            ds.padding = Math.max(10, blur*3);

            if (where.filters && where.filters.length){
                var existing2 = where.filters.slice(0);
                existing2.push(ds);
                where.filters = existing2;
            }else{
                where.filters = [ds];
            }
            if (where._bounds && where._boundsID != undefined) where._boundsID++;
        }
    }catch(e){}
};


function init_filters(){
		tip = currentTip;
		if (tip == 0) {
			this.init_filters_for_konva();
			return 0;
		};
		if (tip == 1){ /*pixi*/
			this.init_filters_for_pixi();
			return 0;
		};

};

var battle_mouse_x = -1;
var battle_mouse_y = -1;

/*
function get_pointer_position_battle(e){
	  var st = document.getElementById(war_scr);
      var rect = st.getBoundingClientRect();
	  if ((e.clientX)&&(e.clientY)){
		  var myLocation = e;
	  }else{
		  if ((e.changedTouches)&&(e.changedTouches[0])){
			  var myLocation = e.changedTouches[0];
		  }else{
			battle_mouse_x = -1;
			battle_mouse_y = -1;
			return 0;
		  };
	  };

	  battle_mouse_x = (myLocation.clientX - rect.left)*MainPixelRatio; //x position within the element.
      battle_mouse_y = (myLocation.clientY - rect.top)*MainPixelRatio;  //y position within the element.
};

function get_pointer(){
	  var zz = false;
	  mouse_delta_x = 0;	  
	  if (currentTip == 0) {
		  if (battle_mouse_x==-1){
			  mousePos = null;
		  }else{
			  mousePos = {};
			  mousePos.x = battle_mouse_x;
			  mousePos.y = battle_mouse_y;
		  };
	  };
	  if (currentTip == 1){
		  if ((stage[war_scr].app)&&(stage[war_scr].app.renderer.plugins.interaction.eventData.data !== null)){
			  global_ok = true;
			  mousePos = stage[war_scr].app.renderer.plugins.interaction.eventData.data.global;
		  }else{
			  if (stage[war_scr].app) mousePos = stage[war_scr].app.renderer.plugins.interaction.mouse.global;
		  };
      };

	  if (!mousePos)
	  {
		  mousePos = Array();
		  mousePos.x = last_mousePos.x;
		  mousePos.y = last_mousePos.y;
	  }else{
		  mouse_delta_x = last_mousePos.x - mousePos.x;

		  last_mousePos.x = mousePos.x;
		  last_mousePos.y = mousePos.y;
		  zz = true;
	  };
};
*/


function get_pointer_position_battle(e){
	  var st = document.getElementById(war_scr);
      var rect = st.getBoundingClientRect();
	  if ((e.clientX)&&(e.clientY)){
		  var myLocation = e;
	  }else{
		  if ((e.changedTouches)&&(e.changedTouches[0])){
			  var myLocation = e.changedTouches[0];
		  }else{
			battle_mouse_x = -1;
			battle_mouse_y = -1;
			return 0;
		  };
	  };


	  var bx = (myLocation.clientX - rect.left)*MainPixelRatio; //x position within the element.
     var by = (myLocation.clientY - rect.top)*MainPixelRatio;  //y position within the element.

	  // Virtual landscape (CSS rotate): remap pointer coords back into unrotated space
	  try{
		  var __lc = document.getElementById('combat_root');
		  if(__lc && __lc.classList && __lc.classList.contains('force_landscape')){
           var tx = by/rect.width*rect.height;
           var ty = (rect.height - bx/MainPixelRatio)/rect.height*rect.width*MainPixelRatio;
			  bx = tx;
			  by = ty;
		  }
	  }catch(e){}

	  battle_mouse_x = bx; //x position within the element.
     battle_mouse_y = by;  //y position within the element.
};

function get_pointer(){
	  var zz = false;
	  mouse_delta_x = 0;	  
	  if (currentTip == 0) {
		  if (battle_mouse_x==-1){
			  mousePos = null;
		  }else{
			  mousePos = {};
			  mousePos.x = battle_mouse_x;
			  mousePos.y = battle_mouse_y;
		  };

	  };
	  if (currentTip == 1){
		  if ((stage[war_scr].app)&&(stage[war_scr].app.renderer.plugins.interaction.eventData.data !== null)){
			  global_ok = true;
			  mousePos = stage[war_scr].app.renderer.plugins.interaction.eventData.data.global;
		  }else{
			  if (stage[war_scr].app) mousePos = stage[war_scr].app.renderer.plugins.interaction.mouse.global;
		  };
      };

	  if (!mousePos)
	  {
		  mousePos = Array();
		  mousePos.x = last_mousePos.x;
		  mousePos.y = last_mousePos.y;
	  }else{

        try{
           var bx = mousePos.x;
           var by = mousePos.y;
           

           var __lc = document.getElementById('combat_root');

            if(__lc && __lc.classList && __lc.classList.contains('force_landscape')){
	           var st = document.getElementById(war_scr);
              var rect = st.getBoundingClientRect();
              var tx = by/rect.width*rect.height;
              var ty = (rect.height - bx/MainPixelRatio)/rect.height*rect.width*MainPixelRatio;
              bx = tx;
              by = ty;
           }

           mousePos.x = bx;
           mousePos.y = by;
        }catch(e){console.error(e);}


		  mouse_delta_x = last_mousePos.x - mousePos.x;

		  last_mousePos.x = mousePos.x;
		  last_mousePos.y = mousePos.y;
		  zz = true;
	  };


};



function set_fontSize(where, ind, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};

		};
		if (tip == 0) {
			where.fontSize(ind);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.style.fontSize = ind;
			return 0;
		};
};

function set_text(where, txt, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) {
			if (typeof where.setAttr === 'function') where.setAttr('text', txt); else{
   			where.text = txt;
         };
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.text = txt;
			return 0;
		};
};


function set_strokeThickness(where, ind, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) {
			where.setAttr('strokeWidth', ind);;
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.style.strokeThickness = ind;
			return 0;
		};
};

function set_strokeThickness_line(where, ind, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) {
			where.setAttr('strokeWidth', ind);;
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.strokeThickness = ind;
			return 0;
		};
};

function set_attr(where, attr, ind, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) {
			if ((attr == 'fill')&&(typeof ind === 'number')) ind = '#'+to6hex(ind);
			where.setAttr(attr, ind);;
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.style[attr] = ind;
			return 0;
		};
};


function set_angle(where, ind, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) {
			where.setAttr('rotation', ind);
			return 0;
		};
		if (tip == 1){ /*pixi*/
			where.angle = ind;
			return 0;
		};
};

function to6hex(num){
	if (num==0) return '000000';

	num = num.toString(16);
	while(num.length<6){
		num = '0'+num;
	};
	return num;
};

function drawLine(bg, points, color, width, alpha, style){
	if (typeof style === 'undefined') style=0.5;
	if ((bg.was_draw)&&(bg.pixi_obj)) bg.clear();
	if (alpha){
		Make_lineStyle(bg, {strokeWidth: width, stroke: color, opacity: alpha, style: style});
	};
	bg.was_draw = true;
	if (color){
		bg.color = color;
	};
	if (bg.konva_obj)
	{
		if ((typeof bg.fillc === 'number')&&(bg.fillc>=0)) bg.setAttr('fill', '#'+to6hex(bg.fillc));
		if (typeof color === 'number')
		{
			bg.setAttr('stroke', '#'+to6hex(color));
		}
		if (bg.closed==true) bg.setAttr('closed', true);
//		bg.points = points;
		bg.setAttrs({'points': points});
		
		return 0;
	};

	if (bg.pixi_obj){
		if (bg.fillc>=0) bg.beginFill(bg.fillc);
		if ((bg.only_rect)&&(bg.closed)&&(points.length==8)&&(points[1]==points[3])&&(points[2]==points[4])&&(points[5]==points[7])&&(points[6]==points[0])){
			bg.drawRect(points[0], points[1], points[2]-points[0], points[5]-points[1]);
		}else{
			bg.moveTo(points[0], points[1]);
			for (var l=2;l<points.length; l+=2) bg.lineTo(points[l], points[l+1]);
			if (bg.closed) bg.lineTo(points[0], points[1]);
		};
		if (bg.fillc>=0) bg.endFill();
	};
};


function set_cache(where, cache, pix_ratio){
	if (where.konva_obj)
	{
		
//		myPixelRatio = 1;
		if (!pix_ratio) pix_ratio = /*myPixelRatio*/1;
		if (cache){
			var cache_options = {pixelRatio: pix_ratio};
			var cache_offset = 0;
			if (typeof where.cache_offset !== 'undefined'){
				cache_offset = parseInt(where.cache_offset, 10);
				if (isNaN(cache_offset)) cache_offset = 0;
			};
			if ((cache_offset>0)&&(typeof where.getClientRect === 'function')){
				try{
					var rect = where.getClientRect({skipTransform: true});
					if ((rect)&&(rect.width>0)&&(rect.height>0)){
						cache_options.x = Math.floor(rect.x-cache_offset);
						cache_options.y = Math.floor(rect.y-cache_offset);
						cache_options.width = Math.ceil(rect.width+cache_offset*2);
						cache_options.height = Math.ceil(rect.height+cache_offset*2);
					};
				}catch(e){}
			};
			where.cache(cache_options);
		}else{
			where.clearCache();
		};
		return 0;
	};
	if (where.pixi_obj){
		where.cacheAsBitmap = false;
		if (cache)
		{
			if (where.calc_bounds){
				var offset = 0;
				var cache_offset = 0;
				if (where.under_shadow)
				{
					offset = 10;
				}
				if (typeof where.cache_offset !== 'undefined'){
					cache_offset = parseInt(where.cache_offset, 10);
					if (isNaN(cache_offset)) cache_offset = 0;
					if (cache_offset>offset) offset = cache_offset;
				};
				if (where.cut_bounds){
					where.calc_bounds_link.x = 0;
					where.calc_bounds_link.y = 0;
					where.x = 0;
					where.y = 0;
				};
			
				var bounds = where.calc_bounds_link.getLocalBounds();
				xp = Math.floor(-bounds.x);
				yp = Math.floor(-bounds.y);
				
				if ((bounds.x<0)||(offset>0)){
					where.calc_bounds_link.x = Math.ceil(-bounds.x + offset);
					where.x = Math.floor(bounds.x - offset);
				};
				if ((bounds.y<0)||(offset>0)){
					where.calc_bounds_link.y = Math.ceil(-bounds.y + offset);
					where.y = Math.floor(bounds.y - offset);
				};
				if (where.cut_bounds){
					var width = bounds.width;
					var height = bounds.height;
					var rect_width = width-xp;
					var rect_height = height-yp;
					if (offset>0){
						rect_width += offset*2;
						rect_height += offset*2;
					};
					if (rect_width<1) rect_width = 1;
					if (rect_height<1) rect_height = 1;
					where.bound_rect =  new PIXI.Rectangle (0, 0, Math.min(stage_width+1+offset*2, rect_width), rect_height)
				}else if (cache_offset>0){
					where.bound_rect =  new PIXI.Rectangle (0, 0, Math.max(1, bounds.width+cache_offset*2), Math.max(1, bounds.height+cache_offset*2))
				};

				var bounds = where.getLocalBounds();
			};
			where.cacheAsBitmap = true;
		}
	};
};


function get_filter(where){
	if (typeof where.filter_array === 'undefined')
	{
		return Array();
	}else{
		return where.filter_array;
	};
}

function set_filter(where, filter){
	where.filter_array = filter;
	if (where.konva_obj)
	{
		if (where.filters)
		{
			where.filters(filter);
		}

		return 0;
	};
	if (where.pixi_obj){
		where.filters = filter;
		return 0;
	};
};

function set_texture(where, image, texture_link){
	if (where.konva_obj)
	{
		where.setAttrs({image: image});

		return 0;
	};
	if (where.pixi_obj){
		where.texture = texture_link;
		return 0;
	};
};



function get_clientRect(where, tip){
		if (typeof tip === 'undefined'){
			tip = currentTip;
			if (where.konva_obj)
			{
				tip = 0;
			}
			if (where.pixi_obj){
				tip = 1;
			};
		};
		if (tip == 0) /*konva*/{
			return where.getClientRect();
		};
		if (tip == 1){ /*pixi*/
			return where.getLocalBounds();
		};

};

/*
PIXI.Texture
.destroy
minus
create_uron
myuron.getBounds()
filter and cache konva
dropShadowBlur
*/

if (typeof show_info_pre_init === 'function')
{
	show_info_pre_init();
}

if (typeof pre_init_map === 'function'){
	pre_init_map();
}
