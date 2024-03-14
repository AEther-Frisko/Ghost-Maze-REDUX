extends Node

var currentScene = null

@export var playerStats = preload("res://Resources/DefaultStats.tres")

func _ready():
	# gets default starting scene
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)

func switchScene(resPath):
	# pauses game and calls the scene switching function
	get_tree().paused = true
	TransitionScreen.transition()
	await TransitionScreen.onTransitionFinished
	call_deferred("_deferredSwitchScene", resPath)

func _deferredSwitchScene(resPath):
	# swithces the scene based on given scene path and then unpauses game
	currentScene.free()
	var newScene = load(resPath)
	currentScene = newScene.instantiate()
	get_tree().root.add_child(currentScene)
	get_tree().current_scene = currentScene
	get_tree().paused = false
	playerStats.roomReached += 1
	EventBus.roomChanged.emit(playerStats.roomReached)
