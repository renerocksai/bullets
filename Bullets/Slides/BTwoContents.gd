tool
extends Node2D

onready var titleLabel: = $TitleLabel
onready var content: = $ContentLabel
onready var content2: = $ContentLabel2
onready var sourceLabel: = $SourceInfoLabel
onready var pagenumLabel: = $PageNumber

export var title:String setget updateTitle
export(String, MULTILINE) var textLeft setget updateLeft
export(String, MULTILINE) var textRight setget updateRight
export var sources:String setget updateSources


var regex = RegEx.new()
var ready = false

func _ready():
	regex.compile("(^|\n[ \t]*)(>|-)")
	ready = true
	updateTitle(title)
	updateLeft(textLeft)
	updateRight(textRight)
	updateSources(sources)

	
func updateTitle(s):
	title = s
	if ready:
		titleLabel.bbcode_text = '[color=black]$t[/color]'.replace('$t', title)

func updateLeft(s):
	textLeft = s
	if ready:
		content.bbcode_text = '[color=black]' + format_content(textLeft) + '[/color]'

func updateRight(s):
	textRight = s
	if ready:
		content2.bbcode_text = '[color=black]' + format_content(textRight) + '[/color]'

func updateSources(s):
	sources = s
	if ready:
		if len(sources) > 0:
			sourceLabel.bbcode_text = '[color=gray]$x[/color]'.replace('$x', sources)
		else:
			sourceLabel.bbcode_text = ''

func format_content(s):
	s = self.regex.sub(s, '$1[color=#cd0f2d]> [/color]', true)
	return s

func set_slide_number(n):
	pagenumLabel.bbcode_text = str(n)
	
