extends GPUParticles2D
class_name SpyPart

@onready var __fire_gradient: Gradient = Gradient.new()
@onready var __smoke_gradient: Gradient = Gradient.new()
@onready var __rain_gradient: Gradient = Gradient.new()
@onready var __snow_gradient: Gradient = Gradient.new()
@onready var __floater_gradient: Gradient = Gradient.new()

func _ready():
	_set_colour_gradients()
	stop_effect()

func _set_colour_gradients():
	__set_fire_gradients()
	__set_smoke_gradients()
	__set_rain_gradients()
	__set_snow_gradients()
	__set_floater_gradients()

func stop_effect():
	emitting = false

func start_effect():
	emitting = true

func restart_effect():
	restart()

###############################
#             FIRE            #
###############################
func set_fire(
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(1.0, 0.1, 0.0),
	_ttl: float = 2.0
) -> void:
	__create_particles_material(
		Vector3(0.0, -1.0, 0.0),
		0.0,
		_area,
		_speed_scale * 25.0,
		0.0,
		45.0,
		25.0,
		1.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	var __scale_curve_points: Array = []
	__scale_curve_points.push_back(Vector2(0.0, 1.0))
	__scale_curve_points.push_back(Vector2(1.0, 0.25))
	__apply_scale_curve_to_particles_material(__scale_curve_points)
	
	__apply_gradient_to_particles_material(__fire_gradient)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)

func set_fire_with_texture(
	_texture_ref: String,
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(1.0, 0.1, 0.0),
	_ttl: float = 2.0
) -> void:
	__create_particles_material(
		Vector3(0.0, -1.0, 0.0),
		0.0,
		_area,
		_speed_scale * 25.0,
		0.0,
		45.0,
		25.0,
		1.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	var __scale_curve_points: Array = []
	__scale_curve_points.push_back(Vector2(0.0, 1.0))
	__scale_curve_points.push_back(Vector2(1.0, 0.25))
	__apply_scale_curve_to_particles_material(__scale_curve_points)
	
	__apply_gradient_to_particles_material(__fire_gradient)
	
	__apply_texture_to_particles(_texture_ref)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)

func __set_fire_gradients() -> void:
	__fire_gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.9))
	__fire_gradient.add_point(0.333, Color(0.918, 0.457, 0.055, 0.75))
	__fire_gradient.set_color(1, Color(1.0, 0.0, 0.0, 0.333))

###############################
#            SMOKE            #
###############################
func set_smoke(
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(1.0, 0.1, 0.0),
	_ttl: float = 2.0
) -> void:
	__create_particles_material(
		Vector3(0.0, -1.0, 0.0),
		0.0,
		_area,
		_speed_scale * 25.0,
		0.0,
		45.0,
		25.0,
		1.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	var __scale_curve_points: Array = []
	__scale_curve_points.push_back(Vector2(0.0, 1.0))
	__scale_curve_points.push_back(Vector2(1.0, 0.25))
	__apply_scale_curve_to_particles_material(__scale_curve_points)
	
	__apply_gradient_to_particles_material(__smoke_gradient)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)

func set_smoke_with_texture(
	_texture_ref: String,
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(1.0, 0.1, 0.0),
	_ttl: float = 2.0
) -> void:
	__create_particles_material(
		Vector3(0.0, -1.0, 0.0),
		0.0,
		_area,
		_speed_scale * 25.0,
		0.0,
		45.0,
		25.0,
		1.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	var __scale_curve_points: Array = []
	__scale_curve_points.push_back(Vector2(0.0, 1.0))
	__scale_curve_points.push_back(Vector2(1.0, 0.25))
	__apply_scale_curve_to_particles_material(__scale_curve_points)
	
	__apply_gradient_to_particles_material(__smoke_gradient)
	
	__apply_texture_to_particles(_texture_ref)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)

func __set_smoke_gradients() -> void:
	__smoke_gradient.set_color(0, Color(0.0, 0.0, 0.0, 0.9))
	__smoke_gradient.add_point(0.333, Color(0.5, 0.5, 0.5, 0.75))
	__smoke_gradient.set_color(1, Color(0.75, 0.75, 0.75, 0.25))

###############################
#         COLLECTABLE         #
###############################
func set_collectable_with_texture(
	_texture_ref: String,
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(1.0, 0.1, 0.0),
	_ttl: float = 5.0
) -> void:
	
	__create_particles_material(
		Vector3(0.0, -1.0, 0.0),
		0.0,
		_area,
		_speed_scale * 25.0,
		0.25,
		0.0,
		0.0,
		0.5,
		false,
		_accel_scale,
		_size_scale
	)
	
	__apply_texture_to_particles(_texture_ref)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		true,
		0.5
	)

