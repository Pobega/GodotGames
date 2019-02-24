extends AnimatedSprite

func _on_Player_jump():
	play("jump")

func _on_Player_run():
	play("run")

func _on_Player_ledgegrab():
	play("ledgegrab")

func _on_Player_death():
	play("death")
	#get_tree().reload_current_scene()
