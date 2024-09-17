class_name PositionSetComponent
extends Marker3D

@export var actor_stats: MoveStats

func _ready() -> void:
	if actor_stats:
		actor_stats.force_pos.emit(global_position, global_rotation)
