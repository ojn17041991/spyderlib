extends Node2D
class_name SpyObject

###############################
#           INTERNAL          #
###############################
func __complete_move_to_position() -> void:
	global_position.x = __target_position.x
	in_position(__target_position)
	__moving_to_position = false
	__target_position = Vector2.ZERO
	__speed = __prev_speed
	__prev_speed = 0.0

func __step_toward_position(_delta: float) -> void:
	global_position = global_position + ((__target_position - global_position).normalized() * __speed * _delta)

func __step_in_direction(_delta: float) -> void:
	global_position = global_position + (__direction * __speed * _delta)

func __step_in_circle(_delta: float) -> void:
	__circle_angle += __speed * _delta
	__circle_offset = Vector2(sin(__circle_angle), cos(__circle_angle)) * __circle_radius
	global_position = __circle_center_position + __circle_offset

###############################
#          RESOURCES          #
###############################
var __ecb: CollisionShape2D = null setget set_ecb, get_ecb
func set_ecb(_ecb: CollisionShape2D) -> void:
	__ecb = _ecb
func get_ecb() -> CollisionShape2D:
	return __ecb

var __collision_shapes: Dictionary = {}
func store_collision_shape(_id: String, _obj: CollisionShape2D) -> bool:
	if __collision_shapes[_id]:
		return false
	else:
		__collision_shapes[_id] = _obj
		return true

var __spawnable_objects: Dictionary = {}
func store_spawnable_object(_id: String, _obj: Node2D) -> bool:
	if __spawnable_objects[_id]:
		return false
	else:
		__spawnable_objects[_id] = _obj
		return true

###############################
#          VARIABLES          #
###############################
var __can_move: bool = false
var __direction: Vector2 = Vector2.ZERO

var __prev_speed: float = 0.0
var __speed: float = 0.0 setget set_speed, get_speed
func set_speed(_speed: float) -> void:
	__speed = _speed
func get_speed() -> float:
	return __speed

###############################
#          MOVEMENT           #
###############################
var __moving_to_position: bool = false
var __moving_in_direction: bool = false
var __moving_in_circle: bool = false
var __target_position: Vector2 = Vector2.ZERO
var __circle_center_position: Vector2 = Vector2.ZERO
var __circle_angle: float = 0.0
var __circle_radius: float = 0.0
var __circle_offset: Vector2 = Vector2.ZERO

func move_to_position(_position: Vector2) -> void:
	__target_position = _position
	__prev_speed = __speed
	__moving_to_position = true

func move_to_position_over_time(_position: Vector2, _time_seconds: float) -> void:
	__target_position = _position
	__prev_speed = __speed
	__speed = (__target_position.x - global_position.x) / _time_seconds
	__moving_to_position = true

func move_in_direction(_direction: Vector2) -> void:
	__direction = _direction
	__moving_in_direction = true

func move_in_direction_from_position(_position: Vector2) -> void:
	var rotation = _position.angle()
	__direction = Vector2(cos(rotation), sin(rotation))
	__moving_in_direction = true

func move_in_mouse_direction() -> void:
	var rotation = get_local_mouse_position().angle()
	__direction = Vector2(cos(rotation), sin(rotation))
	__moving_in_direction = true

func stop_movement() -> void:
	__can_move = false

func start_movement() -> void:
	__can_move = true

func move_in_circle(_radius: float) -> void:
	__circle_center_position = global_position
	__circle_radius = _radius
	__moving_in_circle = true

func in_position(_target_position) -> void:
	pass

func outside_room() -> void:
	pass

func off_screen() -> void:
	pass

###############################
#          COLLISION          #
###############################
func update_collision_circle(_radius: float, _include: Array) -> bool:
	if __ecb || __collision_shapes.size() > 0:
		var circle = CircleShape2D.new()
		circle.set_radius(_radius)
		if __ecb:
			__ecb.set_shape(circle)
		for c_key in __collision_shapes:
			for i in _include:
				if i == "*" or i == c_key:
					__collision_shapes[c_key].set_shape(circle)
		return true
	else:
		return false

func update_collision_rectangle(_width: float, _height: float, _include: Array) -> bool:
	if __ecb || __collision_shapes.size() > 0:
		var rectangle = RectangleShape2D.new()
		rectangle.set_extents(Vector2(_width, _height))
		if __ecb:
			__ecb.set_shape(rectangle)
		for c_key in __collision_shapes:
			for i in _include:
				if i == "*" or i == c_key:
					__collision_shapes[c_key].set_shape(rectangle)
		return true
	else:
		return false

###############################
#            SPAWNS           #
###############################
func spawn_object(_id: String) -> Node2D:
	if __spawnable_objects[_id]:
		return __spawnable_objects[_id].new()
	else:
		return null

###############################
#           PROCESS           #
###############################
func _process(delta):
	if __can_move:
		if __moving_to_position:
			if abs(global_position.x - __target_position.x) < (__speed * delta):
				__complete_move_to_position()
			else:
				__step_toward_position(delta)
		elif __moving_in_direction:
			__step_in_direction(delta)
		elif __moving_in_circle:
			__step_in_circle(delta)
		if __speed > 0.0:
			if (global_position.x < SpyWorld.SCREEN_SIZE.position.x or
				global_position.y < SpyWorld.SCREEN_SIZE.position.y or
				global_position.x > SpyWorld.SCREEN_SIZE.size.x or
				global_position.y > SpyWorld.SCREEN_SIZE.size.y):
				outside_room() # OJN: This will depend on whether or not there is a camera, what its bounds are, and its current position.
