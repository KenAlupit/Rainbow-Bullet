extends Label

const NewEquip = preload("res://objects/sound/NewPickup.tscn")

onready var tween = $Tween
var h = 0

func pop():
	visible = true
	modulate.a = 1
	
	var ne_sound = NewEquip.instance()
	get_parent().add_child(ne_sound)
	ne_sound.play()

	yield(get_tree().create_timer(3), "timeout")
	tween.interpolate_property(self, "modulate:a", 1, 0, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()
	
func _process(delta):
	modulate.h = h
	modulate.s = 1
	
	if (h < 1):
		h += 0.001
	else:
		h = 0

func _on_Tween_tween_all_completed():
	visible = false
