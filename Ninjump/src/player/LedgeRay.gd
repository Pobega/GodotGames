extends RayCast2D

var original_vector

func _ready():
	original_vector = get_cast_to()

func _process(delta):
	var player = get_parent()
	if player.velocity.y == player.maxfallspeed:
		set_cast_to(Vector2(original_vector.x, original_vector.y*4))
	else:
		set_cast_to(original_vector)
	pass
