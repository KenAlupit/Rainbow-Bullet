# CLORO
extends KinematicBody2D
class_name Player

export(float) var default_speed = 325
export(float) var speed = 325
export(int) var current_color = -1 setget update_color
export(float) var buff_movement_multiplier = 0
var core_movement_multiplier = 1

var current_health = 20

onready var world = get_tree().get_current_scene()

onready var ui = world.get_node("MainUI")
onready var equipmentUI = ui.get_node("Equipment")

signal on_death

export(Vector2) var velocity := Vector2()
const Projectile = preload("res://scripts/core/Projectile.gd")
const Ghost = preload("res://objects/vanity/Ghost.tscn")
const DeathSound = preload("res://objects/sound/Death.tscn")
const DashSound = preload("res://objects/sound/DashSound.tscn")
const ColorChange = preload("res://objects/sound/ColorChange.tscn")
const TakeDamage = preload("res://objects/sound/TakeDamage.tscn")

onready var ColorMode = $Colors
onready var Muzzle = $Muzzle
onready var hurtBox = $Hurtbox
onready var stats = $Stats
onready var light = $Light
onready var sprite = $Sprite
onready var camera = world.get_node("Camera")
onready var indicator = world.get_node("Indicators")

onready var vanitySprite = $VanitySprite
onready var explode = $Explode

onready var damaged = $Damaged

onready var vanityTween = $VanitySprite/Tween
onready var explodeTween = $Explode/Tween
onready var lightTween = $Light/Tween

onready var dashCooldown = $DashCooldown
onready var dash = $Dash

onready var onEquipCooldown = $OnEquipCooldown


export var demonic = false setget update_demonic
export var reflect = false setget update_reflect

export var dead = false
var dashing = false

var reversal_is_active = false
var deflect_is_active = false


var recent_color = 0
export var gun_type = Gun.GunTypes.AssaultRifle

var current_gunInfo
var current_unlocked = 0 setget update_equipmentUI
var current_equipped = 0 setget update_equipped

var type_index = {
	0: "Pistol",
	1: "Shotgun",
	2: "AssaultRifle",
	3: "SniperRifle"
}

func update_reflect(value):
	reflect = value

func update_demonic(value):
	demonic = value
	if (demonic): dashCooldown.stop()
	dashCooldown.wait_time = 0.75 if (value) else 1.5

func _get_enemy():
	return world.get_node("Enemy")

func combine_multipliers() -> float:
	return core_movement_multiplier + float(buff_movement_multiplier)

func set_getInfo(g_name):
	current_gunInfo = Muzzle.get_information(Gun.GunTypes.keys()[g_name])
	Muzzle.set_firerate(current_gunInfo.FireRate)
	gun_type = g_name

func update_equipped(value):
	current_equipped = clamp(value, 0, current_unlocked)
	
	set_getInfo(current_equipped)
	for n in range(0, 4):
		var index = type_index[n]
		
		equipmentUI.set_equipped(index, current_equipped == n)

func update_equipmentUI(value):
	current_unlocked = clamp(value, 0, 4)
	
	if (current_unlocked < 3):
		ui.pop_new_equip()
	for n in range(0, 4):
		var index = type_index[n]
		
		equipmentUI.set_unlocked(index, current_unlocked >= n)

## Movement
func get_input() -> void:
	if (ui.colorWheel_enabled()): 
		dashing = false 
		return
	var type = Gun.FireTypes.keys()[current_gunInfo.Type]
	if (get_global_mouse_position().distance_to(position) > 12):
		look_at(get_global_mouse_position())
	
	if (dashing):
		return
	
	var global_unit_dir = Vector2(0, 0)
	var x = 0
	var y = 0
	
	ui.vignetteMode = Input.is_action_pressed("walk")
	core_movement_multiplier = float(1)
	if (Input.is_action_pressed("walk")):
		core_movement_multiplier = float(.65)
	
	speed = default_speed * combine_multipliers()
	Engine.time_scale = core_movement_multiplier
	
	if (type == "Automatic"):
		if (Input.is_action_pressed("shoot")):
			Muzzle.shoot(gun_type, Projectile.Type.Player, self.get_path(), null, ColorMode.Color_Mode[current_color], current_color, reflect, demonic)
	
	if (Input.is_action_pressed("move_up")):
		y = (Vector2.UP).y
	elif (Input.is_action_pressed("move_down")):
		y = (Vector2.DOWN).y
	
	if (Input.is_action_pressed("move_right")):
		x = (Vector2.RIGHT).x
	elif (Input.is_action_pressed("move_left")):
		x = (Vector2.LEFT).x

	global_unit_dir = Vector2(x, y)
	velocity = (global_unit_dir if (not Input.is_action_pressed("world_movement")) else global_unit_dir.rotated(rotation + (PI/2))) * speed

