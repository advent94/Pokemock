class_name FilePaths

# TODO: Remove duplicated enum and POKEMON_TO_NUM, replace it with function that returns string
# based on enum with 00 padding.

enum Pokemon { 
	BULBASAUR = 1, CHARMANDER = 4, SQUIRTLE = 7,  RAICHU = 26, VULPIX = 37, GLOOM = 44, MANKEY = 56, POLIWAG = 60, 
	DODUO = 84, GENGAR = 94, HITMONLEE = 106, CHANSEY = 113, JOLTEON = 135, PORYGON = 137, AERODACTYL = 142, 
	SNORLAX = 143,
}

const POKEMON_TO_NUM: Dictionary = {
	Pokemon.BULBASAUR: "001", Pokemon.CHARMANDER: "004", Pokemon.SQUIRTLE: "007", Pokemon.RAICHU: "026",
	Pokemon.VULPIX: "037", Pokemon.GLOOM: "044", Pokemon.MANKEY: "056", Pokemon.POLIWAG: "060",
	Pokemon.DODUO: "084", Pokemon.GENGAR: "094", Pokemon.HITMONLEE: "106", Pokemon.CHANSEY: "113",
	Pokemon.JOLTEON: "135", Pokemon.PORYGON: "137", Pokemon.AERODACTYL: "142", Pokemon.SNORLAX: "143",
}

const ASSETS = "res://assets/"
const SHADERS = "res://shaders/"
const UBER_SHADERS = SHADERS + "uber_shaders/"
const SHADER_MATERIALS = SHADERS + "materials/"
const TEXTURES = ASSETS + "textures/"
const SOUNDS = ASSETS + "sounds/"
const SCENES = "res://scenes/"
const STAGES = SCENES + "stages/"
const COMPONENT_SCENES = SCENES + "components/"
const SFX = SOUNDS + "sfx/"
const BGM = SOUNDS + "bgm/"
const CRIES = SFX + "cries/"
const GENERAL = "general/"
const INTRO = "intro/"
const MENU = "menu/"
const NEW_GAME = "new_game/"
const USER = "user://"

const TEXTURE_FILE_EXT = ".png"
const BGM_EXT = ".mp3"
const SFX_FILE_EXT = ".wav" 
const SCENE_FILE_EXT = ".tscn"
const SHADER_EXT = ".gdshader"
const RESOURCE_EXT = ".tres"

# Config
const CONFIG_FILE_PATH = USER + "config"

# Shader materials
const SPRITE_SHADER_MATERIAL = SHADER_MATERIALS + "sprite" + RESOURCE_EXT

############################################ Stages ################################################

const INTRO_STAGE = STAGES + INTRO + "main" + SCENE_FILE_EXT
const MENU_STAGE = STAGES + MENU + "main" + SCENE_FILE_EXT
const NEW_GAME_STAGE = STAGES + NEW_GAME + "main" + SCENE_FILE_EXT

############################################ Scenes ################################################

# Intro
const COPYRIGHT_SCENE = STAGES + INTRO + "copyright_screen" + SCENE_FILE_EXT
const GAMEFREAK_INTRO_SCENE = STAGES + INTRO + "gamefreak_intro" + SCENE_FILE_EXT
const POKEMON_BATTLE_SCENE = STAGES + INTRO + "pokemon_battle" + SCENE_FILE_EXT
# Menu
const TITLE_SCREEN_SCENE = STAGES + MENU + "title_screen" + SCENE_FILE_EXT
const MENU_SCENE = STAGES + MENU + "menu" + SCENE_FILE_EXT
const OPTIONS_SCENE = STAGES + MENU + "options" + SCENE_FILE_EXT
# New Game
const NEW_GAME_INTRO_SCENE = STAGES + NEW_GAME + "intro" + SCENE_FILE_EXT
const PLAYER_NAMING_SCENE = STAGES + NEW_GAME + "player_naming" + SCENE_FILE_EXT

####################################### Component Scenes ###########################################

# Intro
const TINY_STAR_COMPONENT_SCENE = COMPONENT_SCENES + INTRO + "tiny_star" + SCENE_FILE_EXT
const SHOOTING_STAR_COMPONENT_SCENE = COMPONENT_SCENES + INTRO + "shooting_star" + SCENE_FILE_EXT
const TINY_STAR_FACTORY_COMPONENT_SCENE = COMPONENT_SCENES + INTRO + "tiny_star_factory" + SCENE_FILE_EXT

