extends AudioStreamPlayer

# We used to use signals to play sound effects, but that caused delay in
# the HTML5 export due to a lack of threading.

func _on_Player_jump():
	#play()
	return

func _on_Player_doublejump():
	#play()
	return