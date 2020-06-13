extends Node2D

onready var music = $Game/Level/Music

func _ready():
	music.play()

