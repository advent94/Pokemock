extends Node

# TODO: Make it a class, make it generic

enum Scene { INTRO, MENU }
const SCENE_INDEX : Dictionary = {
	Scene.INTRO: preload(FilePaths.INTRO_STAGE),
	Scene.MENU: preload(FilePaths.MENU_STAGE),
}

var instance_to_scene_index: Dictionary = {}

func _ready():
	add(Scene.INTRO)

func add(scene: Scene):
	Log.assertion(SCENE_INDEX.has(scene), "Couldn't find scene (\"%s\") in scene index." % [Scene.keys()[scene]])
	var instance = SCENE_INDEX[scene].instantiate()
	Log.assertion(instance != null, "Couldn't instantiate a scene (\"%s\")" % Scene.keys()[scene])
	instance_to_scene_index[instance] = scene
	call_deferred("add_child", instance)

func _on_scene_instance_removed(node : Node):
	var scene: Scene = instance_to_scene_index[node]
	match scene:
		Scene.INTRO:
			add(Scene.MENU)
