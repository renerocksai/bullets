extends AnimatedSprite

var follow_mouse = true
func _ready():
	pass

func _process(delta):
	if follow_mouse:
		position = get_global_mouse_position()


