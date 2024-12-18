extends CanvasLayer

@onready var title_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var description_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DescriptionLabel


func _ready() -> void:
	get_tree().paused = true


func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "The feesh is lost"
	play_jingle(true)


func play_jingle(defeat: bool = false) -> void:
	if defeat:
		$DefeatScreenPlayer.play()
	else:
		$VictoryScreenPlayer.play()


func _on_continue_button_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/meta_menu.tscn")


func _on_quit_button_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
