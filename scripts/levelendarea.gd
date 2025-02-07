extends Area2D

@onready var game_manager:Node = %GameManager
@onready var level_completed_label:Label = %LevelEndLabel
var level_ended:bool


func _process(_delta: float) -> void:
	if level_ended:
		if Input.is_anything_pressed():
			get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")

func _on_body_entered(body:Node2D) -> void:
	if body.has_method("end_level"):
		body.end_level()
	level_completed_label.visible = true
	await get_tree().create_timer(1.0).timeout
	level_ended = true
	
