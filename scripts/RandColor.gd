extends Node

func _get_random_color(sprite):
	var randomInt = randi() % (Colors.Color_Mode.size()-1)
	
	var rand_color = Colors.Color_Mode[randomInt]
	sprite.modulate = rand_color
	
	return randomInt
