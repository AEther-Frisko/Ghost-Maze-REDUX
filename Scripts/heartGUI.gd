extends Panel

@onready var sprite = $Sprite2D

func updateHeart(whole :bool):
	if whole:
		sprite.frame = 0
	else:
		sprite.frame = 2
