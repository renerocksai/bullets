extends WindowDialog

onready var serverEdit = $LineEdit
onready var roomEdit = $Room
onready var btOK = $OK
onready var btCancel = $Cancel

signal join_server(server_string, room)
signal canceled

func _ready():
	btOK.connect("pressed", self, "_ok_pressed")
	btCancel.connect("pressed", self, "_cancel_pressed")

func _ok_pressed():
	emit_signal("join_server", serverEdit.text, roomEdit.text)
	self.hide()

func _cancel_pressed():
	emit_signal("canceled")
