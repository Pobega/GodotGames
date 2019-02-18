extends KinematicBody2D

export(int) var speed
export(int) var xgravity
export(int) var gravity
export(int) var jump_strength

# const for fastfalling, gravity multiplier for down vector
const FASTFALL = 2.5

# projectile scene
const SHURIKEN = preload("res://src/Shuriken.tscn")

# consts for calling do_x_movement
const MOVE_RIGHT = 1
const MOVE_LEFT = -1

var velocity = Vector2()


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
	if Input.is_action_just_pressed("ui_select"):
		do_shuriken_throw()
	return


# Read and process Right/Left/Down and Up/Jump input
func get_directional_input(delta):
	# Test X movement first, lowest proiority sprite animations
	if Input.is_action_pressed("ui_right"):
		do_x_movement(MOVE_RIGHT)
	elif Input.is_action_pressed("ui_left"):
		do_x_movement(MOVE_LEFT)
	else:
		if is_on_floor():
			if Input.is_action_pressed("ui_down"):
				do_crouch()
			elif Input.is_action_just_released("ui_down"):
				exit_crouch()
			else:
				$Sprite.play("neutral")
		velocity.x = 0 # TODO: replace with slowdown instead of outright stop?

	# Jumping has higher priority than X movement
	# We fastfall either at the apex of our jump, or when the button is let go
	# to give the jump a more "weighty" feel
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_accept"):
		if sign(velocity.y) == 1:
			velocity.y += gravity * FASTFALL
		else:
			velocity.y += gravity
		if is_on_floor():
			$Sprite.play("jump")
			velocity.y = -jump_strength
	else:
		velocity.y += gravity * FASTFALL
	return


# Do movement on the X axis
# @dir : 1 if moving right, -1 if moving left
func do_x_movement(dir):
	velocity.x = dir * speed
	if $Sprite.get_animation() != "jump" or is_on_floor():
		$Sprite.play("run")

	# Shift -1/1 to 0/2 so we can convert to bool.
	# Negate it to pass into flip_h
	$Sprite.set_flip_h(not(bool(dir+1))) # Dirty trick.

	# Flip Shuriken origin point if we are looking left
	if sign($"Shuriken Origin".position.x) == -dir:
		$"Shuriken Origin".position.x *= -1
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


func _physics_process(delta):
	# Handle input
	handle_player_input(delta)
	# Process it all
	velocity = move_and_slide(velocity, Vector2(0, -1))