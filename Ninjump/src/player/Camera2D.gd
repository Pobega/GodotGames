extends Camera2D

func _ready():
	limit_top = 0
	limit_left = 0
	limit_right = 0
	limit_bottom = 0
	var tilemaps = get_tree().get_nodes_in_group("tilemaps")
	for tilemap in tilemaps:
		if tilemap is TileMap:
			var used_level_rect_px = tilemap.get_used_rect().end * tilemap.cell_size
			limit_right = max(used_level_rect_px.x, limit_right)
			limit_bottom = min(used_level_rect_px.y, limit_bottom)
	return