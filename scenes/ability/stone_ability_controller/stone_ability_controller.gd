extends Node

@export var base_range := 120
@export var base_damage := 20
@export var stone_scene: PackedScene


func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, base_range))
	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)		
	if !result.is_empty():
		spawn_position = result["position"]
	
	var stone_ability = stone_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(stone_ability)
	stone_ability.global_position = spawn_position
	stone_ability.hitbox_component.damage = base_damage
