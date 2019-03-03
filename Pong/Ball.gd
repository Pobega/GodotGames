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
		velocity.y = velocity.rotated(sign(velocity.x) * sign(collision.collider.velocity.y)).y
		velocity.x *= speed_step
		if abs(velocity.x) > MAX_SPEED:
			velocity.x = MAX_SPEED * sign(velocity.x)
		print(velocity.x)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("destroyed")
	queue_free()

func _on_Timer_timeout():
	randomize()
	if randi() % 2:
		velocity = Vector2(speed, 0)
	else:
		velocity = Vector2(-speed, 0)
	velocity.y = velocity.rotated(deg2rad(randi() % 180 - 90)).y
	print(velocity)