extends Node

const MAX_RANGE = 150

@export var scratch_ability: PackedScene

var damage = 5

func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	

	var scratch_instance = scratch_ability.instantiate() as ScratchAbility
	player.get_parent().add_child(scratch_instance)
	scratch_instance.hitbox_component.damage = damage
	
	scratch_instance.global_position = enemies[0].global_position
