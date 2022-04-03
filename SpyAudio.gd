extends AudioStreamPlayer
class_name SpyAudio

const FADE_OUT_LIMIT: float = -30.0
var fade_in: bool = false
var fade_out: bool = false
var time_to_fade: float = 1.0
var delta_agg: float = 0.0
var fade_vol_diff: float = 0.0
var base_volume: float = 0.0

func _ready():
	base_volume = volume_db
	fade_vol_diff = abs(FADE_OUT_LIMIT - base_volume)

func ScaleVolumeBasedOnVariable(variable, maxIV, minIV, maxOV, minOV):
	var abs_var = min(variable, maxIV)
	volume_db = base_volume + ((abs_var - minIV) / (maxIV - minIV)) * (maxOV - minOV)

func RandomisePitch(minP, maxP):
	pitch_scale = rand_range(minP, maxP)

func FadeInOverTime(_time):
	fade_in = true
	fade_out = false
	time_to_fade = _time
	volume_db = FADE_OUT_LIMIT
	delta_agg = 0.0
	play()

func FadeOutOverTime(_time):
	fade_in = false
	fade_out = true
	time_to_fade = _time
	volume_db = base_volume
	delta_agg = 0.0
	play()

func _process(delta):
	if fade_in:
		delta_agg += delta
		volume_db = FADE_OUT_LIMIT + ((delta_agg / time_to_fade) * fade_vol_diff)
		if volume_db >= base_volume:
			volume_db = base_volume
			fade_in = false
	elif fade_out:
		delta_agg += delta
		volume_db = base_volume - ((delta_agg / time_to_fade) * fade_vol_diff)
		if volume_db <= FADE_OUT_LIMIT:
			volume_db = FADE_OUT_LIMIT
			fade_out = false
			stop()
