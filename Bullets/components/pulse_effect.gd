tool
extends RichTextEffect
class_name RichTextPulse
# Syntax: [pulse color=#00000 height=1.0 freq=2.0][/pulse]

# Define the tag name.
var bbcode = "pulse"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var color = char_fx.env.get("color", char_fx.color)
	var height = char_fx.env.get("height", 0.0)
	var width = char_fx.env.get("width", 0.0)
	var freq = char_fx.env.get("freq", 2.0)

	var sined_time = 1-(sin(char_fx.elapsed_time * freq) + 1.0) / 2.0
	var y_off = sined_time * height
	var x_off = sined_time * width
	char_fx.color = char_fx.color.linear_interpolate(color, sined_time)
	char_fx.offset = Vector2(-1 *x_off, -1 * y_off)
	return true
