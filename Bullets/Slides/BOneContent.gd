tool
extends Slide

onready var titleLabel: = $TitleLabel 
onready var contentLabel: = $ContentLabel 
onready var sourceLabel: = $SourceInfoLabel 
onready var pagenumLabel: = $PageNumber

export var title:String setget updateTitle
export(String, MULTILINE) var text setget updateContent
export var sources:String setget updateSources


var regex = RegEx.new()
var ready = false

func _ready():
	regex.compile("(^|\n[ \t]*)(>|-)")
	ready = true
	updateTitle(title)
	updateContent(text)
	updateSources(sources)	

				
func updateTitle(s):
	title = s
	if ready:
		titleLabel.bbcode_text = '[color=black]$t[/color]'.replace('$t', title)

func updateContent(s):
	text = s
	if ready:
		contentLabel.bbcode_text = '[color=black]' + format_content(text) + '[/color]'

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
