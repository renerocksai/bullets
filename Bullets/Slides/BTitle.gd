tool
extends Node2D

onready var lblTitle = $RichTextLabel
onready var lblSecond = $RichTextLabel2

export var Title :String setget updateTitle
export var Subtitle :String setget updateSubtitle
export var Authors:String setget updateAuthors

var ready = false

func _ready():
	ready = true
	updateTitle(Title)
	updateAuthors(Authors)	
	
func updateTitle(s):
	Title = s
	if ready:
		lblTitle.bbcode_text = '[color=black]$t[/color]'.replace('$t', Title)
	
func updateAuthors(s):
	Authors = s
	updateSubtitle(Subtitle)
	
func updateSubtitle(s):
	Subtitle = s
	if ready:
		var x: String = '[color=#cd0f2d]$subtitle[/color]\n[color=black]$authors[/color]'
		s = x.replace('$subtitle', Subtitle.to_upper()).replace('$authors', Authors.to_upper())
		lblSecond.bbcode_text = s
	
	
func set_slide_number(n):
	pass
	
