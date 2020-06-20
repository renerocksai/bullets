tool
extends Node2D
"""
Container for presentation Slide nodes.
Controls the currently displayed Slide.
"""

const animation_speed_in: = 0.5
const animation_speed_out: = 50

export var skip_animation: = false
export var slide_number_start := 1
export var mouse_hide_timeout := 1.5

onready var laserpointer = $LaserPointer
onready var touchcontrols = $"../TouchControls"
onready var swipedetector = $"../SwipeDetector"
onready var mousehidetimer = $CursorAutoHideTimer
onready var canvas = $"../DrawLayer"

var index_active: = 0 setget set_index_active

var slide_current
var slide_nodes = []

var laserpointer_size = 1
var drawmode = false
var keep_drawing = false


func _ready() -> void:
	laserpointer.hide()
	for slide in get_children():
		if not slide is Slide:
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
	mousehidetimer.connect("timeout", self, "_on_mousehide_timeout")
	mousehidetimer.wait_time = mouse_hide_timeout
	if not Engine.editor_hint:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_mousehide_timeout():
	if not drawmode:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _get_configuration_warning() -> String:
	return "%s needs Slide nodes as its children to work" % name if not slide_nodes else ""

var click_direction = 0

var presstime = 0

func _unhandled_input(event: InputEvent) -> void:
	var valid_event: bool = (
		event is InputEventMouseButton
		or event is InputEventMouseMotion
		or event.is_action('ui_accept')
		or event.is_action('ui_right')
		or event.is_action('ui_left')
		or event.is_action('ui_page_down')
		or event.is_action('ui_page_up')
		or event.is_action('quit')
		or event.is_action('to_png')
		or event.is_action('go_home')
		or event.is_action('toggle_laserpointer')
		or event.is_action('cycle_laserpointer_sizes')
		or event.is_action('toggle_drawmode')
		or event.is_action('clear_drawing')
	)
	if not valid_event:
		return

	if event.is_action_pressed('ui_right') or event.is_action_pressed('ui_accept') or event.is_action_pressed('ui_page_down'):
		self.index_active += 1
	elif event.is_action_pressed('ui_left')  or event.is_action_pressed('ui_page_up'):
		self.index_active -= 1
	elif event.is_action('quit'):
		get_tree().quit()
	elif event.is_action_pressed('to_png'):
		save_as_png('.')
	elif event.is_action_pressed('go_home'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://Bullets/Slides/bootmenu.tscn")
	elif event.is_action_pressed('cycle_laserpointer_sizes'):
		laserpointer_size -= .25
		if laserpointer_size < .25:
			laserpointer_size = 1.0
		laserpointer.scale = Vector2(laserpointer_size, laserpointer_size)
	elif event.is_action_pressed('toggle_laserpointer'):
		if laserpointer.is_visible():
			laserpointer.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			laserpointer.set_visible(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif event.is_action_pressed('toggle_drawmode'):
		drawmode = not drawmode
		if drawmode:
			touchcontrols.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			mousehidetimer.start()
			touchcontrols.show()
	elif event.is_action_pressed("clear_drawing"):
		canvas.clear()

	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_LEFT:
					if drawmode:
						keep_drawing = true
						canvas.draw(event.position)
					else:
						self.index_active += 1
				BUTTON_RIGHT:
					self.index_active -= 1
		else:
			keep_drawing = false
			if drawmode:
				canvas.draw(Vector2.ZERO)

	# mouse pointer auto-hide
	if event is InputEventMouseMotion:
		if drawmode and keep_drawing:
			canvas.draw(event.position)
		if not Engine.editor_hint:
			mousehidetimer.start()
			if not laserpointer.is_visible():
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func initialize() -> void:
	if not slide_nodes:
		return
	_display(0)


func set_index_active(value : int) -> void:
	var index_previous: = index_active
	index_active = clamp(value, 0, max(slide_nodes.size() - 1, 0))
	if index_active != index_previous:
		_display(index_active)


func download_pdf():
	JavaScript.eval('console.log("download_pdf");')
	skip_animation = true
	get_tree().paused = true
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	for slide in slide_nodes:
		# Need to wait two frames to ensure the screen capture works
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")

		var img: = get_viewport().get_texture().get_data()
		img.flip_y()
		print(Utils.Img2Js(img))
		# JavaScript.eval('window.alert("%s)' % Utils.Img2DataUrl(img))
		self.index_active += 1
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)
	get_tree().paused = false
	skip_animation = false


func save_as_png(output_folder: String) -> void:
	if OS.has_feature('JavaScript') or true:
		alert("This feature is not available in the web version.")
		download_pdf()
		return
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
		print('format:', img.get_format())
		break
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

	if previous_slide and false:
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

func alert(text: String, title: String='Message') -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.window_title = title
	dialog.connect('modal_closed', dialog, 'queue_free')
	add_child(dialog)
	dialog.popup_centered()
