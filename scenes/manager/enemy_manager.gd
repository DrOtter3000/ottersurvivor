extends Node

const SPAWN_RADIUS = 400

@export var duck_scene: PackedScene
@export var crab_scene: PackedScene
@export var rat_scene: PackedScene
@export var fox_scene: PackedScene
@export var crocodile_scene: PackedScene
@export var gull_scene: PackedScene
@export var arena_time_manager: Node
@onready var timer: Timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()
var number_to_spawn = 0


func _ready() -> void:
	enemy_table.add_item(duck_scene, 10)
	base_spawn_time = timer.wait_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = 0
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)		

		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position

func _on_timer_timeout() -> void:
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	for i in (number_to_spawn + 1):
		if GameEvents.enemies_on_field > GameEvents.max_enemies:
			continue
		
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D
		
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(enemy)
		enemy.global_position = get_spawn_position()
		GameEvents.enemies_on_field += 1


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1 / 12) * arena_difficulty
	time_off = min(time_off, .7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 27:
		enemy_table.add_item(rat_scene, 15)
	elif arena_difficulty == 59:
		enemy_table.add_item(crab_scene, 20)
	elif arena_difficulty == 87:
		enemy_table.add_item(gull_scene, 15)
	elif arena_difficulty == 119:
		enemy_table.add_item(fox_scene, 20)
	elif arena_difficulty == 150:
		enemy_table.add_item(crocodile_scene, 15)
		
		
	if (arena_difficulty % 30) == 0:
		number_to_spawn += 1
