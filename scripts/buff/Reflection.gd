extends "res://scripts/Buff.gd"
class_name ReflectionBuff

func _init():
	print("reflect!!!")
	buff_name = "Reflection"
	type = Buff.Type.Reflection
	duration = 30
	sound = preload("res://sound/buff/reflection.mp3")
	image = preload("res://textures/buff/Deflect.png")

func _action(player, root):
	player.reflect = true
	._action(player, root)
