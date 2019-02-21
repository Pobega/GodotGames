extends Area2D

signal collect

func _on_Riceball_body_entered(body):
	emit_signal("collect")

func _on_Collect_finished():
	queue_free()