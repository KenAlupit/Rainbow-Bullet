extends Button

onready var menu = get_parent().get_parent()
onready var settings = menu.get_node("Settings")

func _on_Settings_pressed():
	settings.visible = true
