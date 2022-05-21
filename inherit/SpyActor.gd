extends KinematicBody2D
class_name SpyActor

###############################
#           INTERNAL          #
###############################
enum ACTOR_STATE {
	
	IDLE		= 00,
	WALK		= 01,
	
	JUMP_SQUAT	= 10,
	JUMPING		= 11,
	REJUMPING	= 12,
	
	CROUCHING	= 21,
	CROUCH_LAND = 22
}

var UNINTERRUPTABLE_STATES = [
	ACTOR_STATE.JUMP_SQUAT,
	ACTOR_STATE.CROUCH_LAND
]

var state = ACTOR_STATE.IDLE

func __update_state():
	if state in UNINTERRUPTABLE_STATES:
		return
	
	if is_on_floor():
		if __can_crouch and __crouch_is_down:
			state = ACTOR_STATE.CROUCHING
			action_crouch()
		
		elif __direction != Vector2.ZERO:
			state = ACTOR_STATE.WALK
			
		else:
			state = ACTOR_STATE.IDLE

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
var __floor_normal: Vector2 = Vector2.UP
var __direction: Vector2 = Vector2.ZERO
var __processed_direction: Vector2 = Vector2.ZERO
var __velocity: Vector2 = Vector2.ZERO
var __last_velocity: Vector2 = Vector2.ZERO
var __was_on_floor: bool = false
var __was_on_ceiling: bool = false
var __fall_speed_cap: int = 999999999 # OJN: INF is always negative???

# SNAP #
var __use_snap: bool = true
func set_use_snap(_use_snap: bool) -> void:
	__use_snap = _use_snap
func get_use_snap() -> bool:
	return __use_snap

var __snap_direction: Vector2 = Vector2.DOWN
func set_snap_direction(_snap_direction: Vector2) -> void:
	__snap_direction = _snap_direction
func get_snap_direction() -> Vector2:
	return __snap_direction

var __snap_length: float = 32.0
func set_snap_length(_snap_length: float) -> void:
	__snap_length = _snap_length
func get_snap_length() -> float:
	return __snap_length

var __snap_vector: Vector2 = __snap_direction * __snap_length

# CAN MOVE #
var __can_move: bool = false setget set_can_move, get_can_move
func set_can_move(_can_move: bool) -> void:
	__can_move = _can_move
func get_can_move() -> bool:
	return __can_move

var __can_move_x: bool = false setget set_can_move_x, get_can_move_x
func set_can_move_x(_can_move_x: bool) -> void:
	__can_move_x = _can_move_x
func get_can_move_x() -> bool:
	return __can_move_x

var __can_move_y: bool = false setget set_can_move_y, get_can_move_y
func set_can_move_y(_can_move_y: bool) -> void:
	__can_move_y = _can_move_y
func get_can_move_y() -> bool:
	return __can_move_y

func set_can_move_all(_can_move: bool) -> void:
	__can_move = _can_move
	__can_move_x = _can_move
	__can_move_y = _can_move

# CAN JUMP #
var __can_jump: bool = false setget set_can_jump, get_can_jump
func set_can_jump(_can_jump: bool) -> void:
	__can_jump = _can_jump
	__can_float = !__can_jump
func get_can_jump() -> bool:
	return __can_jump

# CAN CROUCH #
var __can_crouch: bool = false setget set_can_crouch, get_can_crouch
func set_can_crouch(_can_crouch: bool) -> void:
	__can_crouch = _can_crouch
func get_can_crouch() -> bool:
	return __can_crouch

# JUMP SQUAT #
var __can_jump_squat: bool = false
var __jump_squat_frame_counter: int = 0
var __jump_is_down: bool = false
var __jumping: bool = false

var __jump_squat_frames: int = 0 setget set_jump_squat_frames, get_jump_squat_frames
func set_jump_squat_frames(_frames: int) -> void:
	__jump_squat_frames = _frames
	__can_jump_squat = __jump_squat_frames > 0
func get_jump_squat_frames() -> int:
	return __jump_squat_frames

# LANDING CROUCH #
var __can_crouch_land: bool = false
var __crouch_land_frame_counter: int = 0
var __crouch_is_down: bool = false
var __crouching: bool = false

var __crouch_land_frames: int = 0 setget set_crouch_land_frames, get_crouch_land_frames
func set_crouch_land_frames(_frames: int) -> void:
	__crouch_land_frames = _frames
	__can_crouch_land = __crouch_land_frames > 0
func get_crouch_land_frames() -> int:
	return __crouch_land_frames

# SHORT HOP #
var __can_short_hop: bool = false setget set_short_hop, get_short_hop
func set_short_hop(_can_short_hop: bool) -> void:
	__can_short_hop = _can_short_hop
