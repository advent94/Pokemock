extends InputRelay

signal escaped(direction: EscapeDirection)
signal move(direction: Direction)

enum EscapeDirection { UP, DOWN }
enum Direction { LEFT, RIGHT }

func on_pressed(button: Type):
	match(button):
		Type.UP:
			escaped.emit(EscapeDirection.UP)
		Type.DOWN:
			escaped.emit(EscapeDirection.DOWN)
		Type.LEFT:
			move.emit(Direction.LEFT)
		Type.RIGHT:
			move.emit(Direction.RIGHT)
