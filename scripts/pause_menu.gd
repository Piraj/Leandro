extends CanvasLayer

@onready var resume_button: Button = %ResumeButton
@onready var back_button: Button = %BackButton
@onready var pause_menu: CenterContainer = %PauseMenu
@onready var options: CenterContainer = %Options
@onready var window_mode_button: OptionButton = %WindowModeButton
@onready var window_mode_container: HBoxContainer = %WindowMode
@onready var v_sync_container: HBoxContainer = %VSync
var can_pause: bool = true
var config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	Options.window_mode_button = %WindowModeButton
	Options.v_sync_mode_button = %VSyncButton
	Options.pixel_perfect_mode_button = %PixelPerfectButton
	Options.master_volume_slider = %MasterVolumeSlider
	Options.sfx_volume_slider = %SFXVolumeSlider
	Options.music_volume_slider = %MusicVolumeSlider
	Options.load_config()
	if OS.get_name() == "Android":
		window_mode_container.visible = false
		v_sync_container.visible = false
	resume_button.grab_focus()

func _process(_delta: float) -> void:
	if options.visible == false:
		if Input.is_action_just_pressed("pause") && can_pause:
			get_tree().paused = not get_tree().paused
			visible = not visible
			if visible:
				resume_button.grab_focus()
	elif Input.is_action_just_pressed("pause"):
		pause_menu.visible = true
		options.visible = false

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_back_button_pressed() -> void:
	options.visible = false
	pause_menu.visible = true
	resume_button.grab_focus()

func _on_options_button_pressed() -> void:
	pause_menu.visible = false
	options.visible = true
	window_mode_button.grab_focus()

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")

func _on_window_mode_button_item_selected(index: int) -> void:
	Options.handle_window_mode(index)

func _on_v_sync_button_toggled(toggled_on: bool) -> void:
	Options.handle_v_sync_mode(toggled_on)

func _on_pixel_perfect_button_toggled(toggled_on: bool) -> void:
	Options.handle_pixel_perfect_mode(toggled_on)

func _on_master_volume_slider_value_changed(value: float) -> void:
	Options.handle_master_volume(value)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	Options.handle_sfx_volume(value)

func _on_music_volume_slider_value_changed(value: float) -> void:
	Options.handle_music_volume(value)