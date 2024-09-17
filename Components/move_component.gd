class_name MoveComponent
extends Node

@export var actor: CharacterBody3D
@export var velocity: Vector3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# add gravity
	if not actor.is_on_floor():
		velocity.y -= gravity * delta
	
	actor.velocity = velocity
	actor.move_and_slide()
