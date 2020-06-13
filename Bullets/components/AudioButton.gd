extends TextureButton

onready var audiostreamplayer = $AudioStreamPlayer
export(String, FILE, "*.wav") var wav

var audio 

func _ready():
	if wav != null:
		audio = load(wav)

# we need this or else Slides.gd will steal our mouse events!
func _input(event):
	if event is InputEventMouseButton:
		var b = event.position
		var s = self.rect_global_position
		if event.pressed:
			match event.button_index:
				BUTTON_LEFT:
					# we cannot rely on is_hovered on the web!!!
					# --> so we perform a hit test manually
					#     otherwise, Slides.gd will mess with us
					if b.x >= s.x and b.x <= s.x + self.rect_size.x and b.y >= s.y and b.y <= s.y + self.rect_size.y: 
						get_tree().set_input_as_handled()
						pressed()
		else:
			if b.x >= s.x and b.x <= s.x + self.rect_size.x and b.y >= s.y and b.y <= s.y + self.rect_size.y: 
				get_tree().set_input_as_handled()
	
func pressed():
	if audio != null:
		if audiostreamplayer.is_playing():
			audiostreamplayer.stop()
		else:
			audiostreamplayer.stream = audio
			audiostreamplayer.play()

