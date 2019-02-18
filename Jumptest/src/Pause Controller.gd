extends Control

func _ready():
	hide()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().is_paused()
		if get_tree().is_paused():
			show()
		else:
			hide()
	if Input.is_action_just_pressed("quit") and get_tree().is_paused():
		if OS.get_name() != "HTML5":
			get_tree().quit()
	pass