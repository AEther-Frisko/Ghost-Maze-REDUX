extends MeshInstance3D

@onready var interactionArea: InteractionArea = $InteractionArea
@onready var doorSFX = $DoorSounds

func _ready():
	interactionArea.interact = Callable(self, "_onInteract")

func _onInteract():
	doorSFX.pitch_scale = randf_range(0.8, 1.2)
	doorSFX.play()
	await doorSFX.finished
	var mapNumber = str(randi_range(1, 10))
	SceneSwitcher.switchScene("res://Scenes/Maps/Level" + mapNumber + ".tscn")
