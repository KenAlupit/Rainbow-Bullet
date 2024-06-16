extends "res://scripts/Enemy.gd"
class_name BigEnemy

func _init(contents).(contents):
	pass
	
func _start():
	type = "Big"
	max_speed = 100
	acceleration = 100
	
	stats.max_health = 100
	._start()
