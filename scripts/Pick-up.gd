extends Area2D

onready var world = get_tree().get_current_scene()

onready var factories = world.get_node("Factories")
onready var buffFactory = factories.get_node("Buff")

onready var sprite = $Sprite
onready var player = world.get_node("./YSort/Player")
onready var buff = player.get_node("Buff")

onready var light = $Light
onready var despawn = $Timer

var type = 0
var picked_up = false
var stopped = false

var dt = 0

func _on_Area2D_body_entered(body):
	if (picked_up): return
	if body == player:
		buff.set_buff(type)
		
		picked_up = true
		queue_free()

func _ready():
	type = buffFactory.get_random(1)
	
	sprite.texture = type.image
	despawn.start()

func _process(delta):
	if (dt >= 1): dt = 0
	
	light.color.s = 1
	light.color.h = dt
	
	sprite.modulate.s = .125
	sprite.modulate.h = dt
	dt += 0.01

func _on_Timer_timeout():
	queue_free()
