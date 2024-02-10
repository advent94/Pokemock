extends Node

signal loaded(options: Options)

const CONFIG_FILE_PATH: String = "user://config"

var options: Options = Options.new()

func _ready():
	_load()
	
func _load():
	var config = ConfigFile.new()
	var file = config.load(CONFIG_FILE_PATH)

	if file == OK and config.has_section("Options"):
		options.text_speed = config.get_value("Options", "text_speed")
		options.battle_animation = config.get_value("Options", "battle_animation")
		options.battle_style = config.get_value("Options", "battle_style")
	else:
		create_default_config()
	loaded.emit(options)

func create_default_config():
	var _options: Options = Options.new()
	save(_options)
	
func save(_options: Options):
	options = _options
	
	var config = ConfigFile.new()
	
	config.set_value("Options", "text_speed", options.text_speed)
	config.set_value("Options", "battle_animation", options.battle_animation)
	config.set_value("Options", "battle_style", options.battle_style)
	config.save(CONFIG_FILE_PATH)
