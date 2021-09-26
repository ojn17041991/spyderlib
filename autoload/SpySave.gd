extends Node

var __game_save_name: String = ""
var __checkpoints: Dictionary = {}

func _init():
	__game_save_name = ProjectSettings.get_setting("application/config/name")
	__game_save_name = __game_save_name.replace(" ", "") # Some OS's won't like spaces in filenames.
	__game_save_name = __game_save_name.replace("_", "") # We'll split on "_" later, so strip them from the project name here.

func save_checkpoint(_id: int, _checkpoint_dict: Dictionary) -> void:
	__checkpoints[_id] = _checkpoint_dict

func load_checkpoint(_id: int) -> Dictionary:
	if __checkpoints[_id]:
		return __checkpoints[_id]
	else:
		return {}

func clear_checkpoint(_id: int) -> void:
	if __checkpoints[_id]:
		__checkpoints[_id] = {}

func save_to_file(_file_name: String, _save_id: int, _save_dict: Dictionary) -> void:
	var _file = File.new()
	
	var _full_file_name: String = "user://" + __game_save_name + "_" + str(_save_id)
	_file.open(_full_file_name, File.WRITE)
	
	var json: String = JSON.print(_save_dict)
	_file.store_string(json)
	
	_file.close()

func load_from_file(_file_name: String) -> Dictionary:
	var _file = File.new()
	
	if _file.file_exists(_file_name):
		_file.open(_file_name, File.READ)
		var _save_dict = parse_json(_file.get_as_text())
		_file.close()
		return _save_dict
	else:
		return {}
