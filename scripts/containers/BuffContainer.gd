extends Node

onready var player = get_parent()

onready var buffSprite = player.get_node("BuffSprite")
onready var timer = $Duration

signal buff_changed
signal buff_timeout

var current_buff

func set_buff(buff):
	if (current_buff): 
		timer.stop()
	
	reset()
	current_buff = buff
	buff._action(player, get_tree())
	print("a: " + String(buff.buff_name) + " " + String(buff.type))
	
	timer.start(buff.duration)
	buffSprite.pop()
	
	emit_signal("buff_changed", buff)
	
func get_buff():
	return [current_buff, timer]

func reset():
	print("resetted")
	player.buff_movement_multiplier = float(0)
	player.demonic = false
	player.reflect = false
	player.reversal_is_active = false

func _on_Duration_timeout():
	print("stopped!")
	current_buff = Buff.new()
	current_buff._action(player, get_tree())
	
	reset()
	
	emit_signal("buff_timeout")
