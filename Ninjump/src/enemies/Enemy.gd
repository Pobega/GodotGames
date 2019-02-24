extends KinematicBody2D

const GRAVITY = 10
const SPEED = 40
const FLOOR = Vector2(0,-2)

var velocity = Vector2()

var direction = 1

func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY
	velocity.x = 40 * direction
	move_and_slide(velocity, FLOOR)
	handle_collision(get_slide_count())
	pass

func handle_collision(collision_count):
	if collision_count > 0:
		for i in range(collision_count):
			var entity = get_slide_collision(i).collider
			for group in entity.get_groups():
				if group == "player":
					entity.die()
	if is_on_wall() or not $RayCast2D.is_colliding():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h

func kill():
	queue_free()