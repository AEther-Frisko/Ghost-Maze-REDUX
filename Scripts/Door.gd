extends MeshInstance3D

@onready var interactionArea: InteractionArea = $InteractionArea

func _ready():
	interactionArea.interact = Callable(self, "_onInteract")

func _onInteract():
	var mapNumber = str(randi_range(1, 10))
	SceneSwitcher.switchScene("res://Scenes/Maps/Level" + mapNumber + ".tscn")
