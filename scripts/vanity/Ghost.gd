extends Sprite

onready var tween = $Tween

func start():
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.5, tween.TRANS_QUAD, tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	queue_free()

func enemy_start():
	tween.interpolate_property(self, "modulate:a", 0.25, 0, 0.5, tween.TRANS_QUAD, tween.EASE_OUT)
	tween.start()
