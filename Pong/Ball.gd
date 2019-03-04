extends KinematicBody2D

signal destroyed

export(int) var speed = 200
export(float) var speed_step = 1.1

const MAX_SPEED = 2500

var velocity = Vector2()


func _ready():
	connect("destroyed", get_parent(), "_on_Ball_destroyed")
	$Timer.start()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)

func handle_collision(collision):
	velocity = velocity.bounce(collision.normal)
	if "Player" in collision.collider.get_name():
		bounce_off_paddle(collision.collider)
		speed_up()

func rotate_direction(dir, rad):
	return velocity.rotated(sign(velocity.x) * sign(dir) * rad).y

func speed_up():
	velocity.x *= speed_step
	if abs(velocity.x) > MAX_SPEED:
		velocity.x = MAX_SPEED * sign(velocity.x)

func bounce_off_paddle(collider):
	positional_bounce(collider)
	velocity_bounce(collider)

func positional_bounce(collider):
	var contact_point = collider.position.y - position.y
	if abs(contact_point) < 10:
		return
	elif abs(contact_point) < 30:
		velocity.y = rotate_direction(contact_point * -1, 0.4)
	else:
		velocity.y = rotate_direction(contact_point * -1, 0.7)

func velocity_bounce(collider):
	if collider.get("velocity"):
		velocity.y = rotate_direction(collider.velocity.y,  0.2)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("destroyed")
	queue_free()

func _on_Timer_timeout():
	velocity = Vector2(-speed, 0)
#	randomize()
#	if randi() % 2:
#		velocity = Vector2(speed, 0)
#	else:
#		velocity = Vector2(-speed, 0)
#	velocity.y = velocity.rotated(deg2rad(randi() % 180 - 90)).y