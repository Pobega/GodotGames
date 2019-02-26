extends Node

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -12)
#	if OS.is_debug_build():
#		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -1000)
#		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	if OS.get_name()=="HTML5":
		OS.set_window_maximized(true)
	
	$Overlay/FadeController/Fader.play("fade_in")
	yield($Overlay/FadeController/Fader, "animation_finished")

func _on_Player_death():
	$Overlay/FadeController/Fader.play("death_fade_out")
	yield($Overlay/FadeController/Fader, "animation_finished")
	get_tree().reload_current_scene()
