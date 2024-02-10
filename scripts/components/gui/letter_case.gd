extends Label

signal switching_mode
signal leaving(action : Action)
signal erase_last_character

enum LetterCase { UPPER, LOWER }
var letter_case : LetterCase = LetterCase.UPPER

enum Action { LEAVE_BOTTOM, LEAVE_TOP, SWITCH, ERASE}

const INPUT_TO_ACTION_INDEX: Dictionary = {
	"up" : Action.LEAVE_TOP,
	"down" : Action.LEAVE_BOTTOM,
	"A" : Action.SWITCH,
	"B" : Action.ERASE,
}

func _activate():
	_draw_cursor()
	InputController.give_control(self)

func _draw_cursor():
	text[0] = Constants.CURSOR
		
func _parse_input():
	for input in INPUT_TO_ACTION_INDEX.keys():
		if Input.is_action_just_pressed(input):
			var action = INPUT_TO_ACTION_INDEX[input]
			_execute(action)

func _execute(action: Action):
	match(action):
		Action.LEAVE_TOP, Action.LEAVE_BOTTOM:
			_leave(action)
		Action.SWITCH:
			_switch_mode()
		Action.ERASE:
			erase_last_character.emit()

func _leave(action: Action):
	text[0] = Constants.EMPTY_SPACE
	InputController.take_control(self)
	leaving.emit(action)

const UPPER_CASE_STR = "UPPER CASE"
const LOWER_CASE_STR = "lower case"

func _switch_mode():
	match(letter_case):
		LetterCase.UPPER:
			letter_case = LetterCase.LOWER
			text = Constants.CURSOR + UPPER_CASE_STR
		LetterCase.LOWER:
			letter_case = LetterCase.UPPER
			text = Constants.CURSOR + LOWER_CASE_STR
	switching_mode.emit()
