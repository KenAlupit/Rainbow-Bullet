extends Light2D

onready var tween = $Tween

func pop():
	tween.interpolate_property(self, "color:a", .25, 0, 1.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "color:h", 0, 1, 1.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "texture_scale", 2, 1.25,.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()
