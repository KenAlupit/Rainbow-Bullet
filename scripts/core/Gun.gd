# CLORO
extends Position2D
class_name Gun

const Bullet = preload("res://objects/Bullet.tscn")
const Projectile = preload("res://scripts/core/Projectile.gd")
const Fire = preload("res://objects/sound/Fire.tscn")

onready var fire = $Fire

enum GunTypes {
	Pistol, 
	Shotgun, 
	AssaultRifle, 
	SniperRifle
}

enum FireTypes {
	SemiAuto,
	Automatic,
	Shotgun
}


var gunSound = {
	"Pistol": {
		sound = preload("res://sound/gun/pistol.mp3"),
		volume = 1
	},
	"Shotgun": {
		sound = preload("res://sound/gun/shotgun.mp3"),
		volume = 1.3
	},
	"AssaultRifle": {
		sound = preload("res://sound/gun/assault_rifle.mp3"),
		volume = 1.25
	},
	"SniperRifle": {
		sound = preload("res://sound/gun/sniper_rifle.mp3"),
		volume = 2
	},
}

var gunInfo = {
	"Pistol": {
		FireRate = 400,
		Damage = 18,
		Type = FireTypes.SemiAuto,
		Speed = 1350,
		Bullets = 1,
		Spread = 0.05
	},
	"Shotgun": {
		FireRate = 50,
		Damage = 45,
		Type = FireTypes.SemiAuto,
		Speed = 1450,
		Bullets = 6,
		Spread = 0.25
	},
	"AssaultRifle": {
		FireRate = 500,
		Damage = 10,
		Type = FireTypes.Automatic,
		Speed = 1650,
		Bullets = 1,
		Spread = 0.1275
	},
	"SniperRifle": {
		FireRate = 25,
		Damage = 80,
		Type = FireTypes.SemiAuto,
		Speed = 3500,
		Bullets = 1,
		Spread = 0
	}
}

onready var timer = $Timer

export(GunTypes) var type
export(float) var current_fireRate = 0
export var current_damage = 0

func get_information(value):
	return gunInfo[value]
	
func set_firerate(value):
	timer.stop()
	var computed = float(float(60)/float(value))
	print(computed)
	timer.wait_time = computed
	
func shoot(type, projectile_type, bullet_owner, speed = 300, color = ColorN("blue", 1), intColor = 0, reflection = false, demonic = false, ignore_timer = false, bullet = 1, bullet_time = 0):
	if (timer.is_stopped()):
		var g_name = GunTypes.keys()[type]
		var get_type = gunInfo[g_name]
		
		for n in range(0, bullet if (bullet > 1) else get_type.Bullets):
			var b = Bullet.instance()
			get_tree().get_current_scene().add_child(b)
			
			b.projectile_owner = projectile_type
			b.transform = global_transform
			
			current_damage = get_type.Damage
			var spread = get_type.Spread
			speed = get_type.Speed * (2 if (demonic) else 1)
			
			if (projectile_type == Projectile.Type.Enemy):
				speed = 500
				spread = PI * 0.175
			
			b.rotation += rand_range(-spread, spread)
			b.set_color(color, intColor)
			b.init(projectile_type, speed, bullet_owner, current_damage, g_name, reflection)
		
		var newFire = Fire.instance()
		newFire.stream = gunSound[g_name]["sound"]
		newFire.volume_db = gunSound[g_name]["volume"]
		
		newFire.pitch_scale = rand_range(0.9, 1.1)
		self.add_child(newFire)
		
		newFire.play()
		
		if (not ignore_timer):
			timer.start()
