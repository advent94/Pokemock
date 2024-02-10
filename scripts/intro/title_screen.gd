extends Node2D

signal started

func _ready():
	await $Title.bounce()
	await $Version.slide_in()
	started.emit()
	_unlock_input()
	$RandomizedPokemon/SwitchTimer.start()

func _lock_input():
	$StartInput.deactivate()
	
func _unlock_input():
	$StartInput.activate()

func _end():
	queue_free()
