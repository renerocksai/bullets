extends WindowDialog

onready var okbutton = $OK
onready var cancelbutton = $Cancel 
onready var slidenumEdit = $LineEdit

signal change_slide(slidenum)

func _ready():
	cancelbutton.connect("pressed", self, "hide")
	okbutton.connect("pressed", self, "onOK")

func onOK():
	if slidenumEdit.text.is_valid_integer():
		emit_signal("change_slide", slidenumEdit.text.to_int())
		self.hide()
