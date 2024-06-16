extends Sprite

onready var tween = $Tween

func white_pop():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.25, Tween.TRANS_QUAD, Tween.EASE_IN)

	tween.start()

func rainbow_pop():
	modulate.s = 1
	tween.interpolate_property(self, "modulate:h", 0, 1, 1.25, Tween.TRANS_QUAD, Tween.EASE_IN)

	tween.start()
