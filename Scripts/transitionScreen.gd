extends CanvasLayer

@onready var colourRect = $ColorRect
@onready var animPlayer = $AnimationPlayer

signal onTransitionFinished

func _ready():
	# hides transition screen
	colourRect.visible = false

func transition():
	# showa transition screen and plays the fade in animation
	colourRect.visible = true
	animPlayer.play("fadeIn")

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "fadeIn"):
		# emits signal that animation finished and fades out
		onTransitionFinished.emit()
		animPlayer.play("fadeOut")
	if (anim_name == "fadeOut"):
		# hides transition screen
		colourRect.visible = false
