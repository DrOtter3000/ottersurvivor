extends Node

const MAX_RANGE = 150

@export var scratch_ability: PackedScene
@onready var timer: Timer = $Timer

var base_damage := 10
var additional_damage_percent := 1.0
var base_wait_time


func _ready() -> void:
	base_wait_time = timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


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
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(scratch_instance)
	scratch_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	scratch_instance.global_position = enemies[0].global_position


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "scratch_rate":
		var percent_reduction = current_upgrades["scratch_rate"]["quantity"] * .1
		timer.wait_time = base_wait_time * (1 - percent_reduction)
		timer.start()
	elif upgrade.id == "scratch_damage":
		additional_damage_percent = 1 + (current_upgrades["scratch_damage"]["quantity"] * .15)
