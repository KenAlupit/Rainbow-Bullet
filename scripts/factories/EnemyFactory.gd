extends Node
class_name EnemyFactory

var enemy_list = [
	preload("res://scripts/Enemy.gd"), # Common
	preload("res://scripts/enemy/Blinking.gd"), # Blinking
	preload("res://scripts/enemy/Suicide.gd"), # Suicide
	preload("res://scripts/enemy/Big.gd") # Big
]

func get_random(_min = 0, _max = enemy_list.size()):
	var random = randi() % enemy_list.size()
	
	print(random)
	return enemy_list[clamp(random, _min, _max)]

func get_enemy(type = 0):
	return enemy_list[type]
