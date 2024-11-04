extends AudioStreamPlayer

@export var streams: Array[AudioStream]
@export var randomized_pitch := true
@export var pitch_min := .9
@export var pitch_max := 1.1


func play_random():
	if streams == null || streams.size() == 0:
		return
		
	if randomized_pitch:
		pitch_scale = randf_range(pitch_min, pitch_max)
	
	stream = streams.pick_random()
	
	play()
