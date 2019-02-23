extends Node

func _ready():
	if OS.is_debug_build():
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -1000)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	if OS.get_name()=="HTML5":
		OS.set_window_maximized(true)