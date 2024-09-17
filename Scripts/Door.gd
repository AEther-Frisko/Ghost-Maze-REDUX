extends MeshInstance3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var door_sfx: VaryingPitchAudioPlayer = $DoorSFX

var total_maps: int = 0

@export var room_stats: RoomStats
@export var map_path: String = "res://Scenes/Maps"

func _ready() -> void:
	# allows for player interaction
	interaction_area.interact = Callable(self, "on_interact")
	total_maps = count_files_in_dir(map_path) - 1

func on_interact() -> void:
	# play door opening sound
	door_sfx.play_with_variance()
	# switch to random new map
	if not total_maps == 0:
		var map_number: String = str(randi_range(1, total_maps))
		room_stats.switch_scene.emit(map_path + "/Level_" + map_number + ".tscn")
	else:
		print("No maps were detected, cannot switch map.")

func count_files_in_dir(path) -> int:
	var count: int = 0
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.get_extension() == "tscn":
					count += 1
				file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return count
