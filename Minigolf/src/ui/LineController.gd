extends Node2D

enum STATE {NOT_DRAWING, DRAWING}
var state = STATE.NOT_DRAWING
var line_start = Vector2()

func _on_Ball_mouse_state_changed(mouse_state):
	if mouse_state == STATE.NOT_DRAWING:
		print("Erase line")
	elif mouse_state == STATE.DRAWING:
		line_start = get_viewport().get_mouse_position()
	state = mouse_state

func _draw():
	if state == STATE.DRAWING:
		draw_line(line_start, get_viewport().get_mouse_position(), Color(255,255,255))
#	else:
#		draw_line(Vector2(), Vector2(), Color(0, 0, 0, 1))

func _process(delta):
	if state == STATE.DRAWING:
		show()
		update()
	else:
		hide()
	#print("Drawing from ", line_start, " to ", get_viewport().get_mouse_position())