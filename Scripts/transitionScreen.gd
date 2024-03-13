extends CanvasLayer

@onready var colourRect = $ColorRect
@onready var animPlayer = $AnimationPlayer

signal onTransitionFinished

func _ready():
	colourRect.visible = false
	animPlayer.animation_finished.connect(_onAnimationFinished)

func transition():
	colourRect.visible = true
	animPlayer.play("fadeIn")

func _onAnimationFinished(animName):
	if (animName == "fadeIn"):
		onTransitionFinished.emit()
		animPlayer.play("fadeOut")
	if (animName == "fadeOut"):
		colourRect.visible = false
