extends Label

export var color_code = 1
onready var tween = $Tween
onready var parent = get_parent()

func _on_Yellow_mouse_entered():
	parent.selected = color_code
	tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(1.25, 1.25), .25, tween.TRANS_QUAD, tween.EASE_OUT)
	tween.start()

func _on_Yellow_mouse_exited():
	parent.selected = -1
	tween.interpolate_property(self, "rect_scale", Vector2(1.25, 1.25), Vector2(1, 1), .25, tween.TRANS_QUAD, tween.EASE_OUT)
	tween.start()
