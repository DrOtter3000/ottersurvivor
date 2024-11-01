extends Node2D


func _ready() -> void:
	rotation_degrees = randi_range(0, 360)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)


func collect():
	$RandomStreamPlayer2DComponent.play_random()
	await $RandomStreamPlayer2DComponent.finished
	GameEvents.emit_clam_collected(1)
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(collect)
