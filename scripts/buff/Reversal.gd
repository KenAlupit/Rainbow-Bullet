extends "res://scripts/Buff.gd"
class_name ReversalBuff

func _init():
	print("reverse!!!")
	buff_name = "Reversal"
	type = Buff.Type.Reversal
	duration = 8
	sound = preload("res://sound/buff/reversal.mp3")
	image = preload("res://textures/buff/Reversal.png")

func _action(player, root):
	player.reversal_is_active = true
	._action(player, root)
