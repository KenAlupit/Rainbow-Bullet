extends Node
class_name Buff
const buffSound = preload("res://objects/sound/BuffSound.tscn")

enum Type {
	NoBuff, # 0
	Adrenaline, # 1
	BigHealth, # 2
	Reflection, # 3
	Demonic, # 4
	HealthSmall, # 5
	Rainbow, # 6
	Reversal  # 7
}

onready var world = get_tree().get_current_scene()

onready var image = preload("res://textures/buff/NoBuff.png")
onready var sound = preload("res://sound/buff/no_buff.mp3")

export var buff_name = "NoBuff"
export var type = Type.NoBuff
export var duration = 1

signal buff_ready

func _init():
	emit_signal("buff_ready")

func _play_sound(player):
	var n_sound = buffSound.instance()
	n_sound.stream = sound
	
	player.add_child(n_sound)
	n_sound.play()

func _action(player, root):
	_play_sound(player)
