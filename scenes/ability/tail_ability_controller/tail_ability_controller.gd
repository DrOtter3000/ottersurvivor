extends Node


@export var tail_ability_scene: PackedScene

var damage = 10


func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var tailinstance = tail_ability_scene.instantiate() as Node2D
	foreground.add_child(tailinstance)
	tailinstance.global_position = player.global_position
	tailinstance.hitbox_component.damage = damage
