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



func _ready():
	SpyRequest.connect("screen_shake_start", self, "_screen_shake_start")

func _process(delta):
	if __shaking:
		__dampener = ease($tm.time_left / $tm.wait_time, 1.0)
		offset = Vector2(
			rand_range(-__force, __force) * __dampener,
			rand_range(-__force, __force) * __dampener
		)

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
	current = true

func stop() -> void:
	current = false

func set_limits(_limits: Rect2) -> void:
	limit_left = _limits.position.x
	limit_top = _limits.position.y
	limit_right = _limits.size.x
	limit_bottom = _limits.size.y
