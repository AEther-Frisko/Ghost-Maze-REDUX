extends Node

var currentScene = null
func _ready():
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)
	#SceneSwitcher.switch_screen()

func switchScene(resPath):
	get_tree().paused = true
	TransitionScreen.transition()
	await TransitionScreen.onTransitionFinished
	call_deferred("_deferredSwitchScene", resPath)

func _deferredSwitchScene(resPath):
	currentScene.free()
	var newScene = load(resPath)
	currentScene = newScene.instantiate()
	get_tree().root.add_child(currentScene)
	get_tree().current_scene = currentScene
	get_tree().paused = false
