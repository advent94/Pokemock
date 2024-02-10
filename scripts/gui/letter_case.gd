extends Label

signal switching_mode
signal leaving(action : Action)
signal erase_last_character

enum LetterCase { UPPER, LOWER }
var _letter_case : LetterCase = LetterCase.UPPER

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

const CURSOR: String = ">"

func _draw_cursor():
	text[0] = CURSOR
		
func _parse_input():
	for input in INPUT_TO_ACTION_INDEX.keys():
		if Input.is_action_just_pressed(input):
			var action = INPUT_TO_ACTION_INDEX[input]
			match(action):
				Action.LEAVE_TOP, Action.LEAVE_BOTTOM:
					_leave(action)
				Action.SWITCH:
					_switch_mode()
				Action.ERASE:
					erase_last_character.emit()
				_:
					ErrorHandler.throw_default_assertion("Unsupported action (%d)" % action)
			break

func _execute(action: Action):
	match(action):
		Action.LEAVE_TOP, Action.LEAVE_BOTTOM:
			_leave(action)
		Action.SWITCH:
			_switch_mode()
		Action.ERASE:
			erase_last_character.emit()
		_:
			ErrorHandler.throw_default_assertion("Unsupported action (%d)" % action)

func _leave(action: Action):
	text[0] = " "
	InputController.take_control(self)
	leaving.emit(action)

const UPPER_CASE_STR = CURSOR + "UPPER CASE"
const LOWER_CASE_STR = CURSOR + "lower case"

func _switch_mode():
	match(_letter_case):
		LetterCase.UPPER:
			_letter_case = LetterCase.LOWER
			text = UPPER_CASE_STR
		LetterCase.LOWER:
			_letter_case = LetterCase.UPPER
			text = LOWER_CASE_STR
	switching_mode.emit()
