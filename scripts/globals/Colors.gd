extends Node

export onready var Color_Mode = [ColorN("green", 1), ColorN("yellow",1), ColorN("blue",1), ColorN("purple",1), ColorN("red", 1)]
export onready var Color_Mode_Blood = [ColorN("green", 0.5), ColorN("yellow",0.5), ColorN("blue",0.5), ColorN("purple",0.5), ColorN("red", 1)]

func _get_random_color(sprite):
	var randomInt = randi() % (Colors.Color_Mode.size()-1)
	
	var rand_color = Colors.Color_Mode[randomInt]
	sprite.modulate = rand_color
	
	return randomInt
