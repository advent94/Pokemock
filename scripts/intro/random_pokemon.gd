extends "res://scripts/utils/moving_sprite.gd"

signal starter_switch
signal switch_started
signal switch_finished
signal started

enum Pokemon { 
	BULBASAUR = 1, CHARMANDER = 4, SQUIRTLE = 7,  RAICHU = 26, VULPIX = 37, GLOOM = 44, MANKEY = 56, POLIWAG = 60, 
	DODUO = 84, GENGAR = 94, HITMONLEE = 106, CHANSEY = 113, JOLTEON = 135, PORYGON = 137, AERODACTYL = 142, 
	SNORLAX = 143,
}

const AVAILABLE_POKEMON: Array[Pokemon] = [
	Pokemon.BULBASAUR, Pokemon.CHARMANDER, Pokemon.SQUIRTLE,  Pokemon.RAICHU, Pokemon.VULPIX, Pokemon.GLOOM, 
	Pokemon.MANKEY, Pokemon.POLIWAG, Pokemon.DODUO, Pokemon.GENGAR, Pokemon.HITMONLEE, Pokemon.CHANSEY, 
	Pokemon.JOLTEON, Pokemon.PORYGON, Pokemon.AERODACTYL, Pokemon.SNORLAX,	
]

const CRIES: Dictionary = {
	Pokemon.BULBASAUR: preload("res://assets/sounds/sfx/cries/001.wav"),
	Pokemon.CHARMANDER: preload("res://assets/sounds/sfx/cries/004.wav"),
	Pokemon.SQUIRTLE: preload("res://assets/sounds/sfx/cries/007.wav"),  
	Pokemon.RAICHU: preload("res://assets/sounds/sfx/cries/026.wav"),
	Pokemon.VULPIX: preload("res://assets/sounds/sfx/cries/037.wav"),
	Pokemon.GLOOM: preload("res://assets/sounds/sfx/cries/044.wav"),
	Pokemon.MANKEY: preload("res://assets/sounds/sfx/cries/056.wav"),
	Pokemon.POLIWAG: preload("res://assets/sounds/sfx/cries/060.wav"),
	Pokemon.DODUO: preload("res://assets/sounds/sfx/cries/084.wav"),
	Pokemon.GENGAR: preload("res://assets/sounds/sfx/cries/094.wav"),
	Pokemon.HITMONLEE: preload("res://assets/sounds/sfx/cries/106.wav"),
	Pokemon.CHANSEY: preload("res://assets/sounds/sfx/cries/113.wav"),
	Pokemon.JOLTEON: preload("res://assets/sounds/sfx/cries/135.wav"),
	Pokemon.PORYGON: preload("res://assets/sounds/sfx/cries/137.wav"),
	Pokemon.AERODACTYL: preload("res://assets/sounds/sfx/cries/142.wav"),
	Pokemon.SNORLAX: preload("res://assets/sounds/sfx/cries/143.wav"),
}

const STARTERS: Array[Pokemon] = [
	Pokemon.BULBASAUR, Pokemon.CHARMANDER, Pokemon.SQUIRTLE
]

var current_pokemon: Pokemon = Pokemon.SQUIRTLE
func switch():
	switch_started.emit()
	$SwitchTimer.stop()
	_move_outside_left_border()
	if _is_starter():
		starter_switch.emit()
	var offset_outside_right_border: Vector2 = -(_get_outside_left_border_offset() * 2)
	move(offset_outside_right_border, Constants.NOW)
	await Functions.wait_if_blocked(self)
	await roll_new()
	var offset_from_right_border_to_final: Vector2 = -(position - FINAL_RANDOM_POKEMON_POSITION)
	move(offset_from_right_border_to_final, TIME_TO_SWITCH_POKEMON/8)
	await Functions.wait_if_blocked(self)
	switch_finished.emit()
	$SwitchTimer.start()

const FINAL_RANDOM_POKEMON_POSITION: Vector2 = Vector2(69, 108)
const TIME_TO_SWITCH_POKEMON: float = 4.0

func _move_outside_left_border():
	move(_get_outside_left_border_offset(), TIME_TO_SWITCH_POKEMON/8)
	await Functions.wait_if_blocked(self)

func _get_outside_left_border_offset():
	return -(Vector2(get_viewport_rect().size.x, 0) - Vector2(FINAL_RANDOM_POKEMON_POSITION.x, 0) + 
			Vector2(get_rect().size.x, 0))

func _is_starter() -> bool:
	return STARTERS.has(current_pokemon)	

func roll_new():
	current_pokemon = _randomize()
	_change_sprite(current_pokemon)
	
func _randomize() -> Pokemon:
	var pokemon: Pokemon = current_pokemon
	while pokemon == current_pokemon:
		pokemon = AVAILABLE_POKEMON.pick_random()
	return pokemon
		
func _change_sprite(pokemon: Pokemon):
	frame = pokemon - 1

func _cry():
	started.emit()
	$SFX.stream = CRIES[current_pokemon]
	$SFX.play()
