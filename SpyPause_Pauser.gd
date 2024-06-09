extends Node2D

#########
# SETUP: 
#########
# - Create a Node2D in your level scene and assign it this script.
# - Create an input map for "input_pause".
# - Set Node2D PROCESS_MODE to PROCESS.
# - If freeze frames are supported:
#   - Set allow_freeze to true in the Inspector.
#   - Create a second Node2D as a child of the first and name it SpyPause_Freezer.
#   - Assign the second Node2D the SpyPause_Freezer.gd script.
#   - Read SpyPause_Freezer.gd setup section.
#########

signal paused
signal unpaused

var __paused: bool = false
var __pausable: bool = true:
	set = set_pausable,
	get = get_pausable
func set_pausable(_pausable: bool) -> void:
	__pausable = _pausable
func get_pausable() -> bool:
	return __pausable

@export var allow_freeze: bool = false

func _process(delta):
	if __pausable and Input.is_action_just_pressed("input_pause"):
		__paused = !__paused
		if __paused:
			if allow_freeze:
				$SpyPause_Freezer.process_mode = Node.PROCESS_MODE_PAUSABLE
			get_tree().paused = true
			emit_signal("paused")
		else:
			if allow_freeze:
				$SpyPause_Freezer.process_mode = Node.PROCESS_MODE_ALWAYS
				get_tree().paused = $SpyPause_Freezer.is_frozen()
			get_tree().paused = false
			emit_signal("unpaused")
