extends Control

@onready var start_game_button: Button = % StartGameButton
@onready var quit_button: Button = % QuitButton
@onready var options: CenterContainer = $Options
@onready var main: CenterContainer = $Main
@onready var window_mode_button: OptionButton = % WindowModeButton
@onready var master_volume_slider: HSlider = % MasterVolumeSlider
@onready var sfx_volume_slider: HSlider = % SFXVolumeSlider
@onready var music_volume_slider: HSlider = % MusicVolumeSlider
@onready var master_bus: int = AudioServer.get_bus_index(master_audio_bus_name)
@onready var sfx_bus: int = AudioServer.get_bus_index(sfx_audio_bus_name)
@onready var music_bus: int = AudioServer.get_bus_index(music_audio_bus_name)
@export var master_audio_bus_name: String= "Master"
@export var sfx_audio_bus_name: String = "SFX"
@export var music_audio_bus_name: String = "Music"
var config = ConfigFile.new()


func _ready()->void :
	load_config()
	start_game_button.grab_focus()

func _process(_delta):
	if options.visible:
		if Input.is_action_just_pressed("pause"):
			main.visible = true
			options.visible = false

func _on_start_game_button_pressed()->void :
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

func _on_options_button_pressed()->void :
	main.visible = false
	options.visible = true
	window_mode_button.grab_focus()

func _on_quit_button_pressed()->void :
	get_tree().quit()

func _on_back_button_pressed()->void :
	options.visible = false
	main.visible = true
	start_game_button.grab_focus()

func _on_window_mode_button_item_selected(index: int)->void :
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			config.set_value("Display", "window_mode", "Fullscreen")
			config.save("user://config.cfg")
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			config.set_value("Display", "window_mode", "Windowed")
			config.save("user://config.cfg")

func _on_master_volume_slider_value_changed(value: float)->void :
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
	config.set_value("Volume", "master_volume", value)
	config.save("user://config.cfg")

func _on_sfx_volume_slider_value_changed(value: float)->void :
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	config.set_value("Volume", "sfx_volume", value)
	config.save("user://config.cfg")

func _on_music_volume_slider_value_changed(value: float)->void :
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	config.set_value("Volume", "music_volume", value)
	config.save("user://config.cfg")

func load_config():
	config.load("user://config.cfg")
	var window_mode: String = config.get_value("Display", "window_mode", "Windowed")
	if window_mode == "Fullscreen":
		window_mode_button.selected = 0
	elif window_mode == "Windowed":
		window_mode_button.selected = 1
	master_volume_slider.value = config.get_value("Volume", "master_volume", 1)
	sfx_volume_slider.value = config.get_value("Volume", "sfx_volume", 1)
	music_volume_slider.value = config.get_value("Volume", "music_volume", 1)
