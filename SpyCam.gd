extends Camera2D
class_name SpyCam

#########
# SETUP: 
#########
# - Create a Camera2D as a child of the player, and assign it this script.
# - In the player script, call start() to enable the camera, and stop() to disable it.
# - Set the limits of the camera by calling set_limits(Rect2).
# - If screen shake is supported:
#   - Create a Timer as a child of the Camera2D and name it "tm". Connect its timeout.
#   - Setup SpyRequest as an Autoload. Call SpyRequest.request_screen_shake(_ms) to use.
#########

var __shaking: bool = false
var __force: float = 5.0
var __dampener: float = 0.0

var __lerping: bool = false
var __zoom_lerp_end_level: Vector2 = Vector2.ZERO

var __zoom_min: float = 0.0
var __zoom_max: float = 1.0


func _ready():
	SpyRequest.connect("screen_shake_start", _screen_shake_start)

func _process(delta):
	if __shaking:
		__dampener = ease($tm.time_left / $tm.wait_time, 1.0)
		offset = Vector2(
			randf_range(-__force, __force) * __dampener,
			randf_range(-__force, __force) * __dampener
		)
	
	if __lerping:
		zoom = lerp(zoom, __zoom_lerp_end_level, 0.1)
		if zoom == __zoom_lerp_end_level:
			__lerping = false

func _screen_shake_start(_ms: float, _force: float) -> void:
	__shaking = true
	__force = _force
	$tm.wait_time = _ms / 1000.0
	$tm.start()

func _on_tm_timeout() -> void:
	__shaking = false
	offset = Vector2.ZERO
	SpyRequest.complete_screen_shake()



func start() -> void:
	enabled = true

func stop() -> void:
	enabled = false

func set_limits(_limits: Rect2) -> void:
	limit_left = _limits.position.x
	limit_top = _limits.position.y
	limit_right = _limits.position.x + _limits.size.x
	limit_bottom = _limits.position.y + _limits.size.y

func set_zoom_limits(_min: float, _max: float):
	__zoom_min = _min
	__zoom_max = _max

func set_zoom_level(_scale: float) -> void:
	if _scale < __zoom_min:
		_scale = __zoom_min
	elif _scale > __zoom_max:
		_scale = __zoom_max
	zoom = Vector2(_scale, _scale)

func adjust_zoom_level(_increment: float) -> void:
	if zoom.x + _increment < __zoom_min:
		set_zoom_level(__zoom_min)
		return
	elif zoom.x + _increment > __zoom_max:
		set_zoom_level(__zoom_max)
		return
	zoom += Vector2(_increment, _increment)

func lerp_to_zoom(_scale: float) -> void:
	if _scale <= 0.0:
		return
	__zoom_lerp_end_level = Vector2(_scale, _scale)
	__lerping = true
