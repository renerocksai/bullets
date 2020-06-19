tool
extends Slide

onready var trect:TextureRect = $TextureRect
export var img :Texture setget updateImg


var ready = false
var scale_x = 0
var scale_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ready = true
	if Engine.is_editor_hint():
		if img != null:
			trect.texture = img
	else:
		updateImg(img)


func updateImg(new):
	img = new
	if ready:
		trect.texture = img



