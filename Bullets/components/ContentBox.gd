tool
extends RichTextLabel

export(String, MULTILINE) var content setget updateContent


export var text_size:float = 36 setget updateTextSize
export var text_color = Color.black setget updateTextColor
export var bullet_symbol = '>' setget updateBulletSymbol
export var bullet_bold = false setget updateBulletBold
export var bullet_italic = false setget updateBulletItalic
export var bullet_color = Color("#cd0f2d") setget updateBulletColor

var regex = RegEx.new()
var ready = false

func _ready():
	regex.compile("(^|\n[ \t]*)(>|-)")
	ready = true
	updateAll()

func updateAll():
	Utils.resizeFontsFor(self, text_size)
	updateContent(text)


func updateContent(s):
	content = s
	if ready:
		bbcode_text = '[color=#{text_color}]{content}[/color]'.format({
			'text_color': text_color.to_html(),
			'content': format_content(content),
			})

func format_content(s):
	var bold = ''
	var boldoff=''
	var italic=''
	var italicoff=''
	if bullet_bold:
		bold ='[b]'
		boldoff = '[/b]'
	if bullet_italic:
		italic = '[i]'
		italicoff = '[/i]'
	s = self.regex.sub(s, '$1[color=#{color}]{bold}{italic}{symbol} {italicoff}{boldoff}[/color]'.format({
		'color': bullet_color.to_html(),
		'symbol': bullet_symbol,
		'bold': bold,
		'boldoff': boldoff,
		'italic': italic,
		'italicoff': italicoff,
		}), true)
	return s

func updateBulletSymbol(symbol):
	bullet_symbol = symbol
	updateAll()

func updateTextColor(c):
	text_color = c
	updateAll()
func updateBulletColor(c):
	bullet_color = c
	updateAll()
func updateBulletBold(f):
	bullet_bold = f
	updateAll()
func updateBulletItalic(f):
	bullet_italic = f
	updateAll()

func updateTextSize(s):
	text_size = s
	updateAll()
