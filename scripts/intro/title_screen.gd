extends Node2D

func _ready():
	hide()

func initialize():
	show()
	await $Title.bounce()
	await $Version.slide_in()
	$BGM.play()
	$RandomizedPokemon/SwitchTimer.start()

func _on_bgm_finished():
	$BGM.play()
