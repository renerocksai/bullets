extends Node
class_name Utils

func resizeFontsFor(control:Control, size:int) -> void:
	resizeFontFor(control, size, 'normal_font')
	resizeFontFor(control, size, 'bold_font')
	resizeFontFor(control, size, 'italic_font')
	resizeFontFor(control, size, 'bold_italic_font')
	

func resizeFontFor(control:Control, size:int, whichfont:String) -> void:
	var font = control.get_font(whichfont, '')
	font.size = size
	control.add_font_override(whichfont, font)

