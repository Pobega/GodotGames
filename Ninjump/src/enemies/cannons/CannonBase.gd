extends StaticBody2D

export(int, -1, 1) var vertical = 0
export(int, -1, 1) var horizontal = 0

export(float) var wait_time = 3.0

const CANNONBALL = preload("res://src/enemies/cannons/Cannonball.tscn")

func _ready():
	$ShootTimer.set_wait_time(wait_time)
	$ShootTimer.start()

func _on_ShootTimer_timeout():
	var cannonball = CANNONBALL.instance()
	cannonball.horizontal = horizontal
	cannonball.vertical = vertical
	get_parent().add_child(cannonball)
	cannonball.position = $Position2D.global_position