func get_short_hop() -> bool:
	return __can_short_hop

var __short_hop_on_release: bool = false setget set_short_hop_on_release, get_short_hop_on_release
func set_short_hop_on_release(_short_hop_on_release: bool) -> void:
	__short_hop_on_release = _short_hop_on_release
func get_short_hop_on_release() -> bool:
	return __short_hop_on_release

var __short_hop_from_jump_squat: bool = false setget set_short_hop_from_jump_squat, get_short_hop_from_jump_squat
func set_short_hop_from_jump_squat(_short_hop_from_jump_squat: bool) -> void:
	__short_hop_from_jump_squat = _short_hop_from_jump_squat
func get_short_hop_from_jump_squat() -> bool:
	return __short_hop_from_jump_squat

# REJUMP #
var __can_rejump: bool = false
var __rejump_counter: int = 0
var __num_rejumps: int = 0 setget set_num_rejumps, get_num_rejumps
func set_num_rejumps(_rejumps: int) -> void:
	__num_rejumps = _rejumps
	__can_rejump = __num_rejumps > 0
func get_num_rejumps() -> int:
	return __num_rejumps

# FLOAT #
var __can_float: bool = false setget set_can_float, get_can_float
func set_can_float(_can_float: bool) -> void:
	__can_float = _can_float
	__can_jump = !__can_float
func get_can_float():
	return __can_float

var __speed: float = 0.0 setget set_speed, get_speed
func set_speed(_speed: float) -> void:
	__speed = _speed
func get_speed() -> float:
	return __speed

var __gravity_multiplier: float = 1.0 setget set_gravity_multiplier, get_gravity_multiplier
func set_gravity_multiplier(_gravity_multiplier: float) -> void:
	__gravity_multiplier = _gravity_multiplier
func get_gravity_multiplier() -> float:
	return __gravity_multiplier

var __acceleration: float = 1.0 setget set_acceleration, get_acceleration
func set_acceleration(_acceleration: float) -> void:
	__acceleration = _acceleration
func get_acceleration() -> float:
	return __acceleration

var __decceleration: float = 1.0 setget set_decceleration, get_decceleration
func set_decceleration(_decceleration: float) -> void:
	__decceleration = _decceleration
func get_decceleration() -> float:
	return __decceleration

var __jump_force: float = 0.0 setget set_jump_force, get_jump_force
func set_jump_force(_jump_force: float) -> void:
	__jump_force = _jump_force
func get_jump_force() -> float:
	return __jump_force

var __rejump_force: float = 0.0 setget set_rejump_force, get_rejump_force
func set_rejump_force(_rejump_force: float) -> void:
	__rejump_force = _rejump_force
func get_rejump_force() -> float:
	return __rejump_force

var __short_hop_force: float = 0.0 setget set_short_hop_force, get_short_hop_force
func set_short_hop_force(_short_hop_force: float) -> void:
	__short_hop_force = _short_hop_force
func get_short_hop_force() -> float:
	return __short_hop_force

var __base_jump_release_multiplier: float = 1.0
var __cur_jump_release_multiplier: float = __base_jump_release_multiplier
var __jump_release_multiplier: float = __base_jump_release_multiplier setget set_jump_release_multiplier, get_jump_release_multiplier
func set_jump_release_multiplier(_jump_release_multiplier: float) -> void:
	__jump_release_multiplier = _jump_release_multiplier
func get_jump_release_multiplier() -> float:
	return __jump_release_multiplier

###############################
#           MOVEMENT          #
###############################
func left() -> void:
	__direction.x -= 1.0
	__update_state()

func left_release() -> void:
	__direction.x += 1.0
	__update_state()

func right() -> void:
	__direction.x += 1.0
	__update_state()

func right_release() -> void:
	__direction.x -= 1.0
	__update_state()

func up() -> void:
	if __can_float:
		__direction.y -= 1.0
	__update_state()

func up_release() -> void:
	if __can_float:
		__direction.y += 1.0
	__update_state()

func down() -> void:
	if __can_float:
		__direction.y += 1.0
	__update_state()

func down_release() -> void:
	if __can_float:
		__direction.y -= 1.0
	__update_state()

func jump() -> void:
	if __can_move and __can_move_y and __can_jump:
		__jump_is_down = true
		
		if is_on_floor():
			if __can_jump_squat:
				if state != ACTOR_STATE.JUMP_SQUAT:
					jump_squat_started()
			else:
				action_jump()
		else:
			if __can_rejump:
				if __rejump_counter < __num_rejumps:
					rejump()

