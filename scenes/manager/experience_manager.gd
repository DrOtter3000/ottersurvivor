extends Node

var current_experience = 0


func _ready() -> void:
	GameEvents.clam_collected.connect(on_clam_collected)


func increment_experience(number: float):
	current_experience += number
	print(current_experience)


func on_clam_collected(number: float):
	increment_experience(number)
	print("here")
