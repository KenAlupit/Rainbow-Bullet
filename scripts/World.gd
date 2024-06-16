extends Node2D

onready var timer = get_node("Timer")
onready var target_position = global_position
onready var enemyscene = load("res://objects/Enemy.tscn")
export(int) var wander_range = 32


func _physics_process(delta):
	if timer.time_left == 0:
		var enemy = enemyscene.instance()
		enemy.position = target_position
		add_child(enemy)
		start_spawner_timer(10)
		
func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = target_vector

func start_spawner_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
