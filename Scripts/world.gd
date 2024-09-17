extends Node3D

@onready var map: Node = %Map
@onready var transition_screen: CanvasLayer = %TransitionScreen

@export var room_stats: RoomStats

func _ready() -> void:
	# hides mouse and locks to screen while in window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	room_stats.switch_scene.connect(switchScene)
	get_tree().paused = true
	room_stats.room_number -= 1
	deferred_switch_scene(room_stats.current_room)

func _input(event: InputEvent) -> void:
	# exit game
	if event.is_action_pressed("quit"):
		get_tree().quit()

func switchScene(scene_path) -> void:
	get_tree().paused = true
	transition_screen.transition()
	await transition_screen.onTransitionFinished
	call_deferred("deferred_switch_scene", scene_path)

func deferred_switch_scene(scene_path) -> void:
	if map.get_child_count() != 0:
		map.get_child(0).queue_free()
	var new_scene = load(scene_path)
	new_scene = new_scene.instantiate()
	map.add_child(new_scene)
	get_tree().paused = false
	room_stats.room_number += 1
	room_stats.current_room = scene_path
