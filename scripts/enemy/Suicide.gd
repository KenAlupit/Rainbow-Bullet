extends "res://scripts/Enemy.gd"
class_name SuicideEnemy

const Ghost = preload("res://objects/vanity/Ghost.tscn")
const Explode = preload("res://objects/sound/Explode.tscn")

const likelihood = 6
const likely_likelihood = 3 # lol

func _init(contents).(contents):
	pass

func _start():
	._start()
	SpriteImage = preload("res://textures/enemy/SuicideBomber.png")
	
	type = "Suicide"
	max_speed = 400
	stats.max_health = 30
	sprite.texture = SpriteImage

func _chase(delta):
	_accelerate_towards_point(player.global_position, delta)
	if seen_player != false:
		if player.global_position.distance_to(enemy.global_position) <= 80:
			blood_instance.set_spread(180)
			blood_instance.scale_amount_random = .75
			blood_instance.lifetime_randomness = .85 
			blood_instance.amount = 512
			blood_instance.color.a = .35
			_blood()
			player.stats.health -= 3
			var n_explode = Explode.instance()
			n_explode.pitch_scale = rand_range(.8, 1.2)
			
			enemy.add_child(n_explode)
			n_explode.play()
			
			if enemies_around != null:
				for n in enemies_around:
					if is_instance_valid(n):
						n.enemy.sprite.set_modulate(Colors.Color_Mode[current_color]) 
						n.enemy.current_color = current_color
	
	if player_detection._can_see_player():
		enemy.look_at(player_detection.player.global_position)

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
