extends Node

signal selected(option: Option)
signal returned

enum Option { NEW_GAME, OPTIONS }

func return_to_title_screen():
	returned.emit()
	queue_free()

func _on_option_selected(option: Option):
	match option:
		Option.NEW_GAME, Option.OPTIONS:
			selected.emit(option)
			queue_free()
