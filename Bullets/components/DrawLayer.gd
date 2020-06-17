extends Node2D

var should_draw_circle = true
var circle_position = Vector2.ZERO
var positions = []
export var thickness = 10

func _ready():
	update()
	
func draw(position):
	positions.append(position)
	update()

func clear():
	positions = []
	update()

func _draw() -> void:
	var last_pos = Vector2.ZERO
	for position in positions:
		if last_pos == Vector2.ZERO:
			draw_circle(position, thickness/2, Color("#A0FF0000"))
		else:
			if position != Vector2.ZERO:
				draw_line(last_pos, position, Color('#A0FF0000'), thickness, true)
		last_pos = position
