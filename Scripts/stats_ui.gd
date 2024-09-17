extends Control

@onready var roomDisplay = $roomDisplay
@onready var healthBar = $healthBar
@onready var staminaBar = $staminaBar

@export var room_stats: RoomStats
@export var stamina_stats: MeterStats
@export var health_stats: MeterStats

func _ready():
	stamina_stats.value_changed.connect(set_stamina)
	set_stamina(stamina_stats.value)
	set_max_stamina(stamina_stats.max_value)
	
	health_stats.value_changed.connect(set_health)
	set_health(health_stats.value)
	set_max_health(health_stats.max_value)
	
	room_stats.room_changed.connect(set_room_number)
	set_room_number(room_stats.room_number)

func set_max_health(new_max):
	healthBar.max_value = new_max

func set_health(new_health):
	healthBar.value = new_health

func set_max_stamina(new_max: float):
	staminaBar.max_value = new_max

func set_stamina(new_stamina: float):
	staminaBar.value = new_stamina

func set_room_number(new_room_number: int = room_stats.room_number):
	roomDisplay.text = "Room: " + str(new_room_number)
