extends Camera2D
class_name SpyCam

var __lerp: bool = false

var __fixed: bool = false setget set_fixed, get_fixed
func set_fixed(_fixed: bool) -> void:
	__fixed = _fixed
func get_fixed() -> bool:
	return __fixed

var __target: Node2D = null setget set_target, get_target
func set_target(_target: Node2D) -> void:
	__target = _target
func get_target() -> Node2D:
	return __target

var __speed: float = 0.0 setget set_speed, get_speed
func set_speed(_speed: float) -> void:
	__speed = _speed
	__lerp = __speed > 0.0
func get_speed() -> float:
	return __speed

func _process(delta):
	if !__fixed and __target:
		if __lerp:
			global_position = lerp(global_position, __target.global_position, __speed * delta)
		else:
			global_position = __target.global_position
