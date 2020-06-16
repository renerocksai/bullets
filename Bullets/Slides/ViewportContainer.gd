extends ViewportContainer
onready var music = $Viewport/Game/Level/Music

func _ready():
	music.play()
	#$"../../../TouchControls".hide()
	$"../../../SwipeDetector".set_ignore_y(550)

func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		$"../../../SwipeDetector".reset_ignore_y()
	elif what == NOTIFICATION_ENTER_TREE:
		$"../../../SwipeDetector".set_ignore_y((550))
		
		
