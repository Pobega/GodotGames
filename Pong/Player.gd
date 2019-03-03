extends KinematicBody2D

export(int) var speed = 500
var velocity = Vector2()

enum STATE {UP, DOWN, NEUTRAL}
var current_state = STATE.NEUTRAL


func _input(event):
	if event.is_action_pressed("1p_down"):
		velocity.y = speed
		current_state = STATE.DOWN
	elif event.is_action_pressed("1p_up"):
		velocity.y = -speed
		current_state = STATE.UP
	elif event.is_action_released("1p_down"):
		if current_state != STATE.UP:
			velocity.y = 0
	elif event.is_action_released("1p_up"):
		if current_state != STATE.DOWN:
			velocity.y = 0

func _physics_process(delta):
	move_and_collide(velocity * delta)