class_name VaryingPitchAudioPlayer
extends AudioStreamPlayer

@export var pitch_min = 0.8
@export var pitch_max = 1.2

@export var auto_play_with_variance: = false

func _ready() -> void:
	if auto_play_with_variance:
		play_with_variance(0.0)

func play_with_variance(from_position: float = 0.0) -> void:
	pitch_scale = randf_range(pitch_min, pitch_max)
	play(from_position)
