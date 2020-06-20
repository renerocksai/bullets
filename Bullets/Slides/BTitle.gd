tool
extends Slide

onready var lblTitle = $RichTextLabel
onready var lblSecond = $RichTextLabel2

export var Title :String setget updateTitle
export var Subtitle :String setget updateSubtitle
export var Authors:String setget updateAuthors

export var title_size:float = 100 setget updateTitleSize
export var title_color = Color.black setget updateTitleColor
export var subtitle_size:float = 45 setget updateSubtitleSize
export var subtitle_color = Color('#cd0f2d') setget updateSubtitleColor
export var authors_color = Color('#993366') setget updateAuthorsColor

var ready = false

func _ready():
	ready = true
	updateAll()

func updateAll():
	Utils.resizeFontsFor(lblTitle, title_size)
	Utils.resizeFontsFor(lblSecond, subtitle_size)
	updateTitle(Title)
	updateAuthors(Authors)

func updateTitle(s):
	Title = s
	if ready:
		lblTitle.bbcode_text = '[color=#{title_color}]{title}[/color]'.format({
			'title_color': title_color.to_html(),
			'title': Title,
			})

func updateAuthors(s):
	Authors = s
	updateSubtitle(Subtitle)

func updateSubtitle(s):
	Subtitle = s
	if ready:
		lblSecond.bbcode_text = '[color=#{subtitle_color}]{subtitle}[/color]\n[color=#{authors_color}]{authors}[/color]'.format({
			'subtitle_color': subtitle_color.to_html(),
			'subtitle': Subtitle.to_upper(),
			'authors_color': authors_color.to_html(),
			'authors': Authors.to_upper(),
			})

func set_slide_number(_n):
	pass

func updateTitleColor(c):
	title_color = c
	updateAll()
func updateSubtitleColor(c):
	subtitle_color = c
	updateAll()
func updateAuthorsColor(c):
	authors_color = c
	updateAll()

func updateTitleSize(s):
	title_size = s
	updateAll()

func updateSubtitleSize(s):
	subtitle_size = s
	updateAll()

