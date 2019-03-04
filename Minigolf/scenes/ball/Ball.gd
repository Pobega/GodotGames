extends RigidBody2D

var impulse_start

func _unhandled_input(event):
	if event.is_action_pressed("putt"):
		print("Held at: ", event.position)
		impulse_start = event.position
	if event.is_action_released("putt"):
		print("Released at: ", event.position)
		hit_ball(impulse_start, event.position)

func hit_ball(start, end):
	apply_impulse(Vector2(), (start - end)*2)