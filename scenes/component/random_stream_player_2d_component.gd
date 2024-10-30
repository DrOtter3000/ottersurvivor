extends AudioStreamPlayer2D


@export var streams: Array[AudioStream]
@export var randomized_pitch := true

func play_random():
	if streams == null || streams.size() == 0:
		return
		
	if randomized_pitch:
		pitch_scale = randf_range(.9, 1.1)
	
	stream = streams.pick_random()
	
	play()
