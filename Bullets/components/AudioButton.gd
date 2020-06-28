extends TextureButton

onready var audiostreamplayer = $AudioStreamPlayer
export(String, FILE, "*.wav") var wav

var audio 

func _ready():
	if wav != null:
		audio = load(wav)

func is_hit(position):
	var b = position
	var s = self.rect_global_position
	var ss = self.rect_size
	return b.x >= s.x and b.x <= s.x + ss.x and b.y >= s.y and b.y <= s.y + ss.y
	
# we need this to react to touch events!
func _input(event):
	if event is InputEventScreenTouch:
		var b = event.position
		if event.pressed:
			if is_hit(b): 
				get_tree().set_input_as_handled()
				_pressed()
		else:
			if is_hit(b): 
				get_tree().set_input_as_handled()

func _pressed(remotely=false):
	print('playing ', wav)
	if audio != null:
		if audiostreamplayer.is_playing():
			audiostreamplayer.stop()
		else:
			audiostreamplayer.stream = audio
			audiostreamplayer.play()
	if not remotely:
		EventManager.sendEvent('click', get_path())
	

