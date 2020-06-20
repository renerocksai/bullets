extends Node2D
class_name Slide


signal animation_finished

onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if anim_player != null:
		anim_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished")
	set_process_unhandled_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		_jump_to_animation_end()


func play(anim_name: String, speed: = 0.5, skip_animation=false) -> bool:
	if anim_player == null:
		return false
	assert(anim_player and anim_name in anim_player.get_animation_list())
	set_process_unhandled_input(true)
	anim_player.playback_speed = speed * 2
	anim_player.play(anim_name)
	if skip_animation:
		_jump_to_animation_end()
	return true


func is_playing() -> bool:
	return anim_player.is_playing()

func cancel_animation():
	if anim_player == null:
		return
	if anim_player.is_playing():
		_jump_to_animation_end()

func _jump_to_animation_end() -> void:
	if anim_player == null:
		return
	anim_player.seek(anim_player.current_animation_length, true)
	emit_signal("animation_finished")
	set_process_unhandled_input(false)

func set_slide_number(slide_number):
	pass
	
