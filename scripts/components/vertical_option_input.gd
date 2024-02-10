extends Node

signal selected
signal canceled
signal moved(direction: Direction)
signal button_pressed
signal escaped(direction: EscapeDirection)

@export var active : bool = false

enum Action { LEFT, RIGHT, ESCAPE_UP, ESCAPE_DOWN, SELECT, CANCEL }
enum Direction { LEFT, RIGHT }
enum EscapeDirection { UP, DOWN }

func _ready():
	_initialize()
	
func _initialize():
	if active: activate()
	
func activate():
	$InputRegister.activate()

func deactivate():
	$InputRegister.deactivate()

const INPUT_TO_ACTION_INDEX: Dictionary = {
	"left": Action.LEFT,
	"right": Action.RIGHT,
	"up": Action.ESCAPE_UP,
	"down": Action.ESCAPE_DOWN,	
	"A" : Action.SELECT,
	"B" : Action.CANCEL,
}

func _parse_input():
	for input in INPUT_TO_ACTION_INDEX.keys():
		if Input.is_action_just_pressed(input):
			button_pressed.emit()
			assert(INPUT_TO_ACTION_INDEX.has(input), "Index doesn't support input (\"%s\")" % input)
			var action: Action = INPUT_TO_ACTION_INDEX[input]
			_execute(action)

func _execute(action: Action):
	match(action):
		Action.LEFT:
			moved.emit(Direction.LEFT)
		Action.RIGHT:
			moved.emit(Direction.RIGHT)
		Action.ESCAPE_UP:
			escaped.emit(EscapeDirection.UP)
		Action.ESCAPE_DOWN:
			escaped.emit(EscapeDirection.DOWN)	
		Action.SELECT:
			selected.emit()
		Action.CANCEL:
			canceled.emit()
