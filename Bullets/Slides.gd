tool
extends Node
"""
Container for presentation Slide nodes.
Controls the currently displayed Slide.
"""

const animation_speed_in: = 0.4
const animation_speed_out: = 50

enum Directions {PREVIOUS = -1, CURRENT = 0, NEXT = 1}

export var skip_animation: = false
export var slide_number_start := 1

onready var laserpointer = $LaserPointer
onready var touchcontrols = $"../TouchControls"
onready var swipedetector = $"../SwipeDetector"

var index_active: = 0 setget set_index_active

var slide_current
var slide_nodes = []


func _ready() -> void:
	laserpointer.hide()
	for slide in get_children():
		if not slide is Slide:
			continue
		if slide is AnimatedSprite:
			continue
		slide.hide()
		slide_nodes.append(slide)
	
	if Engine.editor_hint:
		set_process_unhandled_input(false)
	else:
		for slide in slide_nodes:
			remove_child(slide)
	
	# connect
	swipedetector.connect("silly_tap_release", touchcontrols, "flash_controls")


func _get_configuration_warning() -> String:
	return "%s needs Slide nodes as its children to work" % name if not slide_nodes else ""

var click_direction = 0

var presstime = 0
			
func _unhandled_input(event: InputEvent) -> void:
	var valid_event: bool = (
		event is InputEventMouseButton 
		or event.is_action('ui_accept')
		or event.is_action('ui_right') 
		or event.is_action('ui_left') 
		or event.is_action('ui_page_down')
		or event.is_action('ui_page_up')
		or event.is_action('quit')
		or event.is_action('to_png')
		or event.is_action('go_home')
		or event.is_action('toggle_laserpointer')
	)
	print('SLIDES >>> ', event)
	if not valid_event:
		return

	if event.is_action_pressed('ui_right') or event.is_action_pressed('ui_accept') or event.is_action_pressed('ui_page_down'):
		self.index_active += 1
	elif event.is_action_pressed('ui_left')  or event.is_action_pressed('ui_page_up'):
		self.index_active -= 1
	elif event.is_action('quit'):
		get_tree().quit()
	elif event.is_action('to_png'):
		save_as_png('.')
	elif event.is_action('go_home'):
		get_tree().change_scene("res://Bullets/Slides/bootmenu.tscn")
	elif event.is_action_pressed('toggle_laserpointer'):
		if laserpointer.is_visible():
			laserpointer.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			laserpointer.set_visible(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_LEFT:
					self.index_active += 1
				BUTTON_RIGHT:
					self.index_active -= 1


func initialize() -> void:
	if not slide_nodes:
		return
	_display(0)


func set_index_active(value : int) -> void:
	var index_previous: = index_active
	index_active = clamp(value, 0, max(slide_nodes.size() - 1, 0))
	if index_active != index_previous:
		_display(index_active)


func save_as_png(output_folder: String) -> void:
	skip_animation = true
	get_tree().paused = true
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	var id: = 0
	for slide in slide_nodes:
		# Need to wait two frames to ensure the screen capture works
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")

		var img: = get_viewport().get_texture().get_data()
		img.flip_y()
		var path: = output_folder.plus_file(str(id).pad_zeros(2) + '-' + slide.name + '.png')
		img.save_png(path)
		self.index_active += 1
		id += 1
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)
	get_tree().paused = false
	skip_animation = false


func _display(slide_index : int) -> void:
	set_process_unhandled_input(false)
	var previous_slide = slide_current
	slide_current = slide_nodes[slide_index]

	slide_current.cancel_animation()
	
	if previous_slide:
		if previous_slide.play('FadeOut', animation_speed_out, skip_animation):
			if not skip_animation:
				yield(previous_slide, "animation_finished")
		
	add_child(slide_current)
	slide_current.visible = true
	slide_current.set_slide_number(slide_index + slide_number_start)

	if slide_current.play('FadeIn', animation_speed_in, skip_animation):
		if not skip_animation:
			yield(slide_current, "animation_finished")

	if previous_slide:
		remove_child(previous_slide)
	set_process_unhandled_input(true)
