extends Node

var __update_fps: bool = false
var __cur_fps: String = ""

signal fps_update

func show():
	__update_fps = true

func hide():
	__update_fps = false
	__set_fps("")

func _process(delta):
	if __update_fps:
		__set_fps(str(Performance.get_monitor(Performance.TIME_FPS)))

func __set_fps(_fps):
	if OS.is_debug_build():
		__cur_fps = _fps
		emit_signal("fps_update", __cur_fps)
