extends AudioStreamPlayer2D


@export var streams: Array[AudioStream]


func play_random():
	if streams == null || streams.size() == 0:
		print(streams)
		return
	
	stream = streams.pick_random()
	
	play()
