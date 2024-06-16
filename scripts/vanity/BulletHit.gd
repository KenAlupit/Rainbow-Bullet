# CLORO
extends Sprite

onready var colorMode = $Colors
onready var light = $Light
onready var lightTween = $Light/Tween

func start(intColor):
	var color = Colors.Color_Mode[intColor]
	var tween = get_node("Tween")
	
	light.color = color
	
	lightTween.interpolate_property(light, "color", Color(color.r, color.g, color.b, .5), Color(color.r, color.g, color.b, 0), .25, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", Vector2(.65, .65), scale + Vector2(.5, .5), .25, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate", modulate, Color(color.r, color.g, color.b, 0), .25, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	lightTween.start()
	
func _on_Tween_tween_all_completed():
	queue_free()
