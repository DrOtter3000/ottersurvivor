extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent


func _ready() -> void:
	$HurtBoxComponent.hit.connect(_on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)


func _on_hit():
	$RandomStreamPlayer2DComponent.play_random()
