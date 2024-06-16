extends "res://scripts/Buff.gd"
class_name BigHealthBuff

func _init():
	print("bg!!!")
	buff_name = "BigHealth"
	type = Buff.Type.BigHealth
	duration = 1
	sound = preload("res://sound/buff/health_big.mp3")
	image = preload("res://textures/buff/BigHealth.png")

func _action(player, root):
	var stats = player.get_node("Stats")
	
	stats.set_health(clamp(stats.get_health() + (stats.get_max_health() * .75), 0, stats.get_max_health()))
	._action(player, root)
