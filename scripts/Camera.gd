# CLORO
extends Camera2D

onready var player := get_node("../YSort/Player")
onready var topLeft := $TopLeft
onready var bottomRight := $BottomRight

var camera_zoom_types := [
	Vector2(.8, .8),
	Vector2(1, 1),
	Vector2(1.25, 1.25),
	Vector2(1.5, 1.5)
]

export var currentType := 1

func _ready():
	# limit_top = topLeft.position.y
	# limit_left = topLeft.position.x
	# limit_bottom = bottomRight.position.y
	# limit_right = bottomRight.position.x
	pass

func _input(event: InputEvent) -> void:
	if (player.dead): return
	if (event.is_action_pressed("zoom_in")):
		currentType = clamp(currentType-1, 0, 3)
	elif (event.is_action_pressed("zoom_out")):
		currentType = clamp(currentType+1, 0, 3)

func _process(delta: float) -> void:
	var type = camera_zoom_types[currentType]
	if (Input.is_action_pressed("walk")):
		type *= 0.8
		
	zoom = lerp(zoom, type, 5*delta)
	if (is_instance_valid(player)):
		position = lerp(position, player.position, 4*delta)
