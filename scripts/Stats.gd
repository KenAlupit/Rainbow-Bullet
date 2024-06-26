extends Node

export(int) var max_health = 1 setget set_max_health, get_max_health
export(int) var last_health = 0
var health = max_health setget set_health, get_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	last_health = health
	health = value
	emit_signal("health_changed", health, last_health)
	if health <= 0:
		emit_signal("no_health")

func get_health():
	return health

func get_max_health():
	return max_health

func _ready():
	self.health = max_health
