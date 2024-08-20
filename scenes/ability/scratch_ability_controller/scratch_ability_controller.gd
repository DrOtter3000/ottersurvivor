extends Node

@export var scratch_ability: PackedScene


func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var scratch_instance = scratch_ability.instantiate() as Node2D
	player.get_parent().add_child(scratch_instance)
	scratch_instance.global_position = player.global_position