# Pokemon Battle Sprites
const GENGAR_INTRO_BATTLE_SPRITE = TEXTURES + INTRO + "gengar" + TEXTURE_FILE_EXT
const JIGGLYPUFF_INTRO_BATTLE_SPRITE = TEXTURES + INTRO + "jigglypuff" + TEXTURE_FILE_EXT


# BGM
const TITLE_SCREEN_BGM = BGM + INTRO + "02 - Title Screen" + BGM_EXT
const POKEMON_BATTLE_BGM = BGM + INTRO + "01 - Opening Movie" + BGM_EXT
const NEW_GAME_INTRO_OAK_THEME = ROUTE_24_BGM
const ROUTE_24_BGM = BGM + INTRO + "31 - Route 24" + BGM_EXT

# SFX
const PRESS_AB_SFX = SFX + GENERAL + "SFX_PRESS_AB" + SFX_FILE_EXT

# Intro
const SHOOTING_STAR_SFX = SFX + INTRO + "SFX_SHOOTING_STAR" + SFX_FILE_EXT
const INTRO_CRASH_SFX = SFX + INTRO + "SFX_INTRO_CRASH" + SFX_FILE_EXT
const INTRO_WHOOSH_SFX = SFX + INTRO + "SFX_INTRO_WHOOSH" + SFX_FILE_EXT
const INTRO_RAISE_SFX = SFX + INTRO + "SFX_INTRO_RAISE" + SFX_FILE_EXT
const INTRO_HIP_SFX = SFX + INTRO + "SFX_INTRO_HIP" + SFX_FILE_EXT
const INTRO_HOP_SFX = SFX + INTRO + "SFX_INTRO_HOP" + SFX_FILE_EXT
const INTRO_LUNGE_SFX = SFX + INTRO + "SFX_INTRO_LUNGE" + SFX_FILE_EXT

# Pokemon Cries
const BULBASAUR_CRY = CRIES + POKEMON_TO_NUM[Pokemon.BULBASAUR] + SFX_FILE_EXT
const CHARMANDER_CRY = CRIES + POKEMON_TO_NUM[Pokemon.CHARMANDER] + SFX_FILE_EXT
const SQUIRTLE_CRY = CRIES + POKEMON_TO_NUM[Pokemon.SQUIRTLE] + SFX_FILE_EXT
const RAICHU_CRY = CRIES + POKEMON_TO_NUM[Pokemon.RAICHU] + SFX_FILE_EXT
const VULPIX_CRY = CRIES + POKEMON_TO_NUM[Pokemon.VULPIX] + SFX_FILE_EXT
const GLOOM_CRY = CRIES + POKEMON_TO_NUM[Pokemon.GLOOM] + SFX_FILE_EXT
const MANKEY_CRY = CRIES + POKEMON_TO_NUM[Pokemon.MANKEY] + SFX_FILE_EXT
const POLIWAG_CRY = CRIES + POKEMON_TO_NUM[Pokemon.POLIWAG] + SFX_FILE_EXT
const DODUO_CRY = CRIES + POKEMON_TO_NUM[Pokemon.DODUO] + SFX_FILE_EXT
const GENGAR_CRY = CRIES + POKEMON_TO_NUM[Pokemon.GENGAR] + SFX_FILE_EXT
const HITMONLEE_CRY = CRIES + POKEMON_TO_NUM[Pokemon.HITMONLEE] + SFX_FILE_EXT
const CHANSEY_CRY = CRIES + POKEMON_TO_NUM[Pokemon.CHANSEY] + SFX_FILE_EXT
const JOLTEON_CRY = CRIES + POKEMON_TO_NUM[Pokemon.JOLTEON] + SFX_FILE_EXT
const PORYGON_CRY = CRIES + POKEMON_TO_NUM[Pokemon.PORYGON] + SFX_FILE_EXT
const AERODACTYL_CRY = CRIES + POKEMON_TO_NUM[Pokemon.AERODACTYL] + SFX_FILE_EXT
const SNORLAX_CRY = CRIES + POKEMON_TO_NUM[Pokemon.SNORLAX] + SFX_FILE_EXT

#
# This becomes a valid solution when we fill up whole array:
#const POKEMON_CRY_INDEX: Array[String] = [
#	CRIES + POKEMON_TO_NUM[Pokemon.BULBASAUR] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.CHARMANDER] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.SQUIRTLE] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.RAICHU] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.VULPIX] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.GLOOM] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.MANKEY] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.POLIWAG] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.DODUO] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.GENGAR] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.HITMONLEE] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.CHANSEY] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.JOLTEON] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.PORYGON] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.AERODACTYL] + SFX_FILE_EXT,
#	CRIES + POKEMON_TO_NUM[Pokemon.SNORLAX] + SFX_FILE_EXT,
#]
	
