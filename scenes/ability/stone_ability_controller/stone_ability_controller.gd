extends Node

@export var base_range := 120
@export var base_damage := 20
@export var stone_scene: PackedScene

var stone_count := 0


func _ready() -> void:
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_roatation_degrees = 360.0 / (stone_count + 1)

	for i in stone_count + 1:
		var wait_time = randf_range(.1, .33)
		await get_tree().create_timer(wait_time).timeout

		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_roatation_degrees))
		var spawn_position = player.global_position + (adjusted_direction * randf_range(0, base_range))
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)		
		if !result.is_empty():
			spawn_position = result["position"]
		
		var stone_ability = stone_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(stone_ability)
		stone_ability.global_position = spawn_position
		stone_ability.hitbox_component.damage = base_damage


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "stone_count":
		stone_count = current_upgrades["stone_count"]["quantity"]
	
