extends Control

export(int, 1, 5) var identity = 1

func _ready():
	$Full.hide()

func _on_Score_collected(ident):
	if ident == identity:
		$Full.show()
	pass # replace with function body
