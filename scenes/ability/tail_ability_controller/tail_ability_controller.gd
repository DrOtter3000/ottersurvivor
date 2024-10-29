extends Node


@export var tail_ability_scene: PackedScene

var base_damage := 10
var additional_damage_percent := 1.0


func _ready() -> void:
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)



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
	tailinstance.hitbox_component.damage = base_damage * additional_damage_percent


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "tail_damage":
		additional_damage_percent = 1 + (current_upgrades["tail_damage"]["quantity"] * .1)
