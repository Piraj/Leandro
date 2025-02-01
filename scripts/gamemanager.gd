extends Node

var score: int = 0
@onready var score_label: Label = $ScoreLabel
@onready var score_hud_label: Label = $CanvasLayer/ScoreHUDLabel


func add_point() -> void:
	score += 1
	score_label.text = "You collected " + str(score) + " coins."
	score_hud_label.text = "Coins: " + str(score)
