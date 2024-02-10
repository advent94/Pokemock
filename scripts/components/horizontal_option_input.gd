extends Node

signal selected
signal canceled
signal moved(direction: Direction)
signal action_button_pressed

@export var active : bool = false

enum Action { UP, DOWN, SELECT, CANCEL }
enum Direction { UP, DOWN }

func _ready():
	_initialize()
	
func _initialize():
	if active: activate()

func activate():
	$InputRegister.activate()

func deactivate():
	$InputRegister.deactivate()

const INPUT_TO_ACTION_INDEX: Dictionary = {
	"up": Action.UP,
	"down": Action.DOWN,
	"A" : Action.SELECT,
	"B" : Action.CANCEL,
}

func _parse_input():
	for input in INPUT_TO_ACTION_INDEX.keys():
		if Input.is_action_just_pressed(input):
			assert(INPUT_TO_ACTION_INDEX.has(input), "Index doesn't support input (\"%s\")" % input)
			var action: Action = INPUT_TO_ACTION_INDEX[input]
			_execute(action)

func _execute(action: Action) :
	match(action):
		Action.UP:
			moved.emit(Direction.UP)
		Action.DOWN:
			moved.emit(Direction.DOWN)
		Action.SELECT:
			action_button_pressed.emit()
			selected.emit()
		Action.CANCEL:
			action_button_pressed.emit()
			canceled.emit()
