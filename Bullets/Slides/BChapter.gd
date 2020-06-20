tool
extends Slide

onready var lblTitle = $ChapterTitle
onready var lblSecond = $ChapterSubtitle
onready var lblNumber = $ChapterNumber

export var ChapterNum :String setget updateChapter
export var Title :String setget updateTitle
export var Subtitle :String setget updateSubtitle

export var chapter_num_size:float = 300 setget updateChapterNumSize
export var chapter_num_color = Color('#cd0f2d') setget updateChapterNumColor
export var title_size:float = 72 setget updateTitleSize
export var title_color = Color.black setget updateTitleColor
export var subtitle_size:float = 36 setget updateSubtitleSize
export var subtitle_color = Color('#993366') setget updateSubtitleColor

var ready = false

func _ready():
	ready = true
	updateAll()

func updateAll():
	Utils.resizeFontsFor(lblTitle, title_size)
	Utils.resizeFontsFor(lblSecond, subtitle_size)
	Utils.resizeFontsFor(lblNumber, chapter_num_size)
	updateChapter(ChapterNum)
	updateTitle(Title)
	updateSubtitle(Subtitle)

func updateChapter(s):
	ChapterNum = s
	if ready:
		lblNumber.bbcode_text = '[color=#{chapter_num_color}]{chapter_num}[/color]'.format({
			'chapter_num_color': chapter_num_color.to_html(),
			'chapter_num': ChapterNum,
		})

func updateTitle(s):
	Title = s
	if ready:
		lblTitle.bbcode_text = '[color=#{title_color}]{title}[/color]'.format({
			'title_color': title_color.to_html(),
			'title': Title,
		})

func updateSubtitle(s):
	Subtitle = s
	if ready:
		lblSecond.bbcode_text = '[color=#{subtitle_color}]{subtitle}[/color]'.format({
			'subtitle_color': subtitle_color.to_html(),
			'subtitle': Subtitle.to_upper(),
		})

func set_slide_number(_n):
	pass

func updateTitleColor(c):
	title_color = c
	updateAll()
func updateSubtitleColor(c):
	subtitle_color = c
	updateAll()
func updateChapterNumColor(c):
	chapter_num_color = c
	updateAll()

func updateTitleSize(s):
	title_size = s
	updateAll()

func updateSubtitleSize(s):
	subtitle_size = s
	updateAll()

func updateChapterNumSize(s):
	chapter_num_size = s
	updateAll()
