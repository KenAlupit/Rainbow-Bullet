class_name Enemy

enum States {
	IDLE,
	WANDER,
	CHASE
}

export var acceleration = 150.0
export var max_speed = 150.0
export var friction = 200.0 
export var wander_target_range = 4.0
export var current_color = 0
var velocity = Vector2.ZERO

export var max_distance = 800

var SpriteImage = preload("res://textures/enemy/EntityBody.png")
var DeathSound = preload("res://sound/enemy/death.mp3")
var HitSound = preload("res://sound/enemy/hit.mp3")

const Blood = preload("res://objects/Blood.tscn")
const Splatter = preload("res://objects/sound/Splatter.tscn")
const EnemyHit = preload("res://objects/sound/EnemyHit.tscn")

onready var world

onready var player_detection
onready var muzzle
onready var time
onready var ray
onready var stats
onready var sprite
onready var color_mode
onready var dash

onready var indicator

onready var damaged

onready var player
onready var score

onready var wander_controller

#
var enemy: KinematicBody2D
var wander_randomize = [1, 3]

var blood_instance: Node
var b_splatter: Node
var bullet: Node
var bullet_loc: Vector2
var enemies_around: Array = []
var dashing: bool = false

var hurtbox: Area2D
var explode: Area2D

var state = States.CHASE

var seen_player: bool = false

var staying = 0
var distance_to_back_up = rand_range(100, 250)

export var type = "Common"
func _init(contents):
	enemy = contents["enemy"]
	world = contents["world"]
	
	dash = contents["dash"]
	
	player_detection = contents["player_detection"]
	muzzle = contents["muzzle"]
	time = contents["time"]
	ray = contents["ray"]
	stats = contents["stats"]
	sprite = contents["sprite"]
	color_mode = contents["color_mode"]
	damaged = contents["damaged"]
	
	player = contents['player']
	score = contents["score"]
	
	wander_controller = contents["wander_controller"]
	
	hurtbox = contents["hurtbox"]
	explode = contents["explode"]
	
	indicator = world.get_node("Indicators")
	hurtbox.connect("area_entered", self, "_hurtbox_area_connect")
	
	explode.connect("area_entered", self, "_explode_area_connect")
	explode.connect("body_entered", self, "_explode_body_connect")
	
	dash.connect("timeout", self, "_dash_timeout")
	
	stats.connect("health_changed", self, "_health_changed")
	stats.connect("no_health", self, "_no_health")

func _start():
	randomize()
	blood_instance = Blood.instance()
	b_splatter = Splatter.instance()
	
	sprite.texture = SpriteImage
	current_color = Colors._get_random_color(sprite)
	state = States.CHASE
	
	_update_wander()
	damaged._start()

func update_physics_process(delta):
	if (player.dead): return
	velocity = enemy.move_and_slide(velocity)
	
	var _cast_coordinates = RainbowAI._precalculate_ray_coordinates(1500) # ???
	
	for index in _cast_coordinates:
		ray.cast_to = index
		ray.force_raycast_update()
		
		if (ray.is_colliding() and ray.get_collider() == player):
			seen_player = true
	
	match state:
		States.IDLE:
			_idle(delta)
		
		States.WANDER:
			_wander(delta)
		
		States.CHASE:
			_chase(delta)


func _idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	_seek_player()
		
	if (wander_controller.get_time_left() == 0):
		_update_wander()

func _wander(delta):
	_seek_player()
	if (wander_controller.get_time_left() == 0):
		_update_wander()
		_accelerate_towards_point(wander_controller.target_position, delta)
	
	if (enemy.global_position.distance_to(wander_controller.target_position) <= wander_target_range):
		_update_wander()

func _shoot(type, projectile_type, bullet_owner, speed = 500, color = ColorN("blue", 1), intColor = 0, reflection = false, demonic = false, ignore_timer = false):
	muzzle.shoot(type, projectile_type, bullet_owner, speed, color, intColor, reflection, demonic, ignore_timer)
	
