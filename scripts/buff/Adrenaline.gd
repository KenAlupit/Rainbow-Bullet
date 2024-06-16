extends "res://scripts/Buff.gd"
class_name AdrenalineBuff

func _init():
	print("adrenaline!!!")
	buff_name = "Adrenaline"
	type = Buff.Type.Adrenaline
	duration = 15
	sound = preload("res://sound/buff/adrenaline.mp3")
	image = preload("res://textures/buff/Adrenaline.png")

func _action(player, root):
	player.buff_movement_multiplier = float(.5)
	._action(player, root)
