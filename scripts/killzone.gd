extends Area2D

@onready var game_over_label: Label = %GameOverLabel
var game_over: bool


func _process(_delta: float) -> void:
	if game_over:
		if Input.is_anything_pressed():
			Engine.time_scale = 1
			get_tree().reload_current_scene()

func _on_body_entered(body: Node2D) -> void:
	game_over_label.visible = true
	if body.has_method("death"):
		body.death()
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	await get_tree().create_timer(1).timeout
	game_over = true
