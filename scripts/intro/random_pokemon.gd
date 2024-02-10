extends "res://scripts/utils/moving_sprite.gd"

signal starter_swap

enum Pokemon { 
	BULBASAUR = 1, CHARMANDER = 4, SQUIRTLE = 7,  RAICHU = 26, VULPIX = 37, GLOOM = 44, MANKEY = 56, POLIWAG = 60, 
	DODUO = 84, GENGAR = 94, HITMONLEE = 106, CHANSEY = 113, JOLTEON = 135, PORYGON = 137, AERODACTYL = 142, 
	SNORLAX = 143,
}

var current_pokemon: Pokemon = Pokemon.SQUIRTLE

const AVAILABLE_POKEMON: Array[Pokemon] = [
	Pokemon.BULBASAUR, Pokemon.CHARMANDER, Pokemon.SQUIRTLE,  Pokemon.RAICHU, Pokemon.VULPIX, Pokemon.GLOOM, 
	Pokemon.MANKEY, Pokemon.POLIWAG, Pokemon.DODUO, Pokemon.GENGAR, Pokemon.HITMONLEE, Pokemon.CHANSEY, 
	Pokemon.JOLTEON, Pokemon.PORYGON, Pokemon.AERODACTYL, Pokemon.SNORLAX,	
]

const NOT_FOUND: int = -1

const STARTERS: Array[Pokemon] = [
	Pokemon.BULBASAUR, Pokemon.CHARMANDER, Pokemon.SQUIRTLE
]

func switch():
	$SwitchTimer.stop()
	_move_outside_left_border()
	if _is_starter():
		starter_swap.emit()
	var offset_outside_right_border: Vector2 = -(_get_outside_left_border_offset() * 2)
	move(offset_outside_right_border, Constants.NOW)
	await Functions.wait_if_blocked(self)
	await roll_new()
	var offset_from_right_border_to_final: Vector2 = -(position - FINAL_RANDOM_POKEMON_POSITION)
	move(offset_from_right_border_to_final, TIME_TO_SWAP_POKEMON/8)
	await Functions.wait_if_blocked(self)
	$SwitchTimer.start()

const FINAL_RANDOM_POKEMON_POSITION: Vector2 = Vector2(69, 108)
const TIME_TO_SWAP_POKEMON: float = 4.0

func _move_outside_left_border():
	move(_get_outside_left_border_offset(), TIME_TO_SWAP_POKEMON/8)
	await Functions.wait_if_blocked(self)

func _get_outside_left_border_offset():
	return -(Vector2(get_viewport_rect().size.x, 0) - Vector2(FINAL_RANDOM_POKEMON_POSITION.x, 0) + 
			Vector2(get_rect().size.x, 0))
			
func _is_starter():
	return STARTERS.find(current_pokemon) != NOT_FOUND	

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

