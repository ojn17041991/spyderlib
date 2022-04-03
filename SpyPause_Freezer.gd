extends Node2D

#########
# SETUP: 
#########
# - Run through the SpyPause_Pauser.gd setup section BEFORE this one.
# - You should already have a Node2D setup, named and attached with this script.
# - Create a Timer as a child of the Node2D and name it "tm". Connect its timeout.
# - Setup SpyRequest as an Autoload. Call SpyRequest.request_freeze_frame(_ms) to use.
#########

var __frozen: bool = false
func is_frozen() -> bool:
	return __frozen

func _ready():
	SpyRequest.connect("freeze_frame_start", self, "_freeze_frame_start")

func _freeze_frame_start(_ms: float) -> void:
	__frozen = true
	get_tree().paused = true
	$tm.wait_time = _ms / 1000.0
	$tm.start()

func _on_tm_timeout() -> void:
	__frozen = false
	get_tree().paused = false
	SpyRequest.complete_freeze_frame()
