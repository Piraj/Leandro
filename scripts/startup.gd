extends Node

var config = ConfigFile.new()

func _ready()->void :
	load_config()

func load_config():
	config.load("user://config.cfg")
	match config.get_value("Display", "window_mode", "Windowed"):
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
