extends Control


signal slide_change_requested(direction)

onready var button_left: Button = $TouchButtonLeft

enum Directions {PREVIOUS = -1, NEXT = 1}


func _ready() -> void:
	for child in get_children():
		child.connect("touched", self, "_on_touch_button_touched")


func _on_touch_button_touched(button) -> void:
	var event: = InputEventAction.new()
	event.pressed = true
	event.action = 'ui_left' if button == button_left else 'ui_right'
	print(event.action)
	Input.parse_input_event(event)
