extends CSGBox3D

@onready var interactionArea: InteractionArea = $InteractionArea

func _ready():
	interactionArea.interact = Callable(self, "_onInteract")

func _onInteract():
	position.y += 0.5
