extends MovingSprite

class_name PokemonBattleSprite

@export var pokemon : Pokemon = Pokemon.GENGAR

enum Pokemon { JIGGLYPUFF, GENGAR }

const TEXTURE_FILE_PATHS: Dictionary = {
	Pokemon.GENGAR: FilePaths.GENGAR_INTRO_BATTLE_SPRITE,
	Pokemon.JIGGLYPUFF: FilePaths.JIGGLYPUFF_INTRO_BATTLE_SPRITE, 
}
	
func _ready():
	_load_texture()
	
func _load_texture():
	assert(TEXTURE_FILE_PATHS.size() == Pokemon.size(), "Not every battle sprie has a texture.")
	texture = load(TEXTURE_FILE_PATHS[pokemon])
	assert(texture, "Couldn't load texture (%s)" % TEXTURE_FILE_PATHS[pokemon])

enum FrameType { IDLE, ANTICIPATION, ATTACK }

func change_frame(_frame: FrameType):
	frame = _frame
