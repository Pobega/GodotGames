extends KinematicBody2D

const GRAVITY = 10
const SPEED = 40
const FLOOR = Vector2(0,-2)

var velocity = Vector2()

var direction = 1
var dead = false

func _ready():
	$AnimatedSprite.play()
	pass

func _physics_process(delta):
	velocity.y += GRAVITY
	velocity.x = 40 * direction
	if dead:
		velocity = Vector2()
	move_and_slide(velocity, FLOOR)
	handle_collision(get_slide_count())
	pass

func handle_collision(collision_count):
	if is_on_wall() or not $RayCast2D.is_colliding():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h

func kill():
	velocity = Vector2()
	$CollisionShape2D.set_disabled(true)
	dead = true
	$AnimatedSprite.play("die")


func _on_AnimatedSprite_animation_finished():
	if dead:
		queue_free()