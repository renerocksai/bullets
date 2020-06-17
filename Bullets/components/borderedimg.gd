tool
extends Button

onready var trect:TextureRect = $TextureRect
export var img :Texture setget updateImg


var ready = false
var scale_x = 0
var scale_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ready = true
	self.connect("item_rect_changed", self, "sizeChanged")
	if Engine.is_editor_hint():
		if img != null:
			trect.texture = img
			sizeChanged()
	else:
		updateImg(img)	


func updateImg(new):
	img = new
	if ready: 
		if Engine.is_editor_hint():
			var bordersize = img.get_size()
			self.set_size(bordersize)
			trect.set_size(img.get_size())
			trect.texture = img
		else:
			trect.texture = img
			sizeChanged()
			



func sizeChanged():
	var mysize = self.get_size()
	trect.set_size(mysize)	
