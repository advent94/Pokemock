extends "res://scripts/utils/moving_sprite.gd"

const FINAL_POKEBALL_POSITION: Vector2 = Vector2(87, 105)

const POKEBALL_MID_AIR_OFFSET: Vector2 = Vector2(0, -7)
const POKEBALL_APEX_OFFSET: Vector2 = Vector2(0, -1)
const FINAL_POKEBALL_POSITION_OFFSET: Vector2 = -(POKEBALL_MID_AIR_OFFSET + POKEBALL_APEX_OFFSET)
const TIME_BETWEEN_POKEBALL_PHASES: float = 0.1

func throw():
	move(POKEBALL_MID_AIR_OFFSET, Constants.NOW)
	await Functions.wait(TIME_BETWEEN_POKEBALL_PHASES)
	move(POKEBALL_APEX_OFFSET, Constants.NOW)
	await Functions.wait(TIME_BETWEEN_POKEBALL_PHASES)
	move(FINAL_POKEBALL_POSITION_OFFSET, Constants.NOW)

func _on_randomized_pokemon_starter_swap():
	throw()
