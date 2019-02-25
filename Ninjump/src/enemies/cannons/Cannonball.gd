extends Area2D

export(int, -1, 1) var vertical = 0
export(int, -1, 1) var horizontal = 0

export(int) var speed = 2

var velocity = Vector2()

func _physics_process(delta):
	velocity.x = speed * horizontal
	velocity.y = speed * vertical
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Cannonball_body_entered(body):
	var groups = body.get_groups()
	for group in groups:
		if group == "player":
			body.die()
		if group == "tilemaps":
			queue_free()