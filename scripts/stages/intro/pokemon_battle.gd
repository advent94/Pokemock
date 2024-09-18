extends Node2D

signal pokemon_battle_ended

const POKEMON_BATTLE_BGM = preload(FilePaths.POKEMON_BATTLE_BGM)

func _ready():
	material = ShaderMaterialFactory.create("sprite")
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
	$Input.deactivate()
	_do_whiteout()


func _do_whiteout():
	const TIME_BEFORE_END: float = 0.20
	
	var effect =  Whiteout.new()
	
	effect.finished.connect(
		func(): 
			await Functions.wait(TIME_BEFORE_END)
			pokemon_battle_ended.emit()
			queue_free()
	)
	
	VisualEffects.add(effect, self)


func _play_intro_sequence():
	const JIGGLYPUFF_INTRO_MOVEMENT: Vector2 = Vector2(78, 0)
	const GENGAR_INTRO_MOVEMENT: Vector2 = -JIGGLYPUFF_INTRO_MOVEMENT
	const TAKE_POSITION_TIME_IN_SEC: float = 1

	$Gengar.move(GENGAR_INTRO_MOVEMENT, TAKE_POSITION_TIME_IN_SEC)
	$Jigglypuff.move(JIGGLYPUFF_INTRO_MOVEMENT, TAKE_POSITION_TIME_IN_SEC)


func _wait_if_blocked():
	await Functions.wait_if_blocked($Gengar)
	await Functions.wait_if_blocked($Jigglypuff)

func end():
	$Input.deactivate()
	_do_whiteout()
