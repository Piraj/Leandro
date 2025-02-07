extends Node

@onready var master_bus: int = AudioServer.get_bus_index(master_audio_bus_name)
@onready var sfx_bus: int = AudioServer.get_bus_index(sfx_audio_bus_name)
@onready var music_bus: int = AudioServer.get_bus_index(music_audio_bus_name)
var master_audio_bus_name: String = "Master"
var sfx_audio_bus_name: String = "SFX"
var music_audio_bus_name: String = "Music"
var window_mode_button: OptionButton
var v_sync_mode_button: CheckButton
var pixel_perfect_mode_button: CheckButton
var master_volume_slider: HSlider
var sfx_volume_slider: HSlider
var music_volume_slider: HSlider
var config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	init_config()

func init_config() -> void:
	config.load("user://config.cfg")
	match config.get_value("Display", "window_mode", "Fullscreen"):
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if config.get_value("Display", "vsync", "false") == "true":
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif config.get_value("Display", "vsync", "false") == "false":
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	if config.get_value("Display", "pixel_perfect", "true") == "true":
		get_tree().root.set_content_scale_stretch(Window.CONTENT_SCALE_STRETCH_INTEGER)
	elif config.get_value("Display", "pixel_perfect", "true") == "false":
		get_tree().root.set_content_scale_stretch(Window.CONTENT_SCALE_STRETCH_FRACTIONAL)
	AudioServer.set_bus_volume_linear(master_bus, config.get_value("Volume", "master_volume", 1))
	AudioServer.set_bus_volume_linear(sfx_bus, config.get_value("Volume", "sfx_volume", 1))
	AudioServer.set_bus_volume_linear(music_bus, config.get_value("Volume", "music_volume", 1))

func load_config() -> void:
	config.load("user://config.cfg")
	var window_mode: String = config.get_value("Display", "window_mode", "Fullscreen")
	if window_mode == "Fullscreen":
		window_mode_button.selected = 0
	elif window_mode == "Windowed":
		window_mode_button.selected = 1
	if config.get_value("Display", "vsync", "false") == "true":
		v_sync_mode_button.button_pressed = true
	elif config.get_value("Display", "vsync", "false") == "false":
		v_sync_mode_button.button_pressed = false
	if config.get_value("Display", "pixel_perfect", "true") == "true":
		pixel_perfect_mode_button.button_pressed = true
	elif config.get_value("Display", "pixel_perfect", "true") == "false":
		pixel_perfect_mode_button.button_pressed = false
	master_volume_slider.set_value_no_signal(config.get_value("Volume", "master_volume", 1))
	sfx_volume_slider.set_value_no_signal(config.get_value("Volume", "sfx_volume", 1))
	music_volume_slider.set_value_no_signal(config.get_value("Volume", "music_volume", 1))	

func handle_window_mode(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			config.set_value("Display", "window_mode", "Fullscreen")
			config.save("user://config.cfg")
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			config.set_value("Display", "window_mode", "Windowed")
			config.save("user://config.cfg")

func handle_v_sync_mode(v_sync: bool) -> void:
	if v_sync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		config.set_value("Display", "vsync", "true")
		config.save("user://config.cfg")
	elif !v_sync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		config.set_value("Display", "vsync", "false")
		config.save("user://config.cfg")

func handle_pixel_perfect_mode(pixel_perfect: bool) -> void:
	if pixel_perfect:
		get_tree().root.set_content_scale_stretch(Window.CONTENT_SCALE_STRETCH_INTEGER)
		config.set_value("Display", "pixel_perfect", "true")
		config.save("user://config.cfg")
	elif !pixel_perfect:
		get_tree().root.set_content_scale_stretch(Window.CONTENT_SCALE_STRETCH_FRACTIONAL)
		config.set_value("Display", "pixel_perfect", "false")
		config.save("user://config.cfg")

func handle_master_volume(value: float) -> void:
	AudioServer.set_bus_volume_linear(master_bus, value)
	config.set_value("Volume", "master_volume", value)
	config.save("user://config.cfg")

func handle_sfx_volume(value: float) -> void:
	AudioServer.set_bus_volume_linear(sfx_bus, value)
	config.set_value("Volume", "sfx_volume", value)
	config.save("user://config.cfg")

func handle_music_volume(value: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus, value)
	config.set_value("Volume", "music_volume", value)
	config.save("user://config.cfg")