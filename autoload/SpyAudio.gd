extends Node

var __audio_path: String = "res://asset/audio"
var __bgm_resources: Dictionary = {
	# Key: <resource name>
	# Value: <dictionary>
		# Resource: <resource>
		# Fading: <bool>
		# Fade_Delta: <float>
		# Fade_To: <float>
}
var __sfx_subscriptions: Dictionary = {}

var __bgm_fade_in_progress: bool = false
var __inaudible_level_db: float = -30.0
var __sfx_vol_db: float = 0.0
var __bgm_vol_db: float = 0.0

onready var __directory: Directory = Directory.new()

func _ready():
	__directory.open(__audio_path + "/bgm")
	__directory.list_dir_begin()
	__recurse_path(__directory)

func __recurse_path(_cur_dir: Directory):
	var _file_name: String = _cur_dir.get_next()
	
	while _file_name != "":
		var _full_file_path: String = _cur_dir.get_current_dir() + "/" + _file_name
		
		if _cur_dir.current_is_dir():
			# This is a folder, so recurse the folder for any other audio files.
			var _sub_directory: Directory = Directory.new()
			_sub_directory.open(_full_file_path)
			_sub_directory.list_dir_begin()
			__recurse_path(_sub_directory)
		else:
			# This is a file, so create the ASP and store it.
			var _resource: AudioStreamPlayer = AudioStreamPlayer.new()
			_resource.set_stream(load(_full_file_path))
			add_child(_resource)
			__bgm_resources[_full_file_path] = {
				"resource": _resource,
				"fading": false,
				"fade_delta": 0.0,
				"fade_to": 0.0
			}
			
			_resource.connect("finished", self, "_bgm_finished")

###############################
#           SIGNALS           #
###############################
signal bgm_finished
signal bgm_fade_in_complete
signal bgm_fade_out_complete
signal sfx_finished

func __bgm_finished(_resource: String):
	emit_signal("bgm_finished", _resource)

func __sfx_finished(_resource: String):
	emit_signal("sfx_finished", _resource)

###############################
#             SFX             #
###############################
func subscribe_to_sfx(_parent: Object, _res_name: String, _sfx_vol_db: float = 0.0) -> void:
	if __directory.file_exists(_res_name):
		
		var _unique_key: String = __get_unique_key(_parent, _res_name)
		if !__sfx_subscriptions[_unique_key]:
			
			var _resource: AudioStreamPlayer = AudioStreamPlayer.new()
			_resource.set_stream(load(_res_name))
			__sfx_subscriptions[_unique_key] = _resource
			__set_sfx_vol_by_unique_key(_unique_key, _sfx_vol_db)
			
			add_child(_resource)
			
			_resource.connect("finished", self, "__sfx_finished")
			_parent.connect("tree_exited", self, "__clear_subscriptions")

func unsubscribe_from_sfx(_parent: Object, _res_name: String) -> void:
	var _parent_id: String = str(_parent.get_instance_id())
	var _unique_key: String = __get_unique_key(_parent, _res_name)
	if __sfx_subscriptions[_unique_key]:
		
		remove_child(__sfx_subscriptions[_unique_key]) # OJN dubious about this line.
		__sfx_subscriptions.erase(_unique_key)
		
		var _subscriptions_remain: bool = false
		for _key in __sfx_subscriptions:
			if _parent_id in _key:
				_subscriptions_remain = true
				break # The object has remaining subscriptions, so don't disconnect them yet.
		
		if !_subscriptions_remain:
			_parent.disconnect("tree_exited", self, "__clear_subscriptions")

func play_sfx(_parent: Object, _res_name: String) -> void:
	var _unique_key: String = __get_unique_key(_parent, _res_name)
	if __sfx_subscriptions[_unique_key]:
		if !__sfx_subscriptions[_unique_key].is_playing():
			__sfx_subscriptions[_unique_key].play()

func stop_sfx(_parent: Object, _res_name: String) -> void:
	var _unique_key: String = __get_unique_key(_parent, _res_name)
	if __sfx_subscriptions[_unique_key]:
		if __sfx_subscriptions[_unique_key].is_playing():
			__sfx_subscriptions[_unique_key].stop()

func set_global_sfx_vol(_sfx_vol_db: float) -> void:
	var _sfx_delta: float = _sfx_vol_db - __sfx_vol_db
	for _key in __sfx_subscriptions:
		__sfx_subscriptions[_key].volume_db += _sfx_delta
	__sfx_vol_db = _sfx_vol_db

