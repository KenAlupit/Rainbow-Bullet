extends CanvasLayer

onready var world = get_tree().get_current_scene()
onready var ySort = world.get_node("YSort")

onready var waveController = ySort.get_node("WaveController")
onready var player = get_node("../YSort/Player")
onready var player_buffs = player.get_node("Buff")

onready var stats = get_node("../YSort/Player/Stats")
onready var healthbar = get_node("../MainUI/Healthbar")
onready var healthbarValue = healthbar.get_node("Value")

onready var score = player.get_node("Score")
onready var dashCooldown = player.get_node("DashCooldown")

onready var vignetteMode = false setget set_vignette

onready var vignette = $Vignette
onready var vignetteTween = $Vignette/Tween

onready var dash = $Dash
onready var dashText = $Dash/Text

onready var colorWheel = $ColorWheel

onready var buffImage = $Buff
onready var buffDuration = $Buff/Duration
onready var buffName = $Buff/Name

onready var waveText = $Wave
onready var scoreText = $Score
onready var enemiesLeftText = $EnemiesLeft

func pop_new_equip():
	$NewEquip.pop()

func set_vignette(value):
	vignetteMode = value
	
	vignetteTween.interpolate_property(vignette, "modulate:a", 0 if (not vignetteMode) else 0.35, 0.35 if (not vignetteMode) else 0, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
	vignetteTween.start()

func colorWheel_enabled():
	return colorWheel.enabled

func update_health_bar(value, last_health):
	healthbar.value = value
	healthbarValue.text = String(stats.get_health()) + "/" + String(stats.get_max_health())
	
func update_score(value):
	scoreText.text = "SCORE: " + String(value)
	
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _process(delta):
	var enemies = get_tree().get_nodes_in_group("mobs")
	enemiesLeftText.text = "ENEMIES LEFT: " + String(enemies.size())
	waveText.text = "WAVE: " + String(waveController.wave)
	
	
	if (is_instance_valid(player)):
		var stopped = dashCooldown.is_stopped()

		if (stopped):
			dash.modulate = Color(1, 1, 1, 1)
			dashText.text = "READY!"
		else:
			dash.modulate = Color(.65, .65, .65, 1)
			dashText.text = String(round_to_dec(dashCooldown.time_left, 1)) + "s"
	
	var returning = player_buffs.get_buff()
	var buff = returning[0]
	var timer = returning[1]
	
	# print(buff, (buff.type if (buff) else " No Type"))
	if (buff):
		buffImage.visible = buff.type > 0
		if (buff.type > 0):
			var image = buff.image
			
			buffImage.texture = image
			buffName.text = buff.buff_name
			buffDuration.text = String(round_to_dec(timer.time_left, 1)) + "s"
			buffDuration.text = String(round_to_dec(timer.time_left, 1)) + "s"

func _ready():
	healthbar.max_value = stats.get_max_health()
	
	stats.connect("health_changed", self, "update_health_bar")
	score.connect("score_changed", self, "update_score")
	
	update_score(String(score.score))
	update_health_bar(stats.get_health(), stats.last_health)
