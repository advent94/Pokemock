extends InputRelay

signal returned

func on_pressed(button: Type):
	match(button):
		Type.BUTTON_B, Type.SELECT:
			returned.emit()
