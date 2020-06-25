extends RichTextLabel

signal timeout

onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.connect("timeout", self, "timeout")

func start():
	timer.start(0.7)
	show()


func timeout():
	emit_signal("timeout")
