extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_damaged.connect(_on_player_damaged)


func _on_player_damaged():
	pass
