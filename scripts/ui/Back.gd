extends Button

onready var parent = get_parent()

func _on_Back_pressed():
	parent.visible = false
