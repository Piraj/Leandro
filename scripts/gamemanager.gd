extends Node

var score = 0
@onready var score_label = $ScoreLabel
@onready var score_hud_label: Label = $CanvasLayer/ScoreHUDLabel


func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."
	score_hud_label.text = "Coins: " + str(score)
