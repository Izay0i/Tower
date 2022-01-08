extends Node

const FILE_PATH = "user://highscore.cfg"

var tutorial_highscore : int
var swamp_highscore : int
var factory_highscore : int
var castle_highscore : int

func save_highscores(tutorial, swamp, factory, castle):
	print("Saving highscores to config file")
	
	var cfg_file = ConfigFile.new()
	cfg_file.set_value("Highscores", "tutorial", tutorial)
	cfg_file.set_value("Highscores", "swamp", swamp)
	cfg_file.set_value("Highscores", "factory", factory)
	cfg_file.set_value("Highscores", "castle", castle)
	
	if cfg_file.save(FILE_PATH) != OK:
		print("Failed to save data to config")

func load_highscores():
	print("Loading config file")
	
	var cfg_file = ConfigFile.new()
	if cfg_file.load(FILE_PATH) != OK:
		print("Config file not found. Creating a new file.")
		save_highscores(0, 0, 0, 0)
	
	if cfg_file.has_section("Highscores"):
		print("Data found")
	
		tutorial_highscore = cfg_file.get_value("Highscores", "tutorial")
		swamp_highscore = cfg_file.get_value("Highscores", "swamp")
		factory_highscore = cfg_file.get_value("Highscores", "factory")
		castle_highscore = cfg_file.get_value("Highscores", "castle")
	
	print("Loading successful")
