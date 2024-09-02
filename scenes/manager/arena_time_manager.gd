extends Node

@onready var timer: Timer = $Timer
@export var end_screen: PackedScene


func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


func _on_timer_timeout() -> void:
	var victory_screen_instance = end_screen.instantiate()
	add_child(victory_screen_instance)
