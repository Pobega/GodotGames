extends CanvasLayer

signal collected

func _on_Riceball_collect(identity):
	emit_signal("collected", identity)
	pass # replace with function body