extends Reference
class_name Utils

static func resizeFontsFor(control:Control, size:float) -> void:
	resizeFontFor(control, size, 'normal_font')
	resizeFontFor(control, size, 'bold_font')
	resizeFontFor(control, size, 'italic_font')
	resizeFontFor(control, size, 'bold_italic_font')


static func resizeFontFor(control:Control, size:float, whichfont:String) -> void:
	var font:Font = control.get_font(whichfont, '')
	if font is DynamicFont:
		font.size = size
		control.add_font_override(whichfont, font)

