extends CPUParticles2D
class_name SpyPartWeb

############
# EXAMPLES #
############
func example_explosion():
	create_particles_material(
		ParticleProcessMaterial.EMISSION_SHAPE_BOX,
		Vector2(1.0, 1.0),
		Vector2(0.0, -1.0),
		360.0 / 2.0, # Half your desired angle. The angle extends in BOTH directions.
		Vector2.ZERO,
		500.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, 10.0
	)

	var scale_curve_points: Array = []
	scale_curve_points.push_back(Vector2(0.0, 1.0))
	scale_curve_points.push_back(Vector2(1.0, 0.0))
	apply_scale_curve(scale_curve_points)

	var accel_curve_points: Array = []
	accel_curve_points.push_back(Vector2(0.0, 0.0))
	accel_curve_points.push_back(Vector2(0.1, -1024.0))
	apply_acceleration_curve(accel_curve_points)

	apply_texture("res://asset/sprite/particle.png")

	var gradient: Gradient = Gradient.new()
	gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.9))
	gradient.add_point(0.333, Color(0.918, 0.457, 0.055, 0.75))
	gradient.set_color(1, Color(1.0, 0.0, 0.0, 0.333))
	apply_gradient(gradient)

	set_particles(50, 1.0, 0.75, true, 0.95)

func example_fire():
	create_particles_material(
		ParticleProcessMaterial.EMISSION_SHAPE_BOX,
		Vector2(45.0, 5.0),
		Vector2(0.0, -1.0),
		0.0,
		Vector2.ZERO,
		100.0, 0.0, 45.0, 0.0, 0.0, 25.0, false, 3.0
	)
	
	var scale_curve_points: Array = []
	scale_curve_points.push_back(Vector2(0.0, 1.0))
	scale_curve_points.push_back(Vector2(1.0, 0.25))
	apply_scale_curve(scale_curve_points)
	
	apply_texture("res://asset/particle.png")

	var gradient: Gradient = Gradient.new()
	gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.9))
	gradient.add_point(0.333, Color(0.918, 0.457, 0.055, 0.75))
	gradient.set_color(1, Color(1.0, 0.0, 0.0, 0.333))
	apply_gradient(gradient)
	
	set_particles(50, 1.0, 1.5, false, 0.0)

func example_rain():
	
	create_particles_material(
		ParticleProcessMaterial.EMISSION_SHAPE_BOX,
		Vector2(250.0, 1.0),
		Vector2(0.0, 1.0),
		5.0 / 2.0,
		Vector2.ZERO,
		500.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, 2.0
	)
	
	var gradient: Gradient = Gradient.new()
	gradient.set_color(0, Color(0.0, 0.0, 1.0))
	gradient.set_color(1, Color(0.0, 0.0, 1.0))
	apply_gradient(gradient)
	
	apply_texture("res://asset/rain_part.png")
	
	set_particles(75, 1.5, 2.0, false, 0.0)

# Stops the effect.
func stop_effect() -> void:
	emitting = false

# Starts the effect. Call all setup functions below first before calling this.
func start_effect() -> void:
	emitting = true

# Basic function for creating the material. Always call this first.
func create_particles_material(
	_emission_shape: int = ParticleProcessMaterial.EMISSION_SHAPE_BOX,	# The shape of the emission area.
	_emission_area: Vector2 = Vector2(1.0, 1.0),					# The size of the emission area.
	_direction: Vector2 = Vector2.ZERO,								# Base direction in which the particles should move.
	_spread_degrees: float = 0.0,									# Additional spread applied to the base direction.
	_gravity: Vector2 = Vector2.ZERO,								# The gravity to apply to the particles.
	_initial_velocity: float = 1.0,									# .
	_initial_velocity_random: float = 0.0,							# .
	_angle: float = 0.0,											# Angle of the particles.
	_angular_velocity: float = 0.0,									# Rotation speed of the particles.
	_angular_velocity_random: float = 0.0,							# Rotation speed random factor.
	_accel_scale: float = 0.0,										# 0=full speed. Use 0 if using acceleration curve.
	_angle_align_with_direction: bool = false,						# Align particle angle with direction?
	_size_scale: float = 1.0 										# 1=1px (or 1:1 for a Texture).
) -> void:
	
	emission_shape = _emission_shape
	emission_rect_extents = _emission_area
	direction = _direction
	spread = _spread_degrees
	gravity = _gravity
	initial_velocity_min = _initial_velocity
	initial_velocity_max = _initial_velocity
	angle_min = _angle
	angle_max = _angle
	angular_velocity_min = _angular_velocity
	angular_velocity_max = _angular_velocity
	linear_accel_min = _accel_scale
	linear_accel_max = _accel_scale
	particle_flag_align_y = _angle_align_with_direction
	scale_amount_min = _size_scale
	scale_amount_max = _size_scale

# Applys a scale curve to the size of the particles.
func apply_scale_curve(_curve_points: Array) -> void:
	
	var __curve: Curve = Curve.new()
	for _point in _curve_points:
		if _point is Vector2:
			__curve.add_point(_point)
	scale_amount_curve = __curve

# Applys a colour gradient to the particles.
func apply_gradient(_colour_gradient: Gradient) -> void:
	
	color_ramp = _colour_gradient

# Replaces the single-pixel base particle with a texture.
func apply_texture(_texture_ref: String) -> void:
	
	var __texture: Texture = load(_texture_ref)
	texture = __texture

# Applys an acceleration curve to the speed of the particles. Bake res is the resolution of the curve graph.
func apply_acceleration_curve(_accel_points: Array, _bake_res: int = 100) -> void:
	
	var __curve: Curve = Curve.new()
	__curve.bake_resolution = _bake_res
	for _point in _accel_points:
		if _point is Vector2:
			__curve.add_point(_point)
	linear_accel_curve = __curve

# Sets up the particle engine itself. Call this last.
func set_particles(
	_quantity: int = 10,		# The number of particles emitted at once.
	_speed_scale: float = 1.0,	# The speed of the particles.
	_ttl_seconds: float = 2.0,	# Lifespan of each particle.
	_one_shot: bool = false,	# Emit once? Or continuous?
	_explosiveness: float = 0.0	# The emission timing of each particle in relation to the others.
) -> void:
	
	emitting = false
	amount = _quantity
	lifetime = _ttl_seconds
	one_shot = _one_shot
	explosiveness = _explosiveness
	speed_scale = _speed_scale
	local_coords = false
	show_behind_parent = true
