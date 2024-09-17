class_name MoveInputComponent
extends Node

@export var move_component: MoveComponent
@export var move_stats: MoveStats

var direction: Vector3 = Vector3.ZERO
var input_dir: Vector2 = Vector2.ZERO
var is_moving: bool = false

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	# Get the input direction and handle the movement/deceleration
	direction = lerp(direction,(move_component.actor.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * move_stats.lerp_speed)
	if not direction.is_zero_approx():
		if not input_dir.is_zero_approx():
			is_moving = true
		else:
			is_moving = false
		move_component.velocity.x = direction.x * move_stats.speed
		move_component.velocity.z = direction.z * move_stats.speed
	else:
		move_component.velocity.x = move_toward(move_component.velocity.x, 0, move_stats.speed)
		move_component.velocity.z = move_toward(move_component.velocity.z, 0, move_stats.speed)
