extends Node

onready var level_one = preload("res://scenes/levels/Level1.tscn")

func _on_LoadLevel_pressed():
	var level = level_one.instance()
	load_level(level)

func load_level(level):
	_unload_levels()
	add_child(level)

func _unload_levels():
	for node in get_children():
		if "level" in node.get_groups():
			print("Removing ", node)
			remove_child(node)