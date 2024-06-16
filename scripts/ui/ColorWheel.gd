extends TextureRect

onready var player = get_tree().get_current_scene().get_node("YSort/Player")
onready var parent = get_parent()

onready var black = parent.get_node("Black")

onready var Yellow = $Yellow
onready var Blue = $Blue
onready var Green = $Green
onready var Purple = $Purple

onready var tween = $Tween

export var selected = -1;
export var enabled = false setget set_enabled

var last_mouse

func _input(event):
	if (player.dead): return
	var resolution = OS.get_real_window_size()
	
	if (Input.is_action_just_pressed("color_wheel")):
		enabled = true
		
		last_mouse = get_viewport().get_mouse_position()
		get_viewport().warp_mouse(Vector2(resolution.x/2, resolution.y/2))
		set_enabled(enabled)
	if (Input.is_action_just_released("color_wheel")):
		enabled = false
		
		if (selected == -1):
			get_viewport().warp_mouse(last_mouse)
		
		set_enabled(enabled)
		player.current_color = selected
		selected = -1
		print("selected " + String(selected))

func set_enabled(value):
	Engine.time_scale = 0.15 if (value) else 1
	black.enabled = value
	visible = value
	tween.interpolate_property(self, "rect_scale", Vector2(.8, .8), Vector2(1, 1), .12, tween.TRANS_QUAD, tween.EASE_OUT)
	tween.start()
