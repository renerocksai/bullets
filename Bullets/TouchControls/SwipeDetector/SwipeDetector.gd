extends Node
"""
Detects swipe gestures and generates InputEventSwipe events
that are fed back into the engine.
"""


signal swipe_canceled(start_position)
signal silly_tap_release(position)

export(float, 1.0, 1.5) var max_diagonal_slope: = 1.3

onready var timer: Timer = $SwipeTimeout
var swipe_start_position: = Vector2()
var ignore_y = 1080

var ever_touched = false

func was_ever_touched():
	return ever_touched
	
func reset_ignore_y():
	ignore_y = 1080
	
func set_ignore_y(y):
	ignore_y = y
	
func _input(event):
	if not event is InputEventScreenTouch:
		return
	ever_touched = true
	if event.pressed:
		if (event.position.y < ignore_y)  and (event.position.x < 350 or event.position.x > 1920 - 350):
			var newEvent: = InputEventAction.new()
			newEvent.pressed = true
			newEvent.action = 'ui_left' if event.position.x < 350 else 'ui_right'
			get_tree().set_input_as_handled()
			Input.parse_input_event(newEvent)
	
func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventScreenTouch:
		return

	if event.pressed:
		if event.position.y < ignore_y:			
			_start_detection(event.position)
	else:
		if not timer.is_stopped():
			if event.position.y < ignore_y and event.position.y > 150:
				if not _end_detection(event.position):
					emit_signal("silly_tap_release", event.position)
		elif event.position.x > 350 and event.position.x < 1920 - 350 and event.position.y > 150:
			# show the touch controls
			emit_signal("silly_tap_release", event.position)
		elif event.position.y < 150:
			var newEvent: = InputEventAction.new()
			newEvent.pressed = true
			newEvent.action = 'toggle_fullscreen'
			Input.parse_input_event(newEvent)

func _start_detection(position: Vector2) -> void:
	swipe_start_position = position
	timer.start()


func _end_detection(position: Vector2) -> bool:
	timer.stop()
	var direction: Vector2 = (position - swipe_start_position).normalized()
	# sensitiivity:
	var movement = position - swipe_start_position
	if abs(movement.x) < 50:
		return false
	# Swipe angle is too steep
	if abs(direction.x) + abs(direction.y) >= max_diagonal_slope:
		return false

	var event: = InputEventAction.new()
	event.pressed = true
	event.action = 'ui_left' if direction.x > 0 else 'ui_right'
	Input.parse_input_event(event)
	return true

func _on_Timer_timeout() -> void:
	emit_signal('swipe_canceled', swipe_start_position)
