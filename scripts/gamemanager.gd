extends Node

var score:int = 0
@onready var score_hud_label:Label = %ScoreHUDLabel


func add_point() -> void:
	score += 1
	score_hud_label.text = "Coins: " + str(score)
