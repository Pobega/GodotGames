extends AudioStreamPlayer

func _ready():
	play()

func _on_Player_death():
	stop()
