extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10
var current_health


func _ready() -> void:
	current_health = max_health


func damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()


func heal(heal_amount: int):
	damage(-heal_amount)


func get_health_percent():
	if max_health <= 0:
		return
	return min(current_health/max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		GameEvents.enemies_on_field -= 1
		owner.queue_free()
