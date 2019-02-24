extends KinematicBody2D

signal jump
signal run
signal ledgegrab
signal doublejump
signal death

# Horizontal movement
export(int, 200) var startspeed = 30
export(int, 200) var maxspeed = 100
export(int, 200) var walljumpspeed = 70
export(float, 1.01, 10) var accel = 1.08
# Vertical movement
export(int, 100) var gravity = 10
export(int, 250) var jump_strength = 250
export(int) var maxfallspeed = 600

# const for fastfalling, gravity multiplier for down vector
const FASTFALL = 2.5

# projectile scene
const SHURIKEN = preload("res://src/player/Shuriken.tscn")

# consts for calling do_x_movement
const MOVE_RIGHT = 1
const MOVE_LEFT = -1

var velocity = Vector2()

var grabbing_ledge = false
var can_double_jump = true
var stored_x_velocity

var no_input = false

# Ensure we start with the neutral animation
func _ready():
	$Sprite.play("neutral")
	return


# Handle all Input.is_action_pressed signals for Player
func handle_player_input(delta):
	# Handle directional input and jumping first
	get_directional_input(delta)

	# After direction is handled and player sprite is flipped,
	# we check for action keys
	if Input.is_action_just_pressed("attack"):
		do_shuriken_throw()
	return


# Read and process Right/Left/Down and Up/Jump input
func get_directional_input(delta):
	stored_x_velocity = 0
	# Test for ledgegrabs first
	if $LedgeRay.is_colliding() and sign(velocity.y) == 1 and not is_on_floor() and grabbing_ledge == false:
		if not Input.is_action_pressed("crouch"):
			snap_to_corner($LedgeRay.get_collider())
			velocity.y=0
			grabbing_ledge = true
			emit_signal("ledgegrab")

	# Test X movement next, lowest proiority sprite animations
	# But we don't want to do horizontal flips if ledge grabbing
	if Input.is_action_pressed("move_right"):
		do_x_movement(MOVE_RIGHT)
	elif Input.is_action_pressed("move_left"):
		do_x_movement(MOVE_LEFT)
	else:
		if is_on_floor():
			if Input.is_action_pressed("crouch"):
				do_crouch()
			elif Input.is_action_just_released("crouch"):
				exit_crouch()
			else:
				$Sprite.play("neutral")
		velocity.x = 0 # TODO: replace with slowdown instead of outright stop?

	# Double Jump
	if Input.is_action_just_pressed("jump") and can_double_jump:
		if sign(velocity.y) == 1 or abs(velocity.y) < jump_strength/3:
			$Jump.play()
			emit_signal("doublejump")
			velocity.y = -jump_strength
			can_double_jump = false
			if grabbing_ledge:
				can_double_jump = true
	if is_on_floor() or grabbing_ledge:
		can_double_jump = true

	# Jumping has higher priority than X movement
	# We fastfall either at the apex of our jump, or when the button is let go
	# to give the jump a more "weighty" feel
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or grabbing_ledge:
			$Jump.play()
			emit_signal("jump")
			velocity.y = -jump_strength
			if grabbing_ledge:
				grabbing_ledge = false
				can_double_jump = true
				velocity.x = stored_x_velocity
				velocity.y = -(jump_strength/1.2)

	if Input.is_action_pressed("jump") and not grabbing_ledge:
		if sign(velocity.y) == 1:
			velocity.y += gravity * FASTFALL
		else:
			velocity.y += gravity


	else:
		if not grabbing_ledge:
			velocity.y += gravity * FASTFALL
	

	if Input.is_action_pressed("crouch") and grabbing_ledge:
		$Sprite.play("jump")
		velocity.y = gravity * FASTFALL * 4
		velocity.x = stored_x_velocity
		grabbing_ledge = false

	# Maximum velocity
	velocity.y = min(velocity.y, maxfallspeed)
	return


func snap_to_corner(collider):
	position.y = collider.global_position.y+5
	if $Sprite.is_flipped_h():
		position.x -= 3
	else:
		position.x += 3
	velocity = Vector2(0,0)

func facing_left():
	return $Sprite.is_flipped_h()

# Do movement on the X axis
# @dir : 1 if moving right, -1 if moving left
func do_x_movement(dir):
	if grabbing_ledge:
		stored_x_velocity = dir * walljumpspeed
		return
		
	if abs(velocity.x) < startspeed:
		velocity.x = dir * startspeed
	else:
		velocity.x = dir * min((abs(velocity.x) * accel), maxspeed)

	if is_on_floor():
		emit_signal("run")

	flip_hitboxes(dir)
	return


func flip_hitboxes(dir):
	# Shift -1/1 to 0/2 so we can convert to bool.
	# Negate it to pass into flip_h
	if not grabbing_ledge:
		$Sprite.set_flip_h(not(bool(dir+1))) # Dirty trick.
	
	if sign($Hitbox.position.x) == -dir:
		$Hitbox.position.x *= -1

	# Flip Shuriken origin point if we are looking left
	if sign($"Shuriken Origin".position.x) == -dir:
		$"Shuriken Origin".position.x *= -1
	if sign($LedgeRay.position.x) == -dir:
		$LedgeRay.position.x *= -1
		$LedgeRay.cast_to.x *= -1
	return


# Smoothly transition into crouch
func do_crouch():
	if $Sprite.get_animation() == "neutral":
		var frame = -($Sprite.get_frame()-1)
		$Sprite.play("crouch")
		$Sprite.set_frame(frame)
	else:
		$Sprite.play("crouch")


# Smoothly transition out of crouch
func exit_crouch():
	if $Sprite.get_animation() == "crouch":
		var frame = -($Sprite.get_frame()-1)
		$Sprite.play("neutral")
		$Sprite.set_frame(frame)
	else:
		$Sprite.play("neutral")


# Throw a Shuriken instance from "Shuriken Origin"
func do_shuriken_throw():
	var shuriken = SHURIKEN.instance()
	get_parent().add_child(shuriken)
	shuriken.position = $"Shuriken Origin".global_position
	if $Sprite.is_flipped_h():
		shuriken.speed = -shuriken.speed
	return

func handle_collision(collision_count):
	if collision_count > 0:
		for i in range(collision_count):
			var entity = get_slide_collision(i).collider
			for group in entity.get_groups():
				if group == "hazards" or group == "enemies":
					no_input = true
					emit_signal("death")


func _physics_process(delta):
	if not no_input:
		# Handle input
		handle_player_input(delta)
		# Process it all
		velocity = move_and_slide(velocity, Vector2(0, -1))
		handle_collision(get_slide_count())
	else:
		velocity = Vector2(0,0)
