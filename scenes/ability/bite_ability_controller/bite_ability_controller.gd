extends Node

const MAX_RANGE = 150

@export var bite_ability: PackedScene
@onready var timer: Timer = $Timer

var base_damage := 100
var base_wait_time


func _ready() -> void:
	base_wait_time = timer.wait_time

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
	

	var bite_instance = bite_ability.instantiate() as BiteAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(bite_instance)
	bite_instance.hitbox_component.damage = base_damage
	
	bite_instance.global_position = enemies[0].global_position
