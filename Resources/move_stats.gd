class_name MoveStats
extends Resource

@export var speed : float
@export var position: Vector3

var lerp_speed = 10.0

signal force_pos(new_position, new_rotation)
