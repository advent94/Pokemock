extends Node

enum Scene { TITLE_SCREEN, MENU, OPTIONS, NEW_GAME}

const SCENE_INDEX : Dictionary = {
	Scene.TITLE_SCREEN: preload("res://scenes/intro/title_screen.tscn"),
	Scene.MENU: preload("res://scenes/main/new_game_menu.tscn"),
	Scene.OPTIONS: preload("res://scenes/main/options.tscn"),
	Scene.NEW_GAME: preload("res://scenes/main/new_game.tscn"),
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
	scene_to_instance_index[Scene.TITLE_SCREEN].started.connect(play_bgm)
		
func add_menu():
	add(Scene.MENU)
	scene_to_instance_index[Scene.MENU].selected.connect(on_select)
	scene_to_instance_index[Scene.MENU].returned.connect(add_title_screen)

enum Option { NEW_GAME, OPTIONS }

func on_select(option: Option):
	match option:
		Option.NEW_GAME:
			add(Scene.NEW_GAME)
		Option.OPTIONS:
			add(Scene.OPTIONS)
	
func play_bgm():
	$BGM.stop()
	$BGM.play()

func _on_scene_instance_removed(node : Node):
	if instance_to_scene_index.has(node):
		var scene: Scene = instance_to_scene_index[node]
		match scene:
			Scene.TITLE_SCREEN, Scene.OPTIONS:
				add_menu()