func set_collectable_with_animated_texture(
	_texture_ref: String,
	_h_frames: int,
	_v_frames: int,
	_speed: float = 1.0,
	_loop: bool = true,
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(1.0, 0.1, 0.0),
	_ttl: float = 5.0
) -> void:
	
	__create_particles_material(
		Vector3(0.0, -1.0, 0.0),
		0.0,
		_area,
		_speed_scale * 25.0,
		0.0,
		0.0,
		0.0,
		0.5,
		false,
		_accel_scale,
		_size_scale
	)
	
	__apply_animation_to_particles(
		_texture_ref,
		_h_frames,
		_v_frames,
		_speed,
		_loop
	)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		true,
		0.5
	)

###############################
#            DROPLET          #
###############################
func set_droplet_with_animated_texture(
	_texture_ref: String,
	_h_frames: int = 5,
	_v_frames: int = 1,
	_speed: float = 1.0,
	_loop: bool = false,
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 1,
	_area: Vector3 = Vector3(100.0, 0.0, 0.0),
	_ttl: float = 3.0
) -> void:
	
	__create_particles_material(
		Vector3(0.0, 1.0, 0.0),
		0.0,
		_area,
		0.01,
		0.0,
		0.0,
		0.0,
		0.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	var __bake_res: float = 1000.0
	var __accel_curve_points: Array = []
	var __frames_in_anim: float = _h_frames * _v_frames
	var __frames_in_lifespan: float = _ttl * 60.0 #Performance.get_monitor(Performance.TIME_FPS)
	var __bake_unit: float = 1.0 / __bake_res
	var __flat_until: float = (round((__frames_in_anim / __frames_in_lifespan) * __bake_res) / __bake_res) + __bake_unit
	var __start_on: float = __flat_until + __bake_unit
	__accel_curve_points.push_back(Vector2(0.0, 0.0))
	__accel_curve_points.push_back(Vector2(__flat_until, 0.0))
	__accel_curve_points.push_back(Vector2(__start_on, 1024.0))
	__apply_acceleration_curve_to_particles(__accel_curve_points, __bake_res)
	
	__apply_animation_to_particles(
		_texture_ref,
		_h_frames,
		_v_frames,
		_speed,
		_loop
	)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.5
	)

###############################
#             RAIN            #
###############################
func set_rain(
	_direction: Vector3 = Vector3(0.0, 1.0, 0.0),
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_initial_particle_angle: float = 45.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(100.0, 0.0, 0.0),
	_ttl: float = 3.0
) -> void:
	__create_particles_material(
		_direction,
		2.5,
		_area,
		_speed_scale * 25.0,
		0.1,
		_initial_particle_angle,
		0.0,
		0.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	__apply_gradient_to_particles_material(__rain_gradient)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)

func __set_rain_gradients() -> void:
	__rain_gradient.set_color(0, Color(0.0, 0.0, 1.0, 1.0))
	__rain_gradient.set_color(1, Color(0.0, 0.0, 1.0, 1.0))

func set_rain_with_texture(
	_texture_ref: String,
	_direction: Vector3 = Vector3(0.0, 1.0, 0.0),
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_initial_particle_angle: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(100.0, 0.0, 0.0),
	_ttl: float = 3.0
) -> void:
	__create_particles_material(
		_direction,
		2.5,
		_area,
		_speed_scale * 25.0,
		0.1,
		_initial_particle_angle,
		0.0,
		1.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	__apply_gradient_to_particles_material(__rain_gradient)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)
	
	__apply_texture_to_particles(_texture_ref)

###############################
#             SNOW            #
###############################
func set_snow(
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(100.0, 0.0, 0.0),
	_ttl: float = 5.0
) -> void:
	__create_particles_material(
		Vector3(0.0, 1.0, 0.0),
		10.0,
		_area,
		_speed_scale * 10.0,
		0.25,
		45.0,
		0.0,
		0.0,
		false,
		_accel_scale,
		_size_scale
	)
	
	__apply_gradient_to_particles_material(__snow_gradient)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)

func __set_snow_gradients() -> void:
	__snow_gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.75))
	__snow_gradient.set_color(1, Color(1.0, 1.0, 1.0, 0.75))

###############################
#          EXPLOSION          #
###############################
func set_explosion(
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0, # Make the explosion bigger/smaller by changing this.
	_accel_scale: float = 0.0,
	_quantity: int = 40,
	_area: Vector3 = Vector3(1.0, 1.0, 0.0),
	_ttl: float = 1.0
) -> void:
	__create_particles_material(
		Vector3(0.0, -1.0, 0.0),
		180.0,
		_area,
		_speed_scale * 250.0,
		0.0,
		0.0,
		0.25,
		true,
		1.0,
		_accel_scale,
		_size_scale
	)
	
	var __scale_curve_points: Array = []
	__scale_curve_points.push_back(Vector2(0.0, 1.0))
	__scale_curve_points.push_back(Vector2(1.0, 0.25))
	__apply_scale_curve_to_particles_material(__scale_curve_points)
	
	var __bake_res: float = 100.0
	var __accel_curve_points: Array = []
	__accel_curve_points.push_back(Vector2(0.0, 0.0))
	__accel_curve_points.push_back(Vector2(0.01, -1024.0))
	__apply_acceleration_curve_to_particles(__accel_curve_points, __bake_res)
	
	__apply_gradient_to_particles_material(__fire_gradient)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		true,
		0.95
	)

