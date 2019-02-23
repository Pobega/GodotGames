extends AnimatedSprite

func _on_Player_jump():
	play("jump")
	return

func _on_Player_run():
	play("run")
	return

func _on_Player_ledgegrab():
	play("ledgegrab")
	pass # replace with function body
