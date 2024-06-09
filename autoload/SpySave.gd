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
	var _full_file_name: String = "user://" + __game_save_name + "_" + str(_save_id)
	var _file: FileAccess = FileAccess.open(_full_file_name, FileAccess.WRITE)
	
	var json: String = JSON.stringify(_save_dict)
	_file.store_string(json)
	
	_file.close()

func load_from_file(_file_name: String) -> Dictionary:	
	if FileAccess.file_exists(_file_name):
		var _file: FileAccess = FileAccess.open(_file_name, FileAccess.READ)
		var _save_dict = JSON.parse_string(_file.get_as_text())
		_file.close()
		return _save_dict
	else:
		return {}
