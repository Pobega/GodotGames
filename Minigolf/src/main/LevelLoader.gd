extends Node

onready var scene_root = get_tree().get_root()

func load_level(level):
	_unload_levels()
	print(level)
	var level_node = load(level).instance()
	print("Loading Level: ", level_node.get_name())
	scene_root.add_child(level_node)

func _unload_levels():
	for node in scene_root.get_children():
		if "level" in node.get_groups():
			print("Unloading Level: ", node.get_name())
			node.free()