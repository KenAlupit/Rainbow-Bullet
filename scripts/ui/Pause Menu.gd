extends Control

onready var settings = $Settings
var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		settings.visible = false
		if is_paused == false:
			self.is_paused = !is_paused
		elif is_paused == true:
			get_tree().paused = false
			self.is_paused = false

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Continue_pressed():
	get_tree().paused = false
	self.is_paused = false

func _on_Exit_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	self.is_paused = false
