extends Node

signal started

@export var active: bool = true

enum Action { START }

const INPUT_TO_ACTION_INDEX: Dictionary = {
	"A" : Action.START,
	"enter" : Action.START,
}

func _ready():
	if active:
		$InputRegister.activate()

func activate():
	$InputRegister.activate()
	
func deactivate():
	$InputRegister.deactivate()
	
func _parse_input():
	for input in INPUT_TO_ACTION_INDEX.keys():
		if Input.is_action_just_pressed(input):
			assert(INPUT_TO_ACTION_INDEX.has(input), "Index doesn't support input (\"%s\")" % input)
			var action: Action = INPUT_TO_ACTION_INDEX[input]
			_execute(action)
			
func _execute(action: Action):
	match action:
		Action.START:
			started.emit()
