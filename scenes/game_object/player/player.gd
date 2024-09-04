extends CharacterBody2D

const MAX_SPEED = 125	
const ACCELERATION_SMOOTHING = 25

@onready var collision_area_2d: Area2D = $CollisionArea2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $CanvasLayer/MarginContainer/HealthBar
@onready var abilities: Node = $Abilities


var number_colliding_bodies = 0


func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1-exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement = Input.get_action_strength("down") - Input.get_action_strength("up")

	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()

func _on_collision_area_2d_body_entered(body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()


func _on_collision_area_2d_body_exited(body: Node2D) -> void:
	number_colliding_bodies -= 1


func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func on_health_changed():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if not ability_upgrade is Ability:
		return
	
	var ability = ability_upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())
