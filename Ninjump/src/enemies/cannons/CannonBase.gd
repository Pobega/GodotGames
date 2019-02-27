extends StaticBody2D

export(int, -1, 1) var vertical = 0
export(int, -1, 1) var horizontal = 0

export(float) var wait_time = 2.0
export(float) var first_shot_time = 1.0

const CANNONBALL = preload("res://src/enemies/cannons/Cannonball.tscn")

func _ready():
	$FirstShotTimer.set_wait_time(first_shot_time)
	$FirstShotTimer.start()
	
func _on_FirstShotTImer_timeout():
	$ShootTimer.set_wait_time(wait_time)
	$ShootTimer.start()
	shoot_cannonball()
	
func _on_ShootTimer_timeout():
	shoot_cannonball()
	
func shoot_cannonball():
	var cannonball = CANNONBALL.instance()
	cannonball.horizontal = horizontal
	cannonball.vertical = vertical
	get_parent().add_child(cannonball)
	cannonball.position = $Position2D.global_position