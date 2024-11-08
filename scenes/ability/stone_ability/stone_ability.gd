extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.pitch_scale = randf_range(.8, 1.2)
