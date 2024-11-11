extends CanvasLayer

var options_scene = preload("res://scenes/UI/options_menu.tscn")
@onready var quit_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/QuitButton


func _ready() -> void:
	MetaProgression.upgrade_settings()
	MusicPlayer.play()


func _on_play_button_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_options_button_pressed() -> void:
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_options_closed(options_instance: Node):
	options_instance.queue_free()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_meta_button_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/UI/meta_menu.tscn")
