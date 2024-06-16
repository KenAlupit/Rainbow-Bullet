extends Sprite

onready var player = get_parent()

onready var vanitySprite = player.get_node("VanitySprite")
onready var vanityTween = vanitySprite.get_node("Tween")

onready var buffLight = player.get_node("BuffLight")

onready var tween = $Tween


func pop():
	visible = true
	modulate.s = 1
	
	tween.interpolate_property(self, "scale", Vector2(12, 12), Vector2(2, 2), .35, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:h", 0, 1, .35, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", .5, 0, .35, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	vanitySprite.rainbow_pop()
	buffLight.pop()
	tween.start()

func _on_Tween_tween_all_completed():
	visible = false
