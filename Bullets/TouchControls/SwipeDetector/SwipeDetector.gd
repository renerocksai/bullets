extends Node
"""
Detects swipe gestures and generates InputEventSwipe events
that are fed back into the engine.
"""


signal swipe_canceled(start_position)

export(float, 1.0, 1.5) var max_diagonal_slope: = 1.3

onready var timer: Timer = $SwipeTimeout
var swipe_start_position: = Vector2()
var ignore_y = 1080

func reset_ignore_y():
	ignore_y = 1080
	
func set_ignore_y(y):
	ignore_y = y
	
func _input(event: InputEvent) -> void:
	print('>>> SWIPE ', ignore_y)
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		if event.position.y < ignore_y and (event.position.x < 350 or event.position.x > 1920 - 350):
			var newEvent: = InputEventAction.new()
			newEvent.pressed = true
			newEvent.action = 'ui_left' if event.position.x < 350 else 'ui_right'
			Input.parse_input_event(newEvent)

			
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)


func _start_detection(position: Vector2) -> void:
	swipe_start_position = position
	timer.start()


func _end_detection(position: Vector2) -> void:
	timer.stop()
	var direction: Vector2 = (position - swipe_start_position).normalized()
	# sensitiivity:
	var movement = position - swipe_start_position
	if abs(movement.x) < 50:
		return
	# Swipe angle is too steep
	if abs(direction.x) + abs(direction.y) >= max_diagonal_slope:
		return

	var event: = InputEventAction.new()
	event.pressed = true
	event.action = 'ui_left' if direction.x > 0 else 'ui_right'
	print(event.action)
	Input.parse_input_event(event)


func _on_Timer_timeout() -> void:
	emit_signal('swipe_canceled', swipe_start_position)
