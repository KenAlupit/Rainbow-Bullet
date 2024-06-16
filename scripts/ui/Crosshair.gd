extends Sprite

func _process(delta):
	if get_tree().paused == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		position = get_global_mouse_position()
	elif get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