func set_sfx_vol(_parent: Object, _res_name: String, _sfx_vol_db: float) -> void:
	var _unique_key: String = __get_unique_key(_parent, _res_name)
	__set_sfx_vol_by_unique_key(_unique_key, _sfx_vol_db)

func __clear_subscriptions(_parent: Object) -> void:
	var _parent_id: String = str(_parent.get_instance_id())
	for _key in __sfx_subscriptions:
		if _parent_id in _key:
			remove_child(__sfx_subscriptions[_key]) # OJN dubious about this line.
			__sfx_subscriptions.erase(_key)

func __set_sfx_vol_by_unique_key(_unique_key: String, _sfx_vol_db: float) -> void:
	if __sfx_subscriptions[_unique_key]:
		__sfx_subscriptions[_unique_key].volume_db = __sfx_vol_db + _sfx_vol_db

func __get_unique_key(_parent: Object, _res_name: String) -> String:
	return str(_parent.get_instance_id()) + _res_name

# AudioStreamPlayer.pitch_scale

###############################
#             BGM             #
###############################
func play_bgm(_res_name: String, _bgm_vol_db: float = 0.0) -> void:
	if __bgm_resources[_res_name]:
		if !__bgm_resources[_res_name]["resource"].is_playing():
			__bgm_resources[_res_name]["resource"].play()

func stop_bgm(_res_name: String) -> void:
	if __bgm_resources[_res_name]:
		if __bgm_resources[_res_name]["resource"].is_playing():
			__bgm_resources[_res_name]["resource"].stop()

func fade_in_bgm_over_time(_res_name: String, _time_secs: float, _bgm_vol_db: float = 0.0) -> void:
	if __bgm_resources[_res_name]:
		if !__bgm_resources[_res_name]["resource"].is_playing():
			__bgm_resources[_res_name]["fading"] = true
			__bgm_resources[_res_name]["fade_dir"] = "in"
			__bgm_resources[_res_name]["fade_to"] = __bgm_vol_db + _bgm_vol_db
			__bgm_resources[_res_name]["fade_delta"] = (__bgm_resources[_res_name]["fade_to"] - __inaudible_level_db) / _time_secs
			__bgm_resources[_res_name]["resource"].volume_db = __inaudible_level_db
			__bgm_resources[_res_name]["resource"].play()
			__bgm_fade_in_progress = true

func fade_out_bgm_over_time(_res_name: String, _time_secs: float) -> void:
	if __bgm_resources[_res_name]:
		if __bgm_resources[_res_name]["resource"].is_playing():
			__bgm_resources[_res_name]["fading"] = true
			__bgm_resources[_res_name]["fade_dir"] = "out"
			__bgm_resources[_res_name]["fade_to"] = __inaudible_level_db
			__bgm_resources[_res_name]["fade_delta"] = (__bgm_resources[_res_name]["fade_to"] - __bgm_resources[_res_name]["resource"].volume_db) / _time_secs
			__bgm_fade_in_progress = true

func set_global_bgm_vol(_bgm_vol_db: float) -> void:
	var _bgm_delta: float = _bgm_vol_db - __bgm_vol_db
	for _key in __bgm_resources:
		__bgm_resources[_key].volume_db += _bgm_delta
		if __bgm_resources[_key]["fading"]:
			__bgm_resources[_key]["fade_to"] += _bgm_delta
	__bgm_vol_db = _bgm_vol_db

func _process(delta):
	if __bgm_fade_in_progress:
		for _key in __bgm_resources:
			if __bgm_resources[_key]["fading"]:
				
				__bgm_resources[_key]["resource"].volume_db += __bgm_resources[_key]["fade_delta"] * delta
				
				# If the BGM resource has completed its fade.
				if ((__bgm_resources[_key]["fade_dir"] == "in" and 
					__bgm_resources[_key]["resource"].volume_db >= __bgm_resources[_key]["fade_to"])
					or
					(__bgm_resources[_key]["fade_dir"] == "out" and
					__bgm_resources[_key]["resource"].volume_db <= __bgm_resources[_key]["fade_to"])):
						
						__bgm_resources[_key]["resource"].volume_db = __bgm_resources[_key]["fade_to"]
						__bgm_resources[_key]["fading"] = false
						__bgm_fade_complete(_key)

func __bgm_fade_complete(_res_name: String) -> void:
	var __reset_bgm_fade_in_progress: bool = true
	for _key in __bgm_resources:
		if __bgm_resources["fading"]:
			__reset_bgm_fade_in_progress = false
			break
	if __reset_bgm_fade_in_progress:
		__bgm_fade_in_progress = false
	emit_signal("bgm_fade_in_complete", _res_name)
