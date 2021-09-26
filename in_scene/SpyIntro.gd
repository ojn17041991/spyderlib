extends AnimationPlayer
class_name SpyIntro

onready var __animation: Animation = Animation.new()
onready var __splash_texture: StreamTexture = preload("res://spyderlib/in_scene/intro_resources/splash.png")
onready var __splash_sprite: Sprite = Sprite.new()

func _ready():
	# The parent needs to connect to SpyIntro.animation_finished.
	
	__animation.length = 4.0
	
	__splash_sprite.texture = __splash_texture
	var __splash_position: Vector2 = SpyWorld.SCREEN_SIZE / 2.0
	__splash_sprite.global_position = __splash_position
	__splash_sprite.visible = false
	__splash_sprite.connect("ready", self, "_splash_ready")
	add_child(__splash_sprite)

func _splash_ready():
	var __splash_path: String = __splash_sprite.get_path()
	
	var __visible_track_idx: int = __animation.add_track(Animation.TYPE_VALUE)
	__animation.track_set_path(__visible_track_idx, __splash_path + ":visible")
	__animation.track_insert_key(__visible_track_idx, 1.0, true)
	__animation.track_insert_key(__visible_track_idx, 3.0, false)
	
	var __modulate_track_idx: int = __animation.add_track(Animation.TYPE_VALUE)
	__animation.track_set_path(__modulate_track_idx, __splash_path + ":modulate:a")
	__animation.track_insert_key(__modulate_track_idx, 0.0, 0.0)
	__animation.track_insert_key(__modulate_track_idx, 1.0, 0.0)
	__animation.track_insert_key(__modulate_track_idx, 1.3, 1.0)
	__animation.track_insert_key(__modulate_track_idx, 2.7, 1.0)
	__animation.track_insert_key(__modulate_track_idx, 3.0, 0.0)
	
	add_animation("fade", __animation)
	play("fade")
