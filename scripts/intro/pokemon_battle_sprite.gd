extends "res://scripts/utils/moving_sprite.gd"

@export var pokemon : Pokemon = Pokemon.GENGAR

enum Pokemon { JIGGLYPUFF, GENGAR }

const TEXTURE_PATH: String = ("res://assets/textures/intro/")
const TEXTURE_FILE_EXT: String = (".png")

const TEXTURE_FILE_PATHS: Dictionary = {
	Pokemon.GENGAR: TEXTURE_PATH + "gengar" + TEXTURE_FILE_EXT,
	Pokemon.JIGGLYPUFF: TEXTURE_PATH + "jigglypuff" + TEXTURE_FILE_EXT, 
}

const INTRO_SFX_PATH: String = "res://assets/sounds/sfx/intro/" 
const SFX_FILE_EXTENSION: String = ".wav" 
	
func _ready():
	_load_texture()
	
func _load_texture():
	assert(TEXTURE_FILE_PATHS.size() == Pokemon.size(), "Not every battle sprie has a texture.")
	texture = load(TEXTURE_FILE_PATHS[pokemon])
	assert(texture, "Couldn't load texture (%s)" % TEXTURE_FILE_PATHS[pokemon])

enum FrameType { IDLE, ANTICIPATION, ATTACK }

func change_frame(_frame: FrameType):
	frame = _frame