func update_color(value = current_color):
	if (value == -1):
		value = current_color
	
	if (value != current_color):
		explodeTween.interpolate_property(explode, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .75, explodeTween.TRANS_QUAD, explodeTween.EASE_OUT)
		explodeTween.interpolate_property(explode, "scale", Vector2(2, 2), Vector2(4, 4), .75, explodeTween.TRANS_QUAD, explodeTween.EASE_OUT)
		vanityTween.interpolate_property(vanitySprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .35, vanityTween.TRANS_QUAD, vanityTween.EASE_OUT)
		
		current_color = value
		var currentColor = ColorMode.Color_Mode[current_color]
		lightTween.interpolate_property(light, "color", Color(1, 1, 1, 1), Color(currentColor.r, currentColor.g, currentColor.b, .065), .5, lightTween.TRANS_QUAD, lightTween.EASE_OUT)
		lightTween.interpolate_property(light, "texture_scale", 2, 1.48, .5, lightTween.TRANS_QUAD, lightTween.EASE_OUT)
		
		var c_sound = ColorChange.instance()
		add_child(c_sound)
		c_sound.play()
		
		explodeTween.start()
		vanityTween.start()
		lightTween.start()
	
	
	recent_color = current_color
	
	sprite.modulate = ColorMode.Color_Mode[current_color]

## Shoot
func _input(event):
	if (ui.colorWheel_enabled()): 
		dashing = false 
		return
	if (dead): return
	var type = Gun.FireTypes.keys()[current_gunInfo.Type]
	if (Input.is_action_just_pressed("shoot") and type == "SemiAuto"):
		Muzzle.shoot(gun_type, Projectile.Type.Player, self.get_path(), null, ColorMode.Color_Mode[current_color], current_color, reflect, demonic)
	
	if (onEquipCooldown.is_stopped()):
		if (Input.is_action_just_pressed("pistol")): 
			update_equipped(0) 
			onEquipCooldown.start()
		if (Input.is_action_just_pressed("shot_gun")): 
			update_equipped(1) 
			onEquipCooldown.start()
		if (Input.is_action_just_pressed("assault_rifle")): 
			update_equipped(2)
			onEquipCooldown.start()
		if (Input.is_action_just_pressed("sniper_rifle")): 
			update_equipped(3) 
			onEquipCooldown.start()
		
	
	if (Input.is_action_just_pressed("dash") and dashCooldown.is_stopped()):
		dashing = true
		
		var d_sound = DashSound.instance()
		d_sound.pitch_scale = rand_range(0.8, 1.2)
		
		add_child(d_sound)
		
		d_sound.play()
		dash.start()
		dashCooldown.start()
		
func _physics_process(delta: float) -> void:
	if (dead): return
	get_input()
	velocity = move_and_slide(velocity * (1.65 if (dashing) else 1))

func _process(delta):
	if (dead): return
	if (dashing):
		var ghost = Ghost.instance()
		world.add_child(ghost)
		
		ghost.global_position = global_position
		ghost.global_transform = global_transform
		ghost.texture = sprite.texture
		ghost.modulate = sprite.modulate
		ghost.start()
	

func _on_Hurtbox_area_entered(area):
	if (area.is_in_group("projectiles") and "projectile_owner" in area and area.projectile_owner == Projectile.Type.Enemy and reversal_is_active == false and deflect_is_active == false):
		stats.health -= 1
	if (area.is_in_group("projectiles") and "projectile_owner" in area and area.projectile_owner == Projectile.Type.Enemy and reversal_is_active != false):
		if is_instance_valid(area.bullet_owner):
			area.bullet_owner.stats.health -= 1
	if area.is_in_group("projectiles") and deflect_is_active == true:
		area.projectile_owner = Projectile.Type.Player
		area.bullet_owner = self

func death():
	dead = true
	visible = false
	world.is_over = true
	
	var d_sound = DeathSound.instance()
	add_child(d_sound)
	
	d_sound.play()
	
	emit_signal("on_death")
	
func _ready():
	stats.connect("no_health", self, "death")
	update_color(0)
	damaged._start()
	
	stats.set_max_health(current_health)
	stats.set_health(current_health)
	set_getInfo(gun_type)
	update_equipmentUI(0)
	update_equipped(0)

func _on_Dash_timeout():
	dashing = false

func _on_Stats_health_changed(value, last_health):
	if (value < last_health):
		var takeDamage = TakeDamage.instance()
		add_child(takeDamage)
		
		takeDamage.play()
		damaged._pop()
		indicator.make_damage_indicator(abs(last_health-value), "less", global_position) 
