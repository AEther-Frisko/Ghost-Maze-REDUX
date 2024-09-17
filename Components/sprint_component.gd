class_name SprintComponent
extends Node

@export var move_stats: SprintMoveStats
@export var move_input: MoveInputComponent
@export var actor: CharacterBody3D
var is_sprinting: bool = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("sprint"):
		move_stats.speed = lerp(move_stats.speed, move_stats.sprint_speed, delta * move_stats.lerp_speed)
		if not move_input.input_dir.is_zero_approx():
			is_sprinting = true
		else:
			is_sprinting = false
	else:
		is_sprinting = false
		move_stats.speed = lerp(move_stats.speed, move_stats.walk_speed, delta * move_stats.lerp_speed)
