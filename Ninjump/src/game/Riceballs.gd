extends Node2D

signal collect

func _on_Riceball_collect(identity):
	print("Riceballs.gd: Collecting %s" % identity)
	emit_signal("collect", identity)