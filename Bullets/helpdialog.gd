extends WindowDialog

onready var okbutton = $OK

func _ready():
	okbutton.connect("pressed", self, 'hide')
