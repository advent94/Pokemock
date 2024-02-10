extends Node

enum Scene { INTRO, NAMING }
const SCENE_INDEX : Dictionary = {
	Scene.INTRO: preload(FilePaths.NEW_GAME_INTRO_SCENE),
	Scene.NAMING: preload(FilePaths.PLAYER_NAMING_SCENE),
}

var instance_to_scene_index: Dictionary = {}

func _ready():
	add(Scene.INTRO)

func add(scene: Scene):
	assert(SCENE_INDEX.has(scene), "Couldn't find scene (\"%s\") in scene index." % [Scene.keys()[scene]])
	var instance = SCENE_INDEX[scene].instantiate()
	assert(instance, "Couldn't instantiate a scene (\"%s\")" % Scene.keys()[scene])
	instance_to_scene_index[instance] = scene
	call_deferred("add_child", instance)

func _on_scene_instance_removed(node : Node):
	var scene: Scene = instance_to_scene_index[node]
	match scene:
		Scene.INTRO:
			add(Scene.NAMING)
