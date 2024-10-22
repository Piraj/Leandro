extends CanvasLayer

@onready var resume_button: Button = % ResumeButton
@onready var main: CenterContainer = $MarginContainer / Main
@onready var options: CenterContainer = $MarginContainer / Options
@onready var window_mode_button: OptionButton = % WindowModeButton
@onready var master_volume_slider: HSlider = % MasterVolumeSlider
@onready var sfx_volume_slider: HSlider = % SFXVolumeSlider
@onready var music_volume_slider: HSlider = % MusicVolumeSlider
@onready var back_button: Button = % BackButton
@onready var master_bus = AudioServer.get_bus_index(master_audio_bus_name)
@onready var sfx_bus = AudioServer.get_bus_index(sfx_audio_bus_name)
@onready var music_bus = AudioServer.get_bus_index(music_audio_bus_name)
@onready var window_mode = DisplayServer.window_get_mode()
@export var master_audio_bus_name = "Master"
@export var sfx_audio_bus_name = "SFX"
@export var music_audio_bus_name = "Music"
var config = ConfigFile.new()


func _ready():
	load_config()
	window_mode = DisplayServer.window_get_mode()
	resume_button.grab_focus()
	if window_mode == 3:
		window_mode_button.selected = 0
	elif window_mode == 0:
		window_mode_button.selected = 1

func _process(_delta):
	if options.visible == false:
		if Input.is_action_just_pressed("pause"):
			get_tree().paused = not get_tree().paused
			visible = not visible
			if visible:
				resume_button.grab_focus()
	elif Input.is_action_just_pressed("pause"):
		main.visible = true
		options.visible = false


func _on_resume_button_pressed():
		get_tree().paused = false
		visible = false


func _on_options_button_pressed()->void :
	main.visible = false
	options.visible = true
	window_mode_button.grab_focus()


func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")


func _on_window_mode_button_item_selected(index: int)->void :
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			config.set_value("Display", "window_mode", DisplayServer.window_get_mode())
			config.save("user://config.cfg")
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			config.set_value("Display", "window_mode", DisplayServer.window_get_mode())
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


func _on_back_button_pressed()->void :
	options.visible = false
	main.visible = true
	resume_button.grab_focus()


func load_config():
	config.load("user://config.cfg")
	match config.get_value("Display", "window_mode", 0):
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	window_mode = DisplayServer.window_get_mode()
	master_volume_slider.value = config.get_value("Volume", "master_volume", 1)
	sfx_volume_slider.value = config.get_value("Volume", "sfx_volume", 1)
	music_volume_slider.value = config.get_value("Volume", "music_volume", 1)
