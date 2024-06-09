extends Node2D

@onready var SCREEN_SIZE: Vector2 = Vector2(
	float(ProjectSettings.get_setting("display/window/size/viewport_width")),
	float(ProjectSettings.get_setting("display/window/size/viewport_height"))
)

var WORLD_SIZE: Vector2 = Vector2(0.0, 0.0):
	set = set_world_size,
	get = get_world_size
func set_world_size(_size: Vector2) -> void:
	WORLD_SIZE = _size
func get_world_size() -> Vector2:
	return WORLD_SIZE

var GRID_SIZE: Vector2 = Vector2(0.0, 0.0):
	set = set_grid_size,
	get = get_grid_size
func set_grid_size(_size: Vector2) -> void:
	GRID_SIZE = _size
func get_grid_size() -> Vector2:
	return GRID_SIZE

const GLOBAL_GRAVITY: float = 500.0
const GLOBAL_SCREEN_WRAP: bool = false # Not currently implemented.
