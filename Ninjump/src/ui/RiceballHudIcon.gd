extends AnimatedSprite

export(int, 1, 5) var identity = 1


func _ready():
	if identity == 1:
		play("empty_top")

func _on_Score_collected(ident):
	if ident == identity:
		play("full")