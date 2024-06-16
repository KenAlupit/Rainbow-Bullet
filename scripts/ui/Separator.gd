extends Panel

export(String) var groupName = ""

onready var label = $Label

func _ready():
	label.text = groupName
