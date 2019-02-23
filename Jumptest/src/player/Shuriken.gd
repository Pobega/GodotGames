extends Area2D

export(int) var speed = 200
var velocity = Vector2()


func _physics_process(delta):
	velocity.x = speed * delta
	translate(velocity)
	return


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	return

func stick_to_wall():
	speed = 0
	$AnimatedSprite.stop()
	$AnimatedSprite/AnimationPlayer.play("blink_out")
	yield($AnimatedSprite/AnimationPlayer, "animation_finished")
	return

func _on_Shuriken_body_entered(body):
	var groups = body.get_groups()
	for group in groups:
		if group == "tilemaps":
			stick_to_wall()
			return
			
		# TODO: group == enemies?
	queue_free()

	return

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	pass # replace with function body
