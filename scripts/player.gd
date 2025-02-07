class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var hurt_audio: AudioStreamPlayer2D = $HurtAudio
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_jump_timer: Timer = $BufferJumpTimer
@export var speed: int = 130
@export var jump_velocity: int = -300
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping: bool = false
var should_jump: bool = false
var can_move: bool = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if can_move:
		handle_jump()
		flip_sprite()
		play_animations()
		apply_movement()
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	var just_left_ledge: bool = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_timer.start()

func handle_jump() -> void:
	if is_on_floor() and velocity.y >= 0:
		jumping = false
	if Input.is_action_just_pressed("jump") and jumping:
		buffer_jump()
	if should_jump and !jumping:
		jump()
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left > 0.0):
		jump()
		
func jump() -> void:
	velocity.y = jump_velocity
	jumping = true
	should_jump = false
	jump_audio.play()
	
func buffer_jump() -> void:
	should_jump = true
	buffer_jump_timer.start()
	await buffer_jump_timer.timeout
	should_jump = false
	
func play_animations() -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else :
			animated_sprite.play("run")
	else :
		animated_sprite.play("jump")
	if direction == 0:
		animated_sprite.play("idle")
	else :
		animated_sprite.play("run")
		
func flip_sprite() -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
func apply_movement() -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else :
		velocity.x = move_toward(velocity.x, 0, speed)
		
func death() -> void:
	hurt_audio.play()
	can_move = false
	animated_sprite.play("idle")
	animated_sprite.stop()
	velocity = Vector2.ZERO
	velocity.y = move_toward(velocity.y, 20, speed)
	
func end_level() -> void:
	can_move = false
	while velocity.x > 0:
		await get_tree().create_timer(get_physics_process_delta_time()).timeout
		velocity.x = move_toward(velocity.x, 0, 2)
	animated_sprite.play("idle")
	animated_sprite.stop()
	
