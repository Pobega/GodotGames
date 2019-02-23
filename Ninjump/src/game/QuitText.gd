extends Label

func _ready():
	# Hide the "Press Q to Quit" dialog on HTML5 since it isn't supported
	if OS.get_name() == "HTML5":
		hide()
	return