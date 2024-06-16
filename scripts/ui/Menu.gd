extends CanvasLayer

onready var creditText = $CreditText
onready var versionText = $VersionText

onready var credits = $Credits
onready var creditTween = $Credits/Tween

onready var buttons = $Buttons
onready var logo = $Logo

func wait(s = 1):
	var t = Timer.new()
	t.set_wait_time(s)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")

func _ready():
	credits.visible = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	yield(wait(1), "completed")
	
	creditTween.interpolate_property(credits, "modulate:a", 1, 0, .35, Tween.TRANS_QUAD, Tween.EASE_OUT)
	creditTween.start()
	
	versionText.text = ProjectSettings.get("application/config/version")


func _on_Tween_tween_all_completed():
	credits.queue_free()
