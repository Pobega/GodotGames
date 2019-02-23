extends Area2D

signal collect

export(int) var identity = 1

func _on_Riceball_body_entered(body):
	emit_signal("collect", identity)

func _on_Collect_finished():
	queue_free()