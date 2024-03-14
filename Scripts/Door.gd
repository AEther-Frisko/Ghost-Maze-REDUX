extends MeshInstance3D

@onready var interactionArea: InteractionArea = $InteractionArea
@onready var doorSFX = $DoorSounds

func _ready():
	# allows for player interaction
	interactionArea.interact = Callable(self, "_onInteract")

func _onInteract():
	# play door opening sound
	doorSFX.pitch_scale = randf_range(0.8, 1.2)
	doorSFX.play()
	# switch to random new map
	var mapNumber = str(randi_range(1, 10))
	SceneSwitcher.switchScene("res://Scenes/Maps/Level" + mapNumber + ".tscn")
