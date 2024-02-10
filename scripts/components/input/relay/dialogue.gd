extends InputRelay

signal skipped
signal stopped_skipping
signal continued

func on_pressed(button: Type):
	match button:
		Type.BUTTON_A, Type.BUTTON_B:
			skipped.emit()
			continued.emit()

func on_released(button: Type):
	match button:
		Type.BUTTON_A, Type.BUTTON_B:
			stopped_skipping.emit()
