extends Control


@export var start_game_button: Button
@export var main: MarginContainer
@export var options: MarginContainer
@export var window_mode_button: OptionButton
@export var window_mode_container: HBoxContainer
@export var vsync_mode_button: CheckButton
@export var vsync_container: HBoxContainer
@export var pixel_perfect_mode_button: CheckButton
@export var master_volume_slider: HSlider
@export var sfx_volume_slider: HSlider
@export var music_volume_slider: HSlider

var config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	Options.window_mode_button = window_mode_button
	Options.vsync_mode_button = vsync_mode_button
	Options.pixel_perfect_mode_button = pixel_perfect_mode_button
	Options.master_volume_slider = master_volume_slider
	Options.sfx_volume_slider = sfx_volume_slider
	Options.music_volume_slider = music_volume_slider
	Options.load_config()

	if OS.has_feature("mobile"):
		window_mode_container.visible = false
		vsync_container.visible = false
	
	start_game_button.grab_focus()

func _process(_delta: float) -> void:
	if options.visible:
		if Input.is_action_just_pressed("pause"):
			main.visible = true
			options.visible = false

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

func _on_options_button_pressed() -> void:
	main.visible = false
	options.visible = true
	window_mode_button.grab_focus()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	options.visible = false
	main.visible = true
	start_game_button.grab_focus()

func _on_window_mode_button_item_selected(index: int) -> void:
	Options.handle_window_mode(index)
	
func _on_vsync_button_toggled(toggled_on: bool) -> void:
	Options.handle_vsync_mode(toggled_on)

func _on_pixel_perfect_button_toggled(toggled_on: bool) -> void:
	Options.handle_pixel_perfect_mode(toggled_on)

func _on_master_volume_slider_value_changed(value: float) -> void:
	Options.handle_master_volume(value)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	Options.handle_sfx_volume(value)

func _on_music_volume_slider_value_changed(value: float) -> void:
	Options.handle_music_volume(value)
