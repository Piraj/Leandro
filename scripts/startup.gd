extends Node

var config: ConfigFile = ConfigFile.new()

func _ready() -> void:
	load_config()

func load_config() -> void:
	config.load("user://config.cfg")
	match config.get_value("Display", "window_mode", "Windowed"):
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if config.get_value("Display", "vsync", "true") == "true":
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif config.get_value("Display", "vsync", "true") == "false":
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
