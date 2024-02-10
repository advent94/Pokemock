extends InputRelay

signal selected

func on_pressed(button: Type):
	match(button):
		Type.BUTTON_A, Type.SELECT:
			selected.emit()
