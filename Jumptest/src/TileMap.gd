extends TileMap

# Scene with 2 CollisionBox2D corner hitboxes (on Grab-able layer)
const CORNER_SCENE = preload("res://src/Corners.tscn")

func _ready():
	add_corners() # add corners on initial load
	return

# add corners to corner tiles
func add_corners():
	for cell in get_used_cells():
		if is_corner(cell):
			add_corner_node(cell)
	return

# check if a given cell is a corner piece
# @cell : the cell to check
func is_corner(cell):
	# To make reading easier, we define our coords ahead of time
	var above = Vector2(cell.x, cell.y-1)
	var left = Vector2(cell.x-1, cell.y)
	var right = Vector2(cell.x+1, cell.y)
	
	# If there is no cell above, and none to at least one side we
	# consider this a corner piece.
	if is_empty_cell(above):
		if is_empty_cell(left) or is_empty_cell(right):
			return true
	return false

# Add a corner node
# @cell : the tilemap cell to add add corners to
func add_corner_node(cell):
	var global_position = map_to_world(cell)
	var new_corner = CORNER_SCENE.instance()
	add_child(new_corner)
	new_corner.position = global_position
	return

# Check if a given cell is empty
# @cell_coords : Vector2(x,y) in regards to tilemap (x,y)
func is_empty_cell(cell_coords):
	if get_cellv(cell_coords) == -1:
		return true
	else:
		return false