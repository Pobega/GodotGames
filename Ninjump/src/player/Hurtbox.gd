extends CollisionShape2D

func _on_Player_death():
	set_disabled(true)
