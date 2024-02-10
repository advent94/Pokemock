extends Node

enum Scene { COPYRIGHT, GAMEFREAK_INTRO, POKEMON_BATTLE }

const SCENE_INDEX : Dictionary = {
	Scene.COPYRIGHT: preload("res://scenes/intro/copyright_screen.tscn"),
	Scene.GAMEFREAK_INTRO: preload("res://scenes/intro/gamefreak_intro.tscn"),
	Scene.POKEMON_BATTLE: preload("res://scenes/intro/pokemon_battle.tscn")
}

var instance_to_scene_index : Dictionary = {}

func _ready():
	add(Scene.COPYRIGHT)

func add(scene: Scene):
	assert(SCENE_INDEX.has(scene), "Couldn't find scene (\"%s\") in scene index." % [Scene.keys()[scene]])
	var instance = SCENE_INDEX[scene].instantiate()
	assert(instance, "Couldn't instantiate a scene (\"%s\")" % Scene.keys()[scene])
	instance_to_scene_index[instance] = scene
	call_deferred("add_child", instance)

	
func _on_scene_instance_removed(node : Node):
	var scene: Scene = instance_to_scene_index[node]
	match scene:
		Scene.COPYRIGHT:
			add(Scene.GAMEFREAK_INTRO)
		Scene.GAMEFREAK_INTRO:
			add(Scene.POKEMON_BATTLE)
		Scene.POKEMON_BATTLE:
			queue_free()
