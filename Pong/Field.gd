extends Line2D

signal p1_score
signal p2_score


func _on_RightGoal_body_entered(body):
	if "Ball" in body.get_name():
		emit_signal("p1_score")

func _on_LeftGoal_body_entered(body):
	if "Ball" in body.get_name():
		emit_signal("p2_score")