extends Panel

export var enabled = false setget _on_set

onready var tween = $Tween

func _on_set(value):
	visible = value
	tween.interpolate_property(self, "modulate", Color(0, 0, 0, 0), Color(0, 0, 0, .6), .25, tween.TRANS_QUAD, tween.EASE_OUT)
	tween.start()
