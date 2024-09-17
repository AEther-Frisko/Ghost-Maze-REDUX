extends Node

@onready var label_container: MarginContainer = $labelContainer

var input_key = InputMap.action_get_events("interact")[0].as_text().replace(" (Physical)", "")
var base_text = "[" + input_key + "] to "

var active_areas = []
var can_interact = true

@export var move_stats: MoveStats

func register_area(area: InteractionArea):
	# adds area to active areas array
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	# removes area from active areas array
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(_delta):
	# checks areas within range by distance and selects closest one to player
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(sort_by_distance_to_player)
		label_container.label.text = base_text + active_areas[0].action_name
		label_container.label.show()
	else:
		label_container.label.hide()

func sort_by_distance_to_player(area1, area2):
	# sorts all active areas by distance from player
	var area1_to_player = move_stats.position.distance_to(area1.global_position)
	var area2_to_player = move_stats.position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	# checks for player interaction attempt and allows interaction to occur if possible
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label_container.label.hide()
			await active_areas[0].interact.call()
			can_interact = true
