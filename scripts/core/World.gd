extends Node2D

onready var music = $Music
export var is_over = false

func _ready():
	randomize()
	Engine.time_scale = 1
	
	var seek = randi() % int(music.stream.get_length())
	music.play(float(seek))
