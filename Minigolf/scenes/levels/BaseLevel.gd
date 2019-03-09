extends Node

signal level_complete

func _on_Ball_score():
	emit_signal("level_complete")