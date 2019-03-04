extends Node

signal update_score

onready var ball = preload("res://Ball.tscn")

var p1_score = 0
var p2_score = 0


func _ready():
	new_ball()

func new_ball():
	var new_ball = ball.instance()
	add_child(new_ball)

func _on_Ball_destroyed():
	new_ball()

func update_score():
	emit_signal("update_score", p1_score, p2_score)

func _on_p1_score():
	p1_score += 1
	update_score()

func _on_p2_score():
	p2_score += 1
	update_score()
