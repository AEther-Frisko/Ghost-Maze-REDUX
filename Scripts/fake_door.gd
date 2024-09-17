extends MeshInstance3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var label_scene = preload("res://Scenes/interaction_label.tscn")
@onready var door_sfx: VaryingPitchAudioPlayer = $DoorSFX

func _ready() -> void:
	# allows for player interaction
	interaction_area.interact = Callable(self, "on_interact")

func on_interact() -> void:
	door_sfx.play_with_variance()
	var label = label_scene.instantiate()
	add_child(label)
	
	label.label.show()
	var descriptions: Array[String] = ["It won't open.", "Locked.", "It's stuck.", "This door won't budge."]
	label.label.text = descriptions.pick_random()
	await get_tree().create_timer(1.0).timeout
	label.hide()
	label.queue_free()
