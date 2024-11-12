extends Node

const MAX_RANGE = 150

@export var stomp_ability: PackedScene
@onready var timer: Timer = $Timer

var base_damage := 5
var additional_damage_percent := 1.0
var base_wait_time
var player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	base_wait_time = timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	if player == null:
		return

	var stomp_instance = stomp_ability.instantiate() as StompAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(stomp_instance)
	stomp_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	stomp_instance.global_position = player.global_position


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "stomp_rate":
		var percent_reduction = current_upgrades["stomp_rate"]["quantity"] * .1
		timer.wait_time = base_wait_time * (1 - percent_reduction)
		timer.start()
	elif upgrade.id == "scratch_damage":
		additional_damage_percent = 1 + (current_upgrades["stomp_damage"]["quantity"] * .25)
