extends MovingSprite

signal starter_switch
signal switch_started
signal switch_finished
signal started

enum Pokemon { 
	BULBASAUR = 1, CHARMANDER = 4, SQUIRTLE = 7,  RAICHU = 26, VULPIX = 37, GLOOM = 44, MANKEY = 56, POLIWAG = 60, 
	DODUO = 84, GENGAR = 94, HITMONLEE = 106, CHANSEY = 113, JOLTEON = 135, PORYGON = 137, AERODACTYL = 142, 
	SNORLAX = 143,
}

const CRIES: Dictionary = {
	Pokemon.BULBASAUR: preload(FilePaths.BULBASAUR_CRY),
	Pokemon.CHARMANDER: preload(FilePaths.CHARMANDER_CRY),
	Pokemon.SQUIRTLE: preload(FilePaths.SQUIRTLE_CRY),  
	Pokemon.RAICHU: preload(FilePaths.RAICHU_CRY),
	Pokemon.VULPIX: preload(FilePaths.VULPIX_CRY),
	Pokemon.GLOOM: preload(FilePaths.GLOOM_CRY),
	Pokemon.MANKEY: preload(FilePaths.MANKEY_CRY),
	Pokemon.POLIWAG: preload(FilePaths.POLIWAG_CRY),
	Pokemon.DODUO: preload(FilePaths.DODUO_CRY),
	Pokemon.GENGAR: preload(FilePaths.GENGAR_CRY),
	Pokemon.HITMONLEE: preload(FilePaths.HITMONLEE_CRY),
	Pokemon.CHANSEY: preload(FilePaths.CHANSEY_CRY),
	Pokemon.JOLTEON: preload(FilePaths.JOLTEON_CRY),
	Pokemon.PORYGON: preload(FilePaths.PORYGON_CRY),
	Pokemon.AERODACTYL: preload(FilePaths.AERODACTYL_CRY),
	Pokemon.SNORLAX: preload(FilePaths.SNORLAX_CRY),
}

const STARTERS: Array[Pokemon] = [
	Pokemon.BULBASAUR, Pokemon.CHARMANDER, Pokemon.SQUIRTLE
]

var current_pokemon: Pokemon = Pokemon.SQUIRTLE

const FINAL_RANDOM_POKEMON_POSITION: Vector2 = Vector2(69, 108)
const TIME_TO_SWITCH_POKEMON: float = 4.0

func switch():
	switch_started.emit()
	$SwitchTimer.stop()
	_move_outside_left_border()
	if _is_starter():
		starter_switch.emit()
	var offset_outside_right_border: Vector2 = -(_get_outside_left_border_offset() * 2)
	move(offset_outside_right_border, Constants.NOW)
	await Functions.wait_if_blocked(self)
	await _roll_new()
	var offset_from_right_border_to_final: Vector2 = -(position - FINAL_RANDOM_POKEMON_POSITION)
	move(offset_from_right_border_to_final, TIME_TO_SWITCH_POKEMON/8)
	await Functions.wait_if_blocked(self)
	switch_finished.emit()
	$SwitchTimer.start()

func _move_outside_left_border():
	move(_get_outside_left_border_offset(), TIME_TO_SWITCH_POKEMON/8)
	await Functions.wait_if_blocked(self)

func _get_outside_left_border_offset():
	return -(Vector2(get_viewport_rect().size.x, 0) - Vector2(FINAL_RANDOM_POKEMON_POSITION.x, 0) + 
			Vector2(get_rect().size.x, 0))

func _is_starter() -> bool:
	return STARTERS.has(current_pokemon)	

func _roll_new():
	current_pokemon = _randomize()
	_change_sprite(current_pokemon)


func _randomize() -> Pokemon:
	var pokemon: Pokemon = current_pokemon
	
	while pokemon == current_pokemon:
		pokemon = Pokemon[Pokemon.keys().pick_random()]
	return pokemon


func _change_sprite(pokemon: Pokemon):
	frame = pokemon - 1

var selected: bool = false


func _start():
	if selected: 
		return
	
	selected = true
	await Audio.SFX.play(CRIES[current_pokemon]).finished
	started.emit()
