extends CanvasLayer

onready var p1_score_text = $Container/P1_Score
onready var p2_score_text = $Container/P2_Score

func _on_Pong_update_score(p1_score, p2_score):
	p1_score_text.set_text(String(p1_score))
	p2_score_text.set_text(String(p2_score))