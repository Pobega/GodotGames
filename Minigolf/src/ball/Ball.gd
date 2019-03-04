extends KinematicBody2D

export(float) var speed = 500
export(float) var drag = 0.99

var impulse_start
var velocity = Vector2()

enum BALL_STATE {STOPPED, MOVING}
var ball_state = BALL_STATE.STOPPED

enum MOUSE_STATE {NOT_DRAGGING, DRAGGING}
var mouse_state
signal mouse_state_changed


func _unhandled_input(event):
	if event.is_action_pressed("putt"):
		update_mouse_state(MOUSE_STATE.DRAGGING)
		impulse_start = screen_clamp(event.position)
	if event.is_action_released("putt") and mouse_state == MOUSE_STATE.DRAGGING:
		update_mouse_state(MOUSE_STATE.NOT_DRAGGING)
		hit_ball(impulse_start, screen_clamp(event.position))

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
	velocity = velocity*drag
	if velocity.abs().x < 1 and velocity.abs().y < 1 and ball_state == BALL_STATE.MOVING:
		ball_state = BALL_STATE.STOPPED
		velocity = Vector2()

func update_mouse_state(state):
	mouse_state = state
	emit_signal("mouse_state_changed", state)

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
	if ball_state != BALL_STATE.STOPPED: return
	velocity = (start - end)
	velocity = velocity.normalized() * speed
	ball_state = BALL_STATE.MOVING