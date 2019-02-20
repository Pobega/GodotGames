extends TileMap

const CORNER_SCENE = preload("res://src/Corners.tscn")

func _ready():
	add_corners()
	return

func add_corners():
	for cell in get_used_cells():
		if is_corner(cell):
			add_corner_node(cell)
	return

func is_corner(cell):
	if empty(Vector2(cell.x, cell.y-1)):
		if empty(Vector2(cell.x-1, cell.y)) or empty(Vector2(cell.x+1, cell.y)):
			return true
	return

func add_corner_node(cell):
	var global_position = map_to_world(cell)
	var new_corner = CORNER_SCENE.instance()
	add_child(new_corner)
	new_corner.position = global_position
	return

func empty(cell):
	if get_cellv(cell) == -1:
		return true
	else:
		return false