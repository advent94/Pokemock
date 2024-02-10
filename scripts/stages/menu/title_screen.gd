extends Node2D

signal started

const TITLE_SCREEN_BGM = preload(FilePaths.TITLE_SCREEN_BGM)

func _ready():
	await $Title.bounce()
	await $Version.slide_in()
	Audio.play_bgm(TITLE_SCREEN_BGM)
	started.emit()
	_unlock_input()
	$RandomizedPokemon/SwitchTimer.start()

func _lock_input():
	$Input.deactivate()
	
func _unlock_input():
	$Input.activate()

func _end():
	queue_free()
