extends Node2D

const blood = preload("res://objects/Blood.tscn")

onready var _bga = $BackgroundAmbience
onready var _floor = $Floor
var number: float = 0
var frameCount = 0
var frameInterval = [180, 248]

onready var top = $Top
onready var bottom = $Bottom

func _ready():
	Engine.time_scale = 1
	_bga.play()
	
	randomize()

func _process(delta):
	if (_floor.position.y >= _floor.region_rect.size.y-1920):
		_floor.position.y = 0
		number = 0
		
	frameCount += 1
	
	if (frameCount > int(round(rand_range(frameInterval[0], frameInterval[1])))):
		for n in randi() % 3:
			var c_blood = blood.instance()
			_floor.add_child(c_blood)
			c_blood.get_node("Timer").start()
			
			c_blood.z_index = 10
			c_blood.set_color(Colors.Color_Mode[randi() % (Colors.Color_Mode.size() - 1)])
			
			c_blood.scale_amount_random = rand_range(0.25, 1)
			
			c_blood.spread = 180
			c_blood.position = Vector2(rand_range(-680, 680), -_floor.position.y - 500 - rand_range(-512, 512))
			
			
			frameCount = 0
	
	_floor.position.y = number
	number += 1
