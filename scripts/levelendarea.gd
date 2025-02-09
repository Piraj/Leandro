extends Area2D

@export var game_manager: Node
@export var pause_menu: CanvasLayer
@onready var level_completed_label: Label = %LevelEndLabel
@onready var coin_count: int = get_tree().get_node_count_in_group("coins")
var level_ended: bool


func _process(_delta: float) -> void:
	if level_ended:
		if Input.is_anything_pressed():
			get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")

func _on_body_entered(body: Node2D) -> void:
	pause_menu.can_pause = false
	if body.has_method("end_level"):
		body.end_level()
	level_completed_label.text = "Level Completed\n You collected " + str(game_manager.score) + "/" + str(coin_count) + " coins\n Press any key to return to main menu"
	level_completed_label.visible = true
	await get_tree().create_timer(1.0).timeout
	level_ended = true
	
