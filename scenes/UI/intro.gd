extends Control


# Called when the node enters the scene tree for the first time.
func start_game() -> void:
	MusicPlayer.play()
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")


func change_title() -> void:
	$AudioStreamPlayer.stream = load("res://assets/audio/AC_Cute_Chirpy_05.wav")
