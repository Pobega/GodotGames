extends KinematicBody2D

signal destroyed

export(int) var speed = 200
export(int) var speed_step = 1.1

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
		print(sign(collision.collider_velocity.y)) # TODO: impart velocity based on collider speed
		velocity.x *= speed_step
		if abs(velocity.x) > MAX_SPEED:
			velocity.x = MAX_SPEED * sign(velocity.x)
		print(velocity.x)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("destroyed")
	queue_free()

func _on_Timer_timeout():
	randomize()
	velocity = Vector2(speed, randi() % 180 + 1 - 90)