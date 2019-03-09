extends KinematicBody2D

signal score
signal mouse_state_changed

export(float) var min_speed = 20
export(float) var max_speed = 300
export(float) var min_line_length = 5
export(float) var max_line_length = 120

# Temporary hardcoded drag
# To be replaced with surface friction
export(float) var drag = 0.99

var impulse_start
var velocity = Vector2()

enum BALL_STATE {STOPPED, MOVING}
var ball_state = BALL_STATE.STOPPED

enum MOUSE_STATE {NOT_DRAGGING, DRAGGING}
var mouse_state

onready var sprite = get_node("Sprite")


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
	if velocity.length() < 3 and ball_state == BALL_STATE.MOVING:
		ball_state = BALL_STATE.STOPPED
		velocity = Vector2()

func _process(delta):
	if ball_state == BALL_STATE.MOVING:
		var current_speed = velocity.length()
		sprite.rotate(sign(velocity.x) * current_speed/300)

func update_mouse_state(state):
	mouse_state = state
	emit_signal("mouse_state_changed", state)

func screen_clamp(screen_position):
	var screen_size = get_viewport().get_visible_rect().size
	var clamped_position = Vector2()
	clamped_position.x = clamp(screen_position.x, 0, screen_size.x)
	clamped_position.y = clamp(screen_position.y, 0, screen_size.y)
	return clamped_position

func hit_ball(start, end):
	if ball_state != BALL_STATE.STOPPED: return
	velocity = (start-end).normalized() * ball_speed(start-end)
	ball_state = BALL_STATE.MOVING

func ball_speed(hit_vector):
	# Get the length of our drawn vector clamped to the min/maximum drawable
	var attack_vector_length = clamp(hit_vector.length(), min_line_length, max_line_length)
	# Calculate what % of the line we drew (between min and max line length)
	var attack_percentage = (attack_vector_length-min_line_length) / (max_line_length-min_line_length)
	# Figure out how much speed we need to apply (based on % of line drawn)
	var speed = ((max_speed - min_speed) * attack_percentage) + min_speed
	# Clamp speed to min and max
	return clamp(speed, min_speed, max_speed)

func _on_Flagpole_body_entered(body):
	if body == self and velocity.length()+min_speed < (max_speed-min_speed)/3:
		emit_signal("score")
		queue_free()