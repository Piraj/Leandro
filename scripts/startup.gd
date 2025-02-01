extends Node

@onready var master_bus: int = AudioServer.get_bus_index(master_audio_bus_name)
@onready var sfx_bus: int = AudioServer.get_bus_index(sfx_audio_bus_name)
@onready var music_bus: int = AudioServer.get_bus_index(music_audio_bus_name)
@export var master_audio_bus_name: String = "Master"
@export var sfx_audio_bus_name: String = "SFX"
@export var music_audio_bus_name: String = "Music"
var config: ConfigFile = ConfigFile.new()

func _ready() -> void:
	load_config()

func load_config() -> void:
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
	AudioServer.set_bus_volume_linear(master_bus, config.get_value("Volume", "master_volume", 1))
	AudioServer.set_bus_volume_linear(sfx_bus, config.get_value("Volume", "sfx_volume", 1))
	AudioServer.set_bus_volume_linear(music_bus, config.get_value("Volume", "music_volume", 1))
