extends Node

###############################
#           INTERNAL          #
###############################
var __text_stack: Array = []
var __char_ptr: int = 0
var __dialogue_ptr: int = 0
@onready var __char_timer: Timer = Timer.new()
@onready var __dialogue_timer: Timer = Timer.new()

func _ready():
	__char_timer.set_one_shot(false)
	__char_timer.set_wait_time(__char_speed_normal)
	__char_timer.connect("timeout", __char_timeout)
	add_child(__char_timer)
	
	__dialogue_timer.set_one_shot(true)
	__dialogue_timer.set_wait_time(__dialogue_speed)
	__dialogue_timer.connect("timeout", __dialogue_timeout)
	add_child(__dialogue_timer)

func __char_timeout():
	var _char = __text_stack[__dialogue_ptr]["text"][__char_ptr]
	__char_ptr += 1
	
	if __char_ptr < __text_stack[__dialogue_ptr]["text"].length():
		pass # Timer is not one-shot, so let it run.
	else:
		__char_timer.stop()
		__reading_dialogue = false
		emit_signal("final_char_in_dialogue")
		if __auto_advance_dialogue:
			__dialogue_timer.start()
	
	emit_signal("char_complete", _char)

func __dialogue_timeout():
	emit_signal("dialogue_complete", __text_stack[__dialogue_ptr]["id"])
	__dialogue_ptr += 1
	
	if __dialogue_ptr < __text_stack.size():
		__reading_dialogue = true
		__char_ptr = 0
		__char_timer.set_wait_time(__char_speed_normal)
		__char_timer.start()
	else:
		__char_ptr = 0
		__dialogue_ptr = 0
		__text_stack = []
		emit_signal("stack_complete")


###############################
#           SIGNALS           #
###############################
signal char_complete
signal dialogue_start
signal dialogue_complete
signal stack_start
signal stack_complete
signal final_char_in_dialogue

###############################
#          VARIABLES          #
###############################
var __char_speed_normal: float = 0.05:
	set = set_char_speed_normal,
	get = get_char_speed_normal
func set_char_speed_normal(_char_speed_normal: float) -> void:
	__char_timer.set_wait_time(__char_speed_normal)
func get_char_speed_normal() -> float:
	return __char_speed_normal

var __char_speed_fast: float = 0.005:
	set = set_char_speed_fast,
	get = get_char_speed_fast
func set_char_speed_fast(_char_speed_fast: float) -> void:
	__char_speed_fast = _char_speed_fast
func get_char_speed_fast() -> float:
	return __char_speed_fast

var __dialogue_speed: float = 1.0:
	set = set_dialogue_speed,
	get = get_dialogue_speed
func set_dialogue_speed(_dialogue_speed) -> void:
	__dialogue_speed = _dialogue_speed
func get_dialogue_speed() -> float:
	return __dialogue_speed

var __auto_advance_dialogue: bool = false:
	set = set_auto_advance_dialogue,
	get = get_auto_advance_dialogue
func set_auto_advance_dialogue(_auto_advance_dialogue: bool) -> void:
	__auto_advance_dialogue = _auto_advance_dialogue
func get_auto_advance_dialogue() -> bool:
	return __auto_advance_dialogue

var __reading_dialogue: bool = false
func is_reading_dialogue():
	return __reading_dialogue

###############################
#           EXTERNAL          #
###############################
func pause() -> void:
	if __char_timer:
		__char_timer.set_pause(true)
	if __dialogue_timer:
		__dialogue_timer.set_pause(true)

func unpause() -> void:
	if __char_timer:
		__char_timer.set_pause(false)
	if __dialogue_timer:
		__dialogue_timer.set_pause(false)

func switch_to_fast_char_speed() -> void:
	if __char_timer:
		__char_timer.set_wait_time(__char_speed_fast)

func switch_to_normal_char_speed() -> void:
	if __char_timer:
		__char_timer.set_wait_time(__char_speed_normal)

func complete_dialogue_now() -> void:
	if __dialogue_timer and !__dialogue_timer.is_stopped():
		return # If the end dialogue timer is running, don't interrupt it. Just let it expire naturally.
	
	if __char_timer:
		__char_timer.stop()
	if __dialogue_timer:
		__dialogue_timer.stop()
	
	var _remaining_chars = __text_stack[__dialogue_ptr]["text"].substr(
		__char_ptr,
		__text_stack[__dialogue_ptr]["text"].length() - __char_ptr
	)
	emit_signal("char_complete", _remaining_chars)
	if __dialogue_timer:
		__dialogue_timer.start()

func go_to_next_dialogue_now() -> void:
	if __char_timer:
		__char_timer.stop()
	if __dialogue_timer:
		__dialogue_timer.stop()
		
	__dialogue_timeout()

func push_dialogue_to_stack(_id, _text):
	var _dialogue: Dictionary = {
		"id": _id,
		"text": _text
	}
	__text_stack.push_back(_dialogue)

func read_dialogue_stack():
	emit_signal("stack_start")
	__reading_dialogue = true
	__char_timer.start()
