tool
extends Slide


export var title:String setget updateTitle
export(String, MULTILINE) var textLeft setget updateLeft
export(String, MULTILINE) var textRight setget updateRight
export var sources:String setget updateSources

export var page_number: String = 'auto' setget set_slide_number
export var title_size:float = 52 setget updateTitleSize
export var title_color = Color.black setget updateTitleColor
export var text_size:float = 36 setget updateTextSize
export var text_color = Color.black setget updateTextColor
export var sources_size:float = 20 setget updateSourcesSize
export var sources_color = Color.gray setget updateSourcesColor
export var bullet_symbol = '>' setget updateBulletSymbol
export var bullet_bold = false setget updateBulletBold
export var bullet_italic = false setget updateBulletItalic
export var bullet_color = Color("#cd0f2d") setget updateBulletColor
export var pagenumber_size:float = 20 setget updatePageNumberSize
export var pagenumber_color = Color.black setget updatePageNumberColor

onready var titleLabel: = $TitleLabel
onready var content: = $ContentLabel
onready var content2: = $ContentLabel2
onready var sourceLabel: = $SourceInfoLabel
onready var pagenumLabel: = $PageNumber

var first: = true

var regex = RegEx.new()
var ready = false

func _ready():
	regex.compile("(^|\n[ \t]*)(>|-)")
	ready = true
	updateAll()

func updateAll():
	Utils.resizeFontsFor(titleLabel, title_size)
	Utils.resizeFontsFor(content, text_size)
	Utils.resizeFontsFor(content2, text_size)
	Utils.resizeFontsFor(sourceLabel, sources_size)
	Utils.resizeFontsFor(pagenumLabel, pagenumber_size)
	updateTitle(title)
	updateLeft(textLeft)
	updateRight(textRight)
	updateSources(sources)


func updateTitle(s):
	title = s
	if ready:
		titleLabel.bbcode_text = '[color=#{title_color}]{title}[/color]'.format({
			'title_color': title_color.to_html(),
			'title': title,
			})

func updateLeft(s):
	textLeft = s
	if ready:
		content.bbcode_text = '[color=#{text_color}]{text}[/color]'.format({
			'text_color': text_color.to_html(),
			'text': format_content(textLeft),
			})

func updateRight(s):
	textRight = s
	if ready:
		content2.bbcode_text = '[color=#{text_color}]{text}[/color]'.format({
			'text_color': text_color.to_html(),
			'text': format_content(textRight),
			})

func updateSources(s):
	sources = s
	if ready:
		if len(sources) > 0:
			sourceLabel.bbcode_text = '[color=gray]$x[/color]'.replace('$x', sources)
			sourceLabel.bbcode_text = '[color=#{sources_color}]{sources}[/color]'.format({
				'sources_color': sources_color.to_html(),
				'sources': sources,
				})
		else:
			sourceLabel.bbcode_text = ''

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

func set_slide_number(n):
	if Engine.editor_hint or first:
		page_number = str(n)
		first = false
	if 'auto' in page_number and pagenumLabel != null:
		pagenumLabel.bbcode_text = '[color=#{pagenumber_color}]{n}[/color]'.format({
			'pagenumber_color': pagenumber_color.to_html(),
			'n': n,
			})
	else:
		if pagenumLabel != null:
			pagenumLabel.bbcode_text = '[color=#{pagenumber_color}]{n}[/color]'.format({
				'pagenumber_color': pagenumber_color.to_html(),
				'n': page_number,
				})


func updateBulletSymbol(symbol):
	bullet_symbol = symbol
	updateAll()

func updateTitleColor(c):
	title_color = c
	updateAll()
func updateTextColor(c):
	text_color = c
	updateAll()
func updateSourcesColor(c):
	sources_color = c
	updateAll()
func updatePageNumberColor(c):
	pagenumber_color = c

func updateBulletColor(c):
	bullet_color = c
	updateAll()
func updateBulletBold(f):
	bullet_bold = f
	updateAll()
func updateBulletItalic(f):
	bullet_italic = f
	updateAll()

func updateTitleSize(s):
	title_size = s
	updateAll()

func updateTextSize(s):
	text_size = s
	updateAll()

func updateSourcesSize(s):
	sources_size = s
	updateAll()

func updatePageNumberSize(s):
	pagenumber_size = s
	updateAll()

