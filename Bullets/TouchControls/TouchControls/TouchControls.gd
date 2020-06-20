extends Control


signal slide_change_requested(direction)

onready var button_left: Button = $TouchButtonLeft
onready var button_right: Button =$TouchButtonRight
onready var button_fscreen: Button = $TouchButtonFullscreen
onready var flashTimer : Timer = $FlashTimer

var flash_state = false

func _ready() -> void:
	for child in get_children():
		if child is Timer:
			child.connect("timeout", self, "flash_end")
		else:
			child.connect("touched", self, "_on_touch_button_touched")


func _on_touch_button_touched(button) -> void:
	var event: = InputEventAction.new()
	event.pressed = true
	match button:
		button_left:
			event.action = 'ui_left'
		button_right:
			event.action ='ui_right'
		button_fscreen:
			event.action = 'toggle_fullscreen'
	Input.parse_input_event(event)

func flash_controls(position):
	for child in get_children():
		if child is Timer:
			continue
		if not flash_state:
			child._on_mouse_entered()
		else:
			child._on_mouse_exited()
	flash_state = not flash_state
	flashTimer.start()

func flash_end():
	flash_state = false
	for child in get_children():
		if child is Timer:
			continue
		child._on_mouse_exited()
