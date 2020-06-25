extends Node2D

var should_draw_circle = true
var circle_position = Vector2.ZERO
var positions = []
var color = Color("#A0FF0000")
var color_2 = Color("#A00000FF")
var color_3 = Color("#A000FF00")
export var thickness = 10

var positions_2 = []
var positions_3 = []

func _ready():
	update()

func draw(position, the_positions):
	the_positions.append(position)
	update()

func clear(the_positions):
	the_positions.clear()
	update()


func draw_positions(positions, color):
	var last_pos = Vector2.ZERO
	for position in positions:
		if last_pos == Vector2.ZERO:
			draw_circle(position, thickness/2, color)
		else:
			if position != Vector2.ZERO:
				draw_line(last_pos, position, color, thickness, true)
		last_pos = position

func _draw() -> void:
	draw_positions(positions_3, color_3)
	draw_positions(positions_2, color_2)
	draw_positions(positions, color)
