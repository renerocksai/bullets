extends AnimatedSprite

func _ready():
	pass 

func _process(delta):
	position += get_local_mouse_position()

