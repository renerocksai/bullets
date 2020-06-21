extends Node2D

export(String, FILE, "*.tscn") var start_scene

var will_launch_from_editor = false
onready var statuslabel = $RichTextLabel3
onready var laserpointer = $LaserPointer
onready var instructions = $RichTextLabel7
var timer

var laser_active = false


func _ready():
	if Engine.is_editor_hint():
		will_launch_from_editor = true
	if OS.has_feature('JavaScript'):
		instructions.bbcode_text = instructions.bbcode_text.replace('PNG export', 'PDF download')
		print(instructions.bbcode_text)
	timer = Timer.new()
	timer.connect("timeout", self, "goto_main")
	add_child(timer)


func start():
	# statuslabel.bbcode_text = '[center][color=#cd0f2d]> > > [/color] [color=black][matrix clean=.6 dirty=.3 span=50]working on it ...[/matrix][/color][/center]'
	laserpointer.show()
	timer.set_wait_time(1)
	timer.set_one_shot(true)
	timer.start()



func _process(delta):
	if laser_active:
		laserpointer.set_position(get_local_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	var valid_event: bool = (
		event is InputEventMouseButton or event is InputEventScreenTouch
		or event.is_action('ui_accept')
		or event.is_action('ui_right')
		or event.is_action('ui_page_down')
		or event.is_action('quit')
		or event.is_action('toggle_fullscreen')
		or event.is_action('toggle_laserpointer')
		or event.is_action('to_png')
	)

	if not valid_event:
		return

	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			start()
	if event.is_action('quit'):
		get_tree().quit()
	elif event.is_action_pressed('toggle_fullscreen'):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	elif event.is_action_pressed('ui_right') or event.is_action_pressed('ui_accept') or event.is_action_pressed('ui_page_down'):
		start()
	elif event.is_action_pressed('to_png'):
		get_tree().set_input_as_handled()
	elif event.is_action_pressed('toggle_laserpointer'):
		if laser_active:
			if laserpointer.is_visible():
				laserpointer.hide()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				laserpointer.set_visible(true)
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			if laserpointer.is_visible():
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		laser_active = true



func goto_main():
	get_tree().change_scene(start_scene)

