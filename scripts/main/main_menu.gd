extends Node

signal selected(option: Option)
signal returned

enum Option { NEW_GAME, OPTIONS }

func return_to_title_screen():
	await _wait_for_sfx()
	returned.emit()
	queue_free()

func _on_option_selected(option: Option):
	match option:
		Option.NEW_GAME, Option.OPTIONS:
			await _wait_for_sfx()
			selected.emit(option)
			queue_free()

func _wait_for_sfx():
	await $OptionList.wait_if_sfx_playing()
