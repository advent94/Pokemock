extends Node2D

signal pokemon_battle_ended

const POKEMON_BATTLE_BGM = preload(FilePaths.POKEMON_BATTLE_BGM)

func _ready():
	play()

func play():
	Audio.BGM.play(POKEMON_BATTLE_BGM)
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

const TIME_BETWEEN_UPDATES: float = 0.25
const TOTAL_EFFECT_TIME: float = 1.0
const MOD_INCREMENT_VALUE: float = (TIME_BETWEEN_UPDATES / TOTAL_EFFECT_TIME) * 1.0
const MAX_MOD_VALUE: float = 1.0

func _do_whiteout():
	var current_mod = 0.0	
	while current_mod < MAX_MOD_VALUE:
		current_mod += MOD_INCREMENT_VALUE
		material.set_shader_parameter("modifier", current_mod)
		await Functions.wait(TIME_BETWEEN_UPDATES)

func end():
	$Input.deactivate()
	await _do_whiteout()
	queue_free()
