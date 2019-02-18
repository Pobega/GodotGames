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


func _on_Shuriken_body_entered(body):
	queue_free()
	return
