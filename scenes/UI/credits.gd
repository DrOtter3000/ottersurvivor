extends CanvasLayer

@onready var credits: Control = $Credits


func _process(delta: float) -> void:
	credits.position.y -= 25 * delta


func quit():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")


func _on_back_button_pressed() -> void:
	quit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	quit()
