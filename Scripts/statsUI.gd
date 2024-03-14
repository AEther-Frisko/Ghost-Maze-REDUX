extends Control

@onready var roomDisplay = $roomMargin/roomDisplay
@onready var healthDisplay = $healthMargin/healthDisplay
@onready var heartGUI = preload("res://Scenes/heartGUI.tscn")

const HEALTH_BASE = "Health: "
const ROOM_BASE = "Room: "

@export var playerStats = preload("res://Resources/DefaultStats.tres")

func _ready():
	EventBus.connect("maxHealthChanged", setMaxHealth)
	EventBus.connect("currentHealthChanged", setCurrentHealth)
	EventBus.connect("roomChanged", setCurrentRoom)
	
	setCurrentRoom(playerStats.roomReached)
	setMaxHealth(playerStats.maxHealth)
	setCurrentHealth(playerStats.currentHealth)

func setMaxHealth(newMax):
	for i in range(newMax):
		var heart = heartGUI.instantiate()
		healthDisplay.add_child(heart)

func setCurrentHealth(newHealth):
	var hearts = healthDisplay.get_children()
	
	for i in range(newHealth):
		hearts[i].updateHeart(true)
	
	for i in range(newHealth, hearts.size()):
		hearts[i].updateHeart(false)

func setCurrentRoom(newRoom):
	roomDisplay.text = ROOM_BASE + str(newRoom)
