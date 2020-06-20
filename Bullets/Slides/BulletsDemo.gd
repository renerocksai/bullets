extends Node2D

onready var slides: = $Slides

func _ready():
	slides.initialize()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('toggle_fullscreen'):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
