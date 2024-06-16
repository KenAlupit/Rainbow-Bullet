extends Node2D

onready var timer = get_node("Timer")
onready var target_position = global_position
onready var buff = load("res://objects/Pick-up.tscn")

onready var world = get_tree().get_current_scene()

func _physics_process(delta):
	if timer.time_left == 0:
		var pick_up = buff.instance()
		pick_up.position = target_position
		world.add_child(pick_up)
		start_spawner_timer(randi() % 30)

func _ready():
	update_target_position()

func update_target_position():
	var space_state = get_world_2d().direct_space_state
	var target_vector = Vector2(rand_range(-500, 500), rand_range(-500, 500))
	var result = space_state.intersect_point(target_vector)
	if (result):
		update_target_position()
	
	target_position = target_vector

func start_spawner_timer(duration):
	timer.start(duration)
	
func _on_Timer_timeout():
	update_target_position()
