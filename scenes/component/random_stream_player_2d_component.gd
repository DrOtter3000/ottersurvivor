extends AudioStreamPlayer2D


@export var streams: Array[AudioStream]


func play_random():
	if streams == null || streams.size() == 0:
		return
	
	pitch_scale = randf_range(.9, 1.1)
	
	stream = streams.pick_random()
	
	play()
