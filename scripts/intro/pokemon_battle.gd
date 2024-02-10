extends Node2D

signal pokemon_battle_ended

func _ready():
	play()

func play():
	$BGM.play()
	await _play_intro_sequence()
	await $Jigglypuff.in_and_out_first_sequence()
	await $Gengar.prepare_for_attack()
	await $Gengar.attack()
	await _wait_if_blocked()
	await $Jigglypuff.back_off()
	await $Gengar.back_off()
	await $Jigglypuff.retaliate()
	await _do_whiteout()
	pokemon_battle_ended.emit()
	await $BGM.finished
	queue_free()

const GENGAR_INTRO_MOVEMENT: Vector2 = -JIGGLYPUFF_INTRO_MOVEMENT
const JIGGLYPUFF_INTRO_MOVEMENT: Vector2 = Vector2(78, 0)
const TAKE_POSITION_TIME_IN_SEC: float = 1

func _play_intro_sequence():
	$Gengar.move(GENGAR_INTRO_MOVEMENT, TAKE_POSITION_TIME_IN_SEC)
	$Jigglypuff.move(JIGGLYPUFF_INTRO_MOVEMENT, TAKE_POSITION_TIME_IN_SEC)
		
func _wait_if_blocked():
	await Functions.wait_if_blocked($Gengar)
	await Functions.wait_if_blocked($Jigglypuff)

const WHITEOUT_MULTIPLIER: float = 2.0
const TIME_BETWEEN_WHITEOUT_UPDATES: float = 0.25
const MAX_WHITEOUT_MULTIPLIER_VALUE: float = 8.0

func _do_whiteout():
	var _whiteout_modifier = 0.0	
	while _whiteout_modifier <= MAX_WHITEOUT_MULTIPLIER_VALUE:
		_whiteout_modifier += WHITEOUT_MULTIPLIER
		material.set_shader_parameter("whiteout_time_step", _whiteout_modifier)
		await Functions.wait(TIME_BETWEEN_WHITEOUT_UPDATES)

func end():
	$StartInput.deactivate()
	await _do_whiteout()
	queue_free()
