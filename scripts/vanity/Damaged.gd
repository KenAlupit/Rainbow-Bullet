extends Sprite

onready var parent = get_parent()
onready var sprite = parent.get_node("Sprite")

onready var tween = $Tween

func _start():
	texture = sprite.texture
	modulate = ColorN("red", 0)

func _pop():
	tween.interpolate_property(self, "modulate", ColorN("red", 1), ColorN("red", 0), .45, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

