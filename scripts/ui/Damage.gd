extends Label

onready var tween = $Tween

func pop(amount, less):
	var text_candy = "+" if (less == "great") else "-"
	add_color_override("font_color", Color(0, 1, 0, 1) if (less == "great") else Color(1, 0, 0, 1))
	
	text = text_candy + String(amount)
	
	tween.interpolate_property(self, "modulate:a", 1, 0, 1.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "rect_position", rect_position, rect_position + Vector2(0, -5), 1.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()

func _on_Tween_tween_all_completed():
	queue_free()
