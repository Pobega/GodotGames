extends Node

onready var ball = preload("res://Ball.tscn")

var p1_score = 0
var p2_score = 0


func _ready():
	new_ball()

func new_ball():
	var new_ball = ball.instance()
	add_child(new_ball)

func _on_Ball_destroyed():
	print("Ball exited camera. Spawning new ball.")
	new_ball()

func _on_LeftGoal_body_entered(body):
	if "Ball" in body.get_name():
		p1_score += 1

func _on_RightGoal_body_entered(body):
	if "Ball" in body.get_name():
		p2_score += 1