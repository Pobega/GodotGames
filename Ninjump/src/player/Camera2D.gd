extends Camera2D

func _ready():
	limit_top = 0
	limit_left = 0
	var tilemaps = get_tree().get_nodes_in_group("tilemaps")
	print(tilemaps)
	for tilemap in tilemaps:
		if tilemap is TileMap:
			var used = tilemap.get_used_rect()
			limit_right = used.end.x * tilemap.cell_size.x
			limit_bottom = used.end.y * tilemap.cell_size.y
	return

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
