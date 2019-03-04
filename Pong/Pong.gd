extends Node

signal update_score

onready var ball = preload("res://Ball.tscn")

var p1_score = 0
var p2_score = 0


func _ready():
	new_ball()

func new_ball():
	print("P2 score: %s" % p2_score)
	var new_ball = ball.instance()
	add_child(new_ball)

func _on_Ball_destroyed():
	print("Ball exited camera. Spawning new ball.")
	new_ball()

func _on_LeftGoal_body_entered(body):
	if "Ball" in body.get_name():
		print("Player 2 Goal")
		p1_score += 1

func update_score():
	emit_signal("update_score", p1_score, p2_score)

func _on_p1_score():
	print("P1 Score")
	p1_score += 1
	update_score()

func _on_p2_score():
	print("P2 score")
	p2_score += 1
	update_score()
