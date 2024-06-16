extends CanvasLayer
class_name Indicators

const Damage = preload("res://objects/ui/Damage.tscn")

func make_damage_indicator(amount, less, position):
	var damage = Damage.instance()
	add_child(damage)
	
	damage.rect_position = position - (Vector2(110, 64) + Vector2(rand_range(-32, 32), rand_range(-32, 32)))
	damage.pop(amount, less)
