extends ViewportContainer
onready var music = $Viewport/Game/Level/Music

func _ready():
	music.play()
	$"../../../TouchControls".hide()
