# CLORO
extends Area2D
class_name Projectile

enum Type {
	Player = 0,
	Enemy = 1,
	NoOwner = 2
}

onready var world = get_tree().get_current_scene()
onready var player = get_tree().get_current_scene().get_node("./YSort/Player")
const Ghost = preload("res://objects/vanity/Ghost.tscn")
const BulletHit = preload("res://objects/vanity/BulletHit.tscn")
const Ricochet = preload("res://objects/sound/Ricochet.tscn")

const Sound = preload("res://sound/vanity/ricochet.mp3")

onready var sprite = $Projectile
onready var timer = $Timer
onready var light = $Light

export var reflection = false
export var damage := 15
export var speed := 500
export var bullet_color := 0
export var projectile_owner = Type.NoOwner
export(NodePath) var bullet_owner_path
var type = "Pistol"
var bullet_owner = ""

var ricochet = 0
var max_ricochet = 3

signal damaged(toHit, value)

func get_owner():
	bullet_owner

func explode():
	## Explosion Vanity
	var ex = BulletHit.instance()
	ex.position = position
	
	get_tree().get_current_scene().add_child(ex)
	
	ex.start(bullet_color)
	queue_free()

func _ready() -> void:
	set_as_toplevel(true)
	connect("body_entered", self, "_on_body_entered")
	
	timer.start()

func set_color(color, intColor):
	bullet_color = intColor
	light.color = color
	light.color.a = .15
	sprite.modulate = color
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	
	if (speed > 2000):
		var ghost = Ghost.instance()
		world.add_child(ghost)
		
		ghost.global_position = global_position
		ghost.global_transform = global_transform
		ghost.texture = sprite.texture
		ghost.modulate = sprite.modulate
		ghost.start()
	

func _on_body_entered(body: Node) -> void:
	if (body.is_in_group("projectiles")): return
	if (body.is_in_group("vanity")): return
	if (body.is_in_group("mobs") and projectile_owner == Type.Enemy): return
	if (body.is_in_group("player") and projectile_owner == Type.Player): return
	
	if (reflection):
		if (ricochet > max_ricochet): 
			explode()
		
		var ricochet_s = Ricochet.instance()
		ricochet_s.stream = Sound
		ricochet_s.global_position = global_position
		ricochet_s.pitch_scale = rand_range(.65, 1.35)
		ricochet_s.volume_db = -6
		ricochet_s.max_distance = 500
		world.add_child(ricochet_s)
		
		ricochet_s.play()
		
		transform.x = transform.rotated(deg2rad(120)).x
		ricochet += 1
	elif player.gun_type == 3:
		if body.is_in_group("mobs") == false:
			explode()
	else:
		explode()
	
func init(projectile_type, _speed = speed, _bullet_owner = "", _damage: int = damage, _type = "Pistol", _reflection = false) -> void:
	bullet_owner_path = _bullet_owner
	projectile_owner = projectile_type
	damage = _damage
	speed = _speed
	
	type = _type
	
	reflection = _reflection
	bullet_owner = get_node(bullet_owner_path)


func _on_Timer_timeout():
	queue_free()
