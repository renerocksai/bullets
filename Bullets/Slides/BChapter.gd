tool
extends Slide

onready var lblTitle = $ChapterTitle
onready var lblSecond = $ChapterSubtitle
onready var lblNumber = $ChapterNumber

export var ChapterNum :String setget updateChapter
export var Title :String setget updateTitle
export var Subtitle :String setget updateSubtitle

var ready = false

func _ready():
	ready = true
	updateChapter(ChapterNum)
	updateTitle(Title)
	updateSubtitle(Subtitle)
	
func updateChapter(s):
	ChapterNum = s
	if ready:
		lblNumber.bbcode_text = '[color=#cd0f2d]$number[/color]'.replace('$number', ChapterNum)
		
func updateTitle(s):
	Title = s
	if ready:
		lblTitle.bbcode_text = '[color=black]$t[/color]'.replace('$t', Title)
		
func updateSubtitle(s):
	Subtitle = s
	if ready:
		var x: String = '[color=#993366]$subtitle[/color]'
		s = x.replace('$subtitle', Subtitle.to_upper())
		lblSecond.bbcode_text = s
	
func set_slide_number(n):
	pass
	
