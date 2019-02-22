extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if OS.is_debug_build():
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -1000)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
