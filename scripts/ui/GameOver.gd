extends Panel

onready var parent = get_parent()

onready var world = get_tree().get_current_scene()
onready var ySort = world.get_node("YSort")

onready var player = ySort.get_node("Player")
onready var waveController = ySort.get_node("WaveController")

onready var score = player.get_node("Score")

onready var waveText = $Wave
onready var scoreText = $Score
onready var tween = $Tween

var opened_once = false

func gameDead():
	if (opened_once): return
	for _i in parent.get_children():
		if (_i != self and _i.get_class() != "CanvasLayer"):
			_i.visible = false
			
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	modulate.a = 0
	waveText.text = "WAVE " + String(waveController.wave)
	scoreText.text = String(score.score)
	
	Engine.time_scale = 0.35
	tween.interpolate_property(self, "modulate:a", 0, 1, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	print("death")
	opened_once = true
	

func _ready():
	player.connect("on_death", self, "gameDead")
