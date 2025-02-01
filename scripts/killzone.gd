extends Area2D

@onready var timer: Timer = $Timer
@onready var game_over_label: Label = %GameOverLabel


func _on_body_entered(body: Object) -> void:
	game_over_label.visible = true
	if body.has_method("death"):
		body.death()
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
