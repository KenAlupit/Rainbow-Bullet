extends Node2D

onready var timer = get_node("Timer")
onready var target_position = global_position

onready var enemy_factory = get_tree().get_current_scene().get_node("Factories/Enemy")

onready var enemyscene = load("res://objects/Enemy.tscn")
export(int) var wander_range = 250

signal enemy_spawned;

func _physics_process(delta):
	var enemy_count = get_tree().get_nodes_in_group("mobs").size();
	if enemy_count != 10:
		if timer.time_left == 0:
			emit_signal("enemy_spawned")
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
