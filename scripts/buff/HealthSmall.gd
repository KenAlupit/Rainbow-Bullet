extends "res://scripts/Buff.gd"
class_name HealthSmallBuff

func _init():
	print("hs!!!")
	buff_name = "HealthSmall"
	type = Buff.Type.HealthSmall
	duration = 1
	sound = preload("res://sound/buff/health_small.mp3")
	image = preload("res://textures/buff/HealthSmall.png")

func _action(player, root):
	var stats = player.get_node("Stats")
	
	stats.set_health(clamp(stats.get_health() + (stats.get_max_health() * .35), 0, stats.get_max_health()))
	._action(player, root)
