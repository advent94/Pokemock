extends Node

enum Scene { TITLE_SCREEN, MENU, OPTIONS, NEW_GAME}

const TITLE_SCREEN_BGM = preload(FilePaths.TITLE_SCREEN_BGM)

const SCENE_INDEX : Dictionary = {
	Scene.TITLE_SCREEN: preload(FilePaths.TITLE_SCREEN_SCENE),
	Scene.MENU: preload(FilePaths.MENU_SCENE),
	Scene.OPTIONS: preload(FilePaths.OPTIONS_SCENE),
	Scene.NEW_GAME: preload(FilePaths.NEW_GAME_STAGE),
}

var instance_to_scene_index : Dictionary = {}
var scene_to_instance_index : Dictionary = {}

func _ready():
	add_title_screen()

func add(scene: Scene):
	assert(SCENE_INDEX.has(scene), "Couldn't find scene (\"%s\") in scene index." % [Scene.keys()[scene]])
	var instance = SCENE_INDEX[scene].instantiate()
	assert(instance, "Couldn't instantiate a scene (\"%s\")" % Scene.keys()[scene])
	instance_to_scene_index[instance] = scene
	scene_to_instance_index[scene] = instance
	call_deferred("add_child", instance)

func add_title_screen():
	add(Scene.TITLE_SCREEN)
		
func add_menu():
	add(Scene.MENU)
	scene_to_instance_index[Scene.MENU].selected.connect(on_select)
	scene_to_instance_index[Scene.MENU].returned.connect(add_title_screen)

const NEW_GAME_INTRO_BGM: AudioStream = preload(FilePaths.NEW_GAME_INTRO_OAK_THEME)

func start_new_game():
	Audio.play_bgm(NEW_GAME_INTRO_BGM)
	add(Scene.NEW_GAME)
	
enum Option { NEW_GAME, OPTIONS }

func on_select(option: Option):
	match option:
		Option.NEW_GAME:
			start_new_game()
		Option.OPTIONS:
			add(Scene.OPTIONS)

func _on_scene_instance_removed(node : Node):
	if instance_to_scene_index.has(node):
		var scene: Scene = instance_to_scene_index[node]
		match scene:
			Scene.TITLE_SCREEN, Scene.OPTIONS:
				add_menu()
