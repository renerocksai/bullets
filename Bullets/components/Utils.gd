extends Reference
class_name Utils

static func resizeFontsFor(control:Control, size:float) -> void:
	if control == null:
		return
	resizeFontFor(control, size, 'normal_font')
	resizeFontFor(control, size, 'bold_font')
	resizeFontFor(control, size, 'italic_font')
	resizeFontFor(control, size, 'bold_italic_font')


static func resizeFontFor(control:Control, size:float, whichfont:String) -> void:
	var font:Font = control.get_font(whichfont, '')
	if font is DynamicFont:
		font.size = size
		control.add_font_override(whichfont, font)

static func Img2Base64(img: Image) -> String:
	var buffer: PoolByteArray = img.save_png_to_buffer()
	# data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOIAAAA9CAIAAAA/GiJ6A...
	var data_url = "data:image/png;base64,%s" % Marshalls.raw_to_base64(buffer)
	return data_url

static func Img2Js(img: Image) -> String:
	var buffer: PoolByteArray = img.get_data()
	if img.get_format() != Image.FORMAT_RGBA8:
		print("Image format not valid: " + str(img.get_format()))
		return ''
	return Marshalls.raw_to_base64(img.get_data())	
