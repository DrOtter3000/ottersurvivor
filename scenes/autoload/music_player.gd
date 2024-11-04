extends AudioStreamPlayer


func _ready() -> void:
	play()


func _on_finished() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	play()
