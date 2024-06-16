extends "res://scripts/Buff.gd"
class_name RainbowBuff

func _init():
	print("rain!!!")
	buff_name = "Rainbow"
	type = Buff.Type.Rainbow
	duration = 1
	sound = preload("res://sound/buff/rainbow.mp3")
	image = preload("res://textures/buff/Rainbow.png")

func _action(player, root):
	var enemies = root.get_nodes_in_group("mobs")
	for enemy in enemies:
		enemy.kill()
	
	._action(player, root)
