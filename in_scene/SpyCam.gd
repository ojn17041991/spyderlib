extends Camera2D
class_name SpyCam

var __lerp: bool = false
var __shaking: bool = false
var __force: float = 5.0
var __dampener: float = 0.0

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
	
	if __shaking:
		__dampener = ease($tm.time_left / $tm.wait_time, 1.0)
		offset = Vector2(
			rand_range(-__force, __force) * __dampener,
			rand_range(-__force, __force) * __dampener
		)



func start():
	current = true

func stop():
	current = false

func set_limits(_limits: Rect2):
	limit_left = _limits.position.x
	limit_top = _limits.position.y
	limit_right = _limits.size.x
	limit_bottom = _limits.size.y

func snap_to_position(_pos: Vector2) -> void:
	global_position = _pos

func shake(_time: float, _force: float):
	__shaking = true
	__force = _force
	$tm.wait_time = _time
	$tm.start()

func _on_tm_timeout():
	__shaking = false
	offset = Vector2.ZERO
