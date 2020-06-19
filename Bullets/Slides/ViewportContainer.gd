extends ViewportContainer
onready var music = $Viewport/Game/Level/Music
onready var player = $Viewport/Game/Level/Player

func _ready():
	music.play()
	#$"../../../TouchControls".hide()
	$"../../../SwipeDetector".set_ignore_y(550)


func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		$"../../../SwipeDetector".reset_ignore_y()
	elif what == NOTIFICATION_ENTER_TREE:
		$"../../../SwipeDetector".set_ignore_y((550))
		if player != null:
			player.set_touch(OS.has_touchscreen_ui_hint() or $"../../../SwipeDetector".was_ever_touched())
		
		
