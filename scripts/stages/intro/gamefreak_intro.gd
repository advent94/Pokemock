extends AnimatedSprite2D

enum Scene { SHOOTING_STAR, TINY_STAR_FACTORY }
enum FrameType { GAME_FREAK_LOGO_FRAME_ID = 1 }

const SCENE_INDEX : Dictionary = {
	Scene.SHOOTING_STAR: preload(FilePaths.SHOOTING_STAR_COMPONENT_SCENE),
	Scene.TINY_STAR_FACTORY: preload(FilePaths.TINY_STAR_FACTORY_COMPONENT_SCENE),
}

var scene_to_instance_index : Dictionary = {}

func _on_frame_changed():
	match frame:
		FrameType.GAME_FREAK_LOGO_FRAME_ID: 
			pause()
			_spawn_shooting_star()
			$Input.activate()

func _spawn_shooting_star():
	add(Scene.SHOOTING_STAR)
	scene_to_instance_index[Scene.SHOOTING_STAR].left_screen.connect(_on_shooting_star_left_screen)

const TIME_BEFORE_CREATING_TINY_STARS: float = 0.7

func _on_shooting_star_left_screen():
	await Functions.wait(TIME_BEFORE_CREATING_TINY_STARS)
	_create_tiny_stars()
	play()
		
func _create_tiny_stars():
	add(Scene.TINY_STAR_FACTORY)
	scene_to_instance_index[Scene.TINY_STAR_FACTORY].tiny_stars_created.connect(_on_tiny_stars_created)
	
const TIME_BEFORE_END: float = 1
	
func _on_tiny_stars_created():
	await Functions.wait(TIME_BEFORE_END)
	_end()
	
func add(scene: Scene):
	assert(SCENE_INDEX.has(scene), "Couldn't find scene (\"%s\") in scene index." % [Scene.keys()[scene]])
	var instance = SCENE_INDEX[scene].instantiate()
	assert(instance, "Couldn't instantiate a scene (\"%s\")" % Scene.keys()[scene])
	scene_to_instance_index[scene] = instance
	add_child(scene_to_instance_index[scene])
	
func _end():
	queue_free()
