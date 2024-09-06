extends CharacterBody2D

const MAX_SPEED = 75

@onready var health_component: Node = $HealthComponent
@onready var visuals: Node2D = $Visuals


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
