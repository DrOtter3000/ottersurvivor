extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var base_rotation = Vector2.RIGHT


func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 2)
	tween.tween_callback(queue_free)

func tween_method(rotations: float):
	var current_radius = (rotations/2) * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var root_position = Vector2.ZERO
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	root_position = player.global_position
	
	global_position = root_position + (current_direction * current_radius)