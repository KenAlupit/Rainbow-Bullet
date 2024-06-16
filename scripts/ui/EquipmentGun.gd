extends HBoxContainer

export var unlocked = false setget unl_set
export var equipped = false setget equ_set

onready var l_name = $Name
onready var l_number = $Number

func unl_set(value):
	unlocked = value
	update()

func equ_set(value):
	equipped = value
	update()

func update():
	var toSubtract = 0
	if (!unlocked): toSubtract += .6
	if (equipped): toSubtract += .2 
	
	modulate = Color(1-toSubtract, 1-toSubtract, 1-toSubtract, 1)
