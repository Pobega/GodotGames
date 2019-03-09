extends Node

onready var levels = []
var current_level = 0

func _ready():
	levels = _get_scenes_in_dir("res://scenes/levels/")

func _get_scenes_in_dir(directory):
	var files = []
	var res_dir = directory + "%s"
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "": break
		elif file.ends_with(".tscn") and not file.begins_with("Base"):
			var res_name = res_dir % file
			files.append(res_name)
	return files

func _on_LoadLevel_pressed():
	print(levels)
	LevelLoader.load_level(levels[current_level])
	current_level += 1