###############################
#          FLOATERS           #
###############################
func set_floaters(
	_size_scale: float = 1.0,
	_speed_scale: float = 1.0,
	_accel_scale: float = 0.0,
	_quantity: int = 10,
	_area: Vector3 = Vector3(100.0, 100.0, 0.0),
	_ttl: float = 8.0
) -> void:
	__create_particles_material(
		Vector3(0.0, 0.0, 0.0),
		180.0,
		_area,
		_speed_scale * 10.0,
		0.25,
		0.0,
		100.0,
		1.0,
		true,
		_accel_scale,
		_size_scale
	)
	
	__apply_gradient_to_particles_material(__floater_gradient)
	
	__set_particles(
		_speed_scale,
		_quantity,
		_ttl,
		false,
		0.0
	)

func __set_floater_gradients() -> void:
	__floater_gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.0))
	__floater_gradient.add_point(0.5, Color(1.0, 1.0, 1.0, 0.75))
	__floater_gradient.set_color(1, Color(1.0, 1.0, 1.0, 0.0))

###############################
#           GENERIC           #
###############################
func __create_particles_material(
	_direction: Vector3,
	_spread_degrees: float = 0.0, # How far should the direction spread in degrees? 0-360.
	_area: Vector3 = Vector3(1.0, 1.0, 0.0),
	_base_speed: float = 1.0,
	_base_speed_random: float = 0.0,
	_angle: float = 0.0,
	_angle_speed: float = 0.0,
	_angle_random: float = 0.0,
	_angle_align_with_direction: bool = false,
	_accel_scale: float = 0.0, # 0.0 = particles start at full speed.
	_size_scale: float = 1.0 # 1.0 = 1px or 1:1 for a Texture.
) -> void:
	
	process_material = ParticleProcessMaterial.new()
	process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	process_material.emission_box_extents = _area
	process_material.direction = _direction
	process_material.spread = _spread_degrees
	process_material.gravity = Vector3(0.0, 0.0, 0.0)
	process_material.initial_velocity = _base_speed
	process_material.initial_velocity_random = _base_speed_random
	process_material.angle = _angle
	process_material.angular_velocity = _angle_speed
	process_material.angular_velocity_random = _angle_random
	process_material.linear_accel = _accel_scale
	process_material.flag_align_y = _angle_align_with_direction
	process_material.scale = _size_scale

func __apply_scale_curve_to_particles_material(_curve_points: Array) -> void:
	
	var __scale_curve: CurveTexture = CurveTexture.new()
	var __curve: Curve = Curve.new()
	for _point in _curve_points:
		if _point is Vector2:
			__curve.add_point(_point)
	__scale_curve.curve = __curve
	process_material.scale_curve = __scale_curve

func __apply_gradient_to_particles_material(_colour_gradient: Gradient) -> void:
	
	var __colour_gradient_texture: GradientTexture2D = GradientTexture2D.new()
	__colour_gradient_texture.gradient = _colour_gradient
	process_material.color_ramp = __colour_gradient_texture

func __apply_texture_to_particles(_texture_ref: String) -> void:
	var __texture: Texture = load(_texture_ref)
	texture = __texture

func __apply_animation_to_particles(
	_texture_ref: String,
	_h_frames: int = 4,
	_v_frames: int = 1,
	_speed: float = 1.0,
	_loop: bool = true
) -> void:
	var __texture: Texture = load(_texture_ref)
	texture = __texture
	
	var __material: CanvasItemMaterial = CanvasItemMaterial.new()
	__material.particles_animation = true
	__material.particles_anim_h_frames = _h_frames
	__material.particles_anim_v_frames = _v_frames
	__material.particles_anim_loop = _loop
	material = __material
	
	process_material.anim_speed = _speed

func __apply_acceleration_curve_to_particles(_accel_points: Array, _bake_res: int) -> void:
	
	var __accel_curve: CurveTexture = CurveTexture.new()
	var __curve: Curve = Curve.new()
	__curve.bake_resolution = _bake_res
	for _point in _accel_points:
		if _point is Vector2:
			__curve.add_point(_point)
	__accel_curve.curve = __curve
	process_material.linear_accel_curve = __accel_curve

func __set_particles(
	_speed_scale: float = 1.0,
	_quantity: int = 10,
	_ttl: float = 2.0, # seconds
	_one_shot: bool = false,
	_spawn_delay: float = 0.0 # 0-1
) -> void:
	
	emitting = false
	amount = _quantity
	
	lifetime = _ttl
	one_shot = _one_shot
	explosiveness = _spawn_delay
	speed_scale = _speed_scale
	
	local_coords = false
	show_behind_parent = true
