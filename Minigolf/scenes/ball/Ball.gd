extends KinematicBody2D

export(float) var drag = 0.97

var impulse_start
var velocity = Vector2()

enum STATE {MOVING, STOPPED}
var state = STATE.STOPPED


func _unhandled_input(event):
	if state != STATE.STOPPED: return
	if event.is_action_pressed("putt"):
		impulse_start = screen_clamp(event.position)
	if event.is_action_released("putt"):
		hit_ball(impulse_start, screen_clamp(event.position))

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
	velocity = velocity*drag
	if velocity.abs() < Vector2(1, 1) and state == STATE.MOVING:
		print("stopping")
		state = STATE.STOPPED
		velocity = Vector2()

func screen_clamp(screen_position):
	var screen_size = get_viewport().get_visible_rect().size
	if screen_position.x < 0:
		screen_position.x = 0
	elif screen_position.x > screen_size.x:
		screen_position.x = screen_size.x
	if screen_position.y < 0:
		screen_position.y = 0
	elif screen_position.y > screen_size.y:
		screen_position.y = screen_size.y
	return screen_position

func hit_ball(start, end):
	print(end)
	velocity = (start - end)*2
	state = STATE.MOVING