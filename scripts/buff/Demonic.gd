extends "res://scripts/Buff.gd"
class_name DemonicBuff

func _init():
	print("de!!!")
	buff_name = "Demonic"
	type = Buff.Type.Demonic
	duration = 12
	sound = preload("res://sound/buff/demonic.mp3")
	image = preload("res://textures/buff/Demonic.png")

func _action(player, root):
	player.demonic = true
	._action(player, root)