func jump_release() -> void:
	__jump_is_down = false
	if __can_jump and __short_hop_on_release:
		__direction.y = 0.0
		if __velocity.y < 0.0:
			__cur_jump_release_multiplier = __jump_release_multiplier

func action_jump() -> void:
	state = ACTOR_STATE.JUMPING
	__direction.y = -1.0
	if __can_short_hop and __short_hop_on_release:
		if __jump_is_down:
			__cur_jump_release_multiplier = __base_jump_release_multiplier
		else:
			__cur_jump_release_multiplier = __jump_release_multiplier

func rejump() -> void:
	action_rejump()

func action_rejump() -> void:
	__rejump_counter += 1
	action_jump()
	state = ACTOR_STATE.REJUMPING

func jump_squat_started() -> void:
	state = ACTOR_STATE.JUMP_SQUAT

func jump_squat_finished() -> void:
	__jump_squat_frame_counter = 0
	action_jump()

func land() -> void:
	__rejump_counter = 0
	if __can_short_hop and __short_hop_on_release:
		__cur_jump_release_multiplier = __base_jump_release_multiplier
	
	if __can_crouch_land:
		state = ACTOR_STATE.CROUCH_LAND
		crouch_land_started()
	else:
		__update_state()

func crouch_land_started() -> void:
	state = ACTOR_STATE.CROUCH_LAND

func crouch_land_finished() -> void:
	__crouch_land_frame_counter = 0
	__update_state()

func crouch() -> void:
	if __can_move and __can_crouch:
		__crouch_is_down = true
		__update_state()

func crouch_release() -> void:
	__crouch_is_down = false
	__update_state()

func action_crouch() -> void:
	pass

func just_left_floor() -> void:
	state = ACTOR_STATE.JUMPING

func ceiling_hit() -> void:
	pass

func jump_peak() -> void:
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
		
		if __can_move_y:
		
			if !__was_on_floor and is_on_floor():
				
				# Land.
				land()
			
			elif __was_on_floor and !is_on_floor():
				
				# Just left floor.
				just_left_floor()
			
			if !__was_on_ceiling and is_on_ceiling():
				
				ceiling_hit()
			
			if __last_velocity.y <= 0.0 and __velocity.y > 0.0:
				
				jump_peak()
			
			if state == ACTOR_STATE.JUMP_SQUAT:
				
				# Jump squat.
				if __jump_squat_frame_counter == __jump_squat_frames:
					jump_squat_finished()
				else:
					__jump_squat_frame_counter += 1
			
			if state == ACTOR_STATE.CROUCH_LAND:
				
				# Crouch land.
				if __crouch_land_frame_counter == __crouch_land_frames:
					crouch_land_finished()
				else:
					__crouch_land_frame_counter += 1
			
			__was_on_floor = is_on_floor()
			__was_on_ceiling = is_on_ceiling()

func _physics_process(delta):
	if __can_move:
		
		if __can_move_x:
		
			if __direction.x == 0.0:
				
				# Deccelerate.
				__velocity.x = __velocity.linear_interpolate(Vector2.ZERO, __decceleration).x
				
			else:
				
				# Accelerate.
				__processed_direction.x = __direction.x * __speed
				__velocity.x = __velocity.linear_interpolate(__processed_direction, __acceleration).x
		
		if __can_move_y:
		
			if __can_jump:
			
				if __direction.y < 0.0:
						
					if state == ACTOR_STATE.REJUMPING:
						
						# Rejump.
						__velocity.y = __rejump_force * __direction.y
						
					elif __jump_is_down or !__can_short_hop or !__short_hop_from_jump_squat:
						
						# Full hop.
						__velocity.y = __jump_force * __direction.y
						
					else:
						
						# Short hop.
						__velocity.y = __short_hop_force * __direction.y
					
					__direction.y = 0.0
				
			elif __can_float:
				
				if __direction.y == 0.0:
					
					# Deccelerate.
					__velocity.y = __velocity.linear_interpolate(Vector2.ZERO, __decceleration).y
					
				else:
					
					# Accelerate.
					__processed_direction.y = __direction.y * __speed
					__velocity.y = __velocity.linear_interpolate(__processed_direction, __acceleration).y
			
			__velocity.y += SpyWorld.GLOBAL_GRAVITY * __gravity_multiplier * __cur_jump_release_multiplier * delta
			
			# Speed cap.
			__velocity.y = min(__velocity.y, __fall_speed_cap)
		
		# Update the velocity.
		if __use_snap and state != ACTOR_STATE.JUMPING and state != ACTOR_STATE.REJUMPING:
			__velocity = move_and_slide_with_snap(__velocity, __snap_vector, Vector2.UP, true, 4, deg2rad(91))
		else:
			__velocity = move_and_slide(__velocity, __floor_normal, true)
