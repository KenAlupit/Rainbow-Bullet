extends "res://scripts/Enemy.gd"
class_name BlinkingEnemy

const Ghost = preload("res://objects/vanity/Ghost.tscn")
const Teleport = preload('res://objects/sound/Teleport.tscn')

const likelihood = 6
const likely_likelihood = 3 # lol

func _init(contents).(contents):
	pass
	
func _start():
	SpriteImage = preload("res://textures/enemy/BlinkingEnemy.png")
	._start()
	
	muzzle.get_node("Timer").wait_time = 3
	type = "Blinking"
	stats.max_health = 15
	sprite.texture = SpriteImage

func _explode_area_connect(area):
	._explode_area_connect(area)
	
	if area.is_in_group("projectiles") and "projectile_owner" in area and area.projectile_owner != Projectile.Type.Enemy:
		var chance = randi() % likelihood
		
		if (chance < likely_likelihood):
			make_ghost()
			dashing = true
			dash.start(0.05)
			
			var n_teleport = Teleport.instance()
			n_teleport.pitch_scale = rand_range(.75, 1.25)
			
			enemy.add_child(n_teleport)
			n_teleport.play()
			
			enemy.global_position = area.global_position + Vector2(rand_range(-200, 200), rand_range(-200, 200))

func _shoot(type, projectile_type, bullet_owner, speed = 500, color = ColorN("blue", 1), intColor = 0, reflection = false, demonic = false, ignore_timer = false):
	muzzle.shoot(type, projectile_type, bullet_owner, 100, Colors.Color_Mode[4], current_color, false, false, false, 5)

func make_ghost():
	var ghost = Ghost.instance()
	world.add_child(ghost)
	
	ghost.global_position = enemy.global_position
	ghost.global_transform = enemy.global_transform
	ghost.texture = sprite.texture
	ghost.modulate = sprite.modulate
	ghost.enemy_start()

func update_process(delta):
	if (dashing):
		make_ghost()
	
	.update_process(delta)
