class_name RoomStats
extends Resource

@export var room_number: int = 0:
	set(value):
		room_number = value
		room_changed.emit()
@export var current_room: String
@export var high_score: int = 0

signal switch_scene(new_scene)
signal room_changed(new_room)
