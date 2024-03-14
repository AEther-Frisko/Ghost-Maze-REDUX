extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const BASE_TEXT = "[Space] to "

var activeAreas = []
var canInteract = true

func registerArea(area: InteractionArea):
	# adds area to active areas array
	activeAreas.push_back(area)
	
func unregisterArea(area: InteractionArea):
	# removes area from active areas array
	var index = activeAreas.find(area)
	if index != -1:
		activeAreas.remove_at(index)

func _process(_delta):
	# checks areas within range by distance and selects closest one to player
	if activeAreas.size() > 0 and canInteract:
		activeAreas.sort_custom(_sortByDistanceToPlayer)
		label.text = BASE_TEXT + activeAreas[0].actionName
		label.show()
	else:
		label.hide()

func _sortByDistanceToPlayer(area1, area2):
	# sorts all active areas by distance from player
	var area1toPlayer = player.global_position.distance_to(area1.global_position)
	var area2toPlayer = player.global_position.distance_to(area2.global_position)
	return area1toPlayer < area2toPlayer

func _input(event):
	# checks for player interaction attempt and allows interaction to occur if possible
	if event.is_action_pressed("interact") and canInteract:
		if activeAreas.size() > 0:
			canInteract = false
			label.hide()
			
			await activeAreas[0].interact.call()
			
			canInteract = true
