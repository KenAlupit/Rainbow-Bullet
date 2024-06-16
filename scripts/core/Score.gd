extends Node

export var score = 0
var max_score = 1e10

signal score_changed(value);

export var score_template = {
	enemy_kill = 200,
	bullet = 15
}

func increment(num = 25):
	score += num
	emit_signal("score_changed", score)

func decrement(num = 25):
	score -= num
	emit_signal("score_changed", score)

func set_score(num = 0):
	score = num
	emit_signal("score_changed", score)

