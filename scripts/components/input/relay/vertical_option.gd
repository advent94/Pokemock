extends InputRelay

signal select_button_pressed
signal action_button_pressed
signal returned
signal moved(direction: Direction)

enum Direction { UP, DOWN }

func on_pressed(button: Type):
	match(button):
		Type.SELECT:
			select_button_pressed.emit()
		Type.BUTTON_A:
			action_button_pressed.emit()
		Type.BUTTON_B:
			returned.emit()
		Type.UP:
			moved.emit(Direction.UP)
		Type.DOWN:
			moved.emit(Direction.DOWN)
