extends Node2D

onready var timer = get_node("Timer")
onready var target_position = global_position
onready var enemyscene = load("res://objects/Enemy.tscn")

onready var enemy_factory = get_tree().get_current_scene().get_node("Factories/Enemy")

onready var world = get_tree().get_current_scene()
onready var parent = get_parent()

onready var player = parent.get_node("Player")

export(int) var wander_range = 500
export(int) var Wave_count = 1000
export(int) var Wave_increment = 2
export(int) var wave = 1 setget evaluate_new_equipment;
var Wave_done = false
var Enemy_quantity = 1
export var n = 0;

func evaluate_new_equipment(value):
	wave = value

func _physics_process(delta):
	var enemy_count = get_tree().get_nodes_in_group("mobs").size()
	
	if wave != Wave_count:
		if Wave_done == false:
			if timer.time_left == 0 and enemy_count < 10:
				var type = enemy_factory.get_random()
				
				var enemy = enemyscene.instance()
				enemy.position = target_position
				#enemy.enemy_type = randi()%4
				parent.call_deferred("add_child", enemy)
				
				enemy.type = [type, player]
				
				start_spawner_timer(1)
				n += 1
			if n == Enemy_quantity:
				Wave_done = true
				n = 0
		elif Wave_done == true and enemy_count == 0:
			player.stats.max_health = clamp(player.stats.max_health + 1, 20, 100)
			evaluate_new_equipment(wave + 1)
			if (wave % 3 == 0):
				player.current_unlocked += 1
			Enemy_quantity += Wave_increment
			Wave_done = false

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	if (target_vector.distance_to(player.global_position) <= 150):
		update_target_position()
		
		return
	
	target_position = target_vector

func start_spawner_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
