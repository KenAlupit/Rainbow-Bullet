extends KinematicBody2D
export var type = []

var enemy

export onready var stats = $Stats
onready var world = get_tree().get_current_scene()

func _ready():
	enemy = type[0].new({
		"enemy": self,
		"world": world,
		"player_detection": $PlayerDetection,
		"muzzle": $Muzzle,
		"time": $Muzzle/Timer,
		"ray": $RayCast2D,
		"stats": stats,
		"sprite": $Sprite,
		"color_mode": $Colors,
		"dash": $Dash,
		"damaged": $Damaged,
		
		"wander_controller": $WanderController,
		
		"player": type[1],
		"score": type[1].get_node("Score"),
		
		"hurtbox": $HurtBox,
		"explode": $Explode
	})
	
	enemy.call_deferred("_start")

func _physics_process(delta):
	enemy.update_physics_process(delta)

func _process(delta):
	enemy.update_process(delta)
	
func kill():
	enemy._kill()