func _chase(delta):
	var space_state = enemy.get_world_2d().direct_space_state
	var gun_type = Gun.GunTypes.Pistol
	if (seen_player == true):
		var random = randi() % 32
		if (random == 1 or staying > 300): 
			staying = 0
		
		if (player.global_position.distance_to(enemy.global_position) > distance_to_back_up and staying == 0):
			_accelerate_towards_point(player.global_position, delta)
		elif (player.global_position.distance_to(enemy.global_position) <= distance_to_back_up):
			staying += 1
			_accelerate_towards_point((player.global_position - Vector2(250, 0)), delta)
		
		var result = space_state.intersect_ray(player.global_position, enemy.global_position, [enemy])
		enemy.look_at(player.global_position)
		
		if (result and result.position.distance_to(player.global_position) < 30):
			_shoot(gun_type, Projectile.Type.Enemy, enemy.get_path(), 500, Colors.Color_Mode[4], current_color)
		elif (not result):
			_shoot(gun_type, Projectile.Type.Enemy, enemy.get_path(), 500, Colors.Color_Mode[4], current_color)
	else:
		_accelerate_towards_point(wander_controller.target_position, delta)
		
		if (wander_controller.target_position.distance_to(enemy.global_position) < 4):
			wander_controller.update_target_position()
	
	if (player_detection._can_see_player()):
		enemy.look_at(player_detection.player.global_position)

func _update_wander():
	wander_controller.start_wander_timer(rand_range(wander_randomize[0], wander_randomize[1]))

func _accelerate_towards_point(point, delta):
	var direction = enemy.global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration)
	
	enemy.look_at(velocity)

func _seek_player():
	if (player_detection._can_see_player()):
		state = States.CHASE

func _kill():
	stats.set_health(0)

func _safe_increment(value):
	var valid = is_instance_valid(player)
	
	if (valid):
		score.increment(value)

func _explode_body_connect(body):
	if (body.is_in_group("mobs") and body != enemy):
		enemies_around.append(body)

func _explode_area_connect(area):
	pass

func _hurtbox_area_connect(area):
	if (area.is_in_group("projectiles") and "projectile_owner" in area and area.projectile_owner != Projectile.Type.Enemy):
		if (area.bullet_color == current_color):
			bullet = area
			if player.reversal_is_active == true:
				player.stats.health += .5
			else:
				var g_name = Gun.GunTypes.keys()[player.gun_type]
				var get_type = muzzle.get_information(g_name)
				var damage = 15
				
				if (get_type):
					damage = get_type.Damage
				
				stats.health -= damage
				var enemy_h = EnemyHit.instance()
				enemy.add_child(enemy_h)
				
				enemy_h.play()
				
				score.increment(15)

func _blood():
	if (!is_instance_valid(enemy)): return
	if (!is_instance_valid(player)): return
	blood_instance.set_color(Colors.Color_Mode[current_color])
	world.add_child(blood_instance)
	b_splatter.stream = DeathSound
	
	blood_instance.scale_amount_random = .5
	blood_instance.set_spread(180)
	blood_instance.color.a = .35
	blood_instance.add_child(b_splatter)
	
	b_splatter.play()
	blood_instance.global_position = enemy.global_position
	if is_instance_valid(bullet) and player.reversal_is_active == false:
		blood_instance.rotation = enemy.global_position.angle_to_point(bullet.global_position)
	else:
		blood_instance.rotation = enemy.global_position.angle_to_point(player.global_position)
	
	enemy.queue_free()

func _health_changed(value, last_health):
	if (value < last_health):
		damaged._pop()
		indicator.make_damage_indicator((last_health-value), "less", enemy.global_position)

func update_process(delta):
	pass

func _no_health():
	score.increment(100)
	if player.reversal_is_active == true:
		blood_instance.set_spread(180)
		
	_blood()

func _dash_timeout():
	dashing = false
