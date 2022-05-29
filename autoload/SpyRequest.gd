extends Node

#########
# SETUP: 
#########
# - None required. This is just a globally accessible script from which to make generic requests.
#########

signal freeze_frame_start
signal freeze_frame_end
func request_freeze_frame(_ms):
	emit_signal("freeze_frame_start", _ms)
func complete_freeze_frame():
	emit_signal("freeze_frame_end")

signal screen_shake_start
signal screen_shake_end
func request_screen_shake(_ms, _force):
	emit_signal("screen_shake_start", _ms, _force)
func complete_screen_shake():
	emit_signal("screen_shake_end")