extends Control

signal hovering_letter_case
signal added_character(character: String)
signal erased_last_character
signal insertion_finished(string: String)

@export var maximum_string_length: int = DEFAULT_CHARACTER_NAME_LENGTH

enum LetterCase { UPPER = 0, LOWER = 1 }

const SFX_PRESS_BUTTON = preload(FilePaths.PRESS_AB_SFX)

const DEFAULT_CHARACTER_NAME_LENGTH: int = 7

const ROWS: int = 5
const CHARACTERS_IN_ROW: int = 9

const ALLOWED_CHARACTERS: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ #():;[]{}-?!&%/.,@abcdefghijklmnopqrstuvwxyz"
const SPECIAL_CHARACTER_POSITION_INDEX: Dictionary = {
	# ROW 3
	" ": Vector2i(2, 8),
	# ROW 4
	"#": Vector2i(3, 0),
	"(": Vector2i(3, 1),
	")": Vector2i(3, 2),
	":": Vector2i(3, 3),
	";": Vector2i(3, 4),
	"[": Vector2i(3, 5),
	"]": Vector2i(3, 6),
	"{": Vector2i(3, 7),
	"}": Vector2i(3, 8),
	# ROW 5
	"-": Vector2i(4, 0),
	"?": Vector2i(4, 1),
	"!": Vector2i(4, 2),
	"&": Vector2i(4, 3),
	"%": Vector2i(4, 4),
	"/": Vector2i(4, 5),
	".": Vector2i(4, 6),
	",": Vector2i(4, 7),
	"@": Vector2i(4, 8),	
}

const FIRST_ROW_FIRST_CHARACTER: String = "A"
const LAST_ROW_FIRST_CHARACTER: String = "-"

var string: String = ""
var letter_case = LetterCase.UPPER
var cursor_pos: Vector2i = _get_position_for_char(FIRST_ROW_FIRST_CHARACTER)

enum EntryPoint { BEGIN, END }
	
func initialize():
	_verify_text_format()
	_set_active(EntryPoint.BEGIN)

func _verify_text_format():
	var new_lines: int = $Panel/LetterBox.text.count("\n")
	var expected_array_size = (((CHARACTERS_IN_ROW * 2) * ROWS) + new_lines)
	assert($Panel/LetterBox.text.length() == expected_array_size, 
			"Naming box character array has undefined size(%d), expected (%d)." % 
			[$Panel/LetterBox.text.length(), expected_array_size])

func _set_active(entry: EntryPoint):
	var entry_character: String = _get_entry_point_character(entry)
	cursor_pos = _get_position_for_char(entry_character)
	_draw_cursor()
	InputController.give_control(self)

func _get_entry_point_character(entry: EntryPoint) -> String:
	var character: String
	match(entry):
		EntryPoint.BEGIN:
			character = FIRST_ROW_FIRST_CHARACTER
		EntryPoint.END:
			character = LAST_ROW_FIRST_CHARACTER
	if letter_case == LetterCase.LOWER:
		character = character.to_lower()
	return character
	
func _get_position_for_char(character: String) -> Vector2i:
	assert(Functions.is_char(character), "Only single character allowed (entered: %s)" % character)
	assert(ALLOWED_CHARACTERS.contains(character), "This character is not allowed(ASCII: %d)" % Functions.char_to_ASCII(character))
		
	var ascii: int = Functions.char_to_ASCII(character)
	var is_letter: bool = _is_letter(character)
	var pos: Vector2i
	
	if is_letter:
		pos = _calculate_pos_for_letters(ascii)
	else:
		pos = SPECIAL_CHARACTER_POSITION_INDEX[character]
	return pos

func _is_letter(character: String) -> bool:
	if Functions.is_lower_case_letter(character):
		assert(letter_case == LetterCase.LOWER, "Shouldn't access lower case without switching the mode.")
		return true
	elif Functions.is_upper_case_letter(character):
		assert(letter_case == LetterCase.UPPER, "Shouldn't access upper case without switching the mode")
		return true
	return false

func _calculate_pos_for_letters(ascii: int) -> Vector2i:
	var index: int = ascii - (Constants.UPPER_CASE_ASCII_MIN_VALUE + (letter_case * Constants.ASCII_LETTER_CASE_OFFSET))
	var row: int = Functions.safe_integer_division(index, CHARACTERS_IN_ROW)
	var column: int = index - (row * CHARACTERS_IN_ROW)
	return Vector2i(row, column)
	
const CURSOR: String = ">"
const OFFSET_FROM_CHAR_TO_CURSOR: int = -1

func _draw_cursor():
	$Panel/LetterBox.text[_get_index_for_pos(cursor_pos) + OFFSET_FROM_CHAR_TO_CURSOR] = CURSOR
	
## Empty space for cursor + character
const CHARACTERS_PER_COLUMN = 2

## Each row will end up with newline then we have another newline to create horizontal space
const NEWLINES_PER_ROW: int = 2

const FIRST_ROW_INDEX: int = 0
const FIRST_COLUMN_INDEX: int = 0
const OFFSET_FROM_CURSOR_TO_CHAR: int = - OFFSET_FROM_CHAR_TO_CURSOR
const CHARACTERS_WITH_WHITE_SPACES_IN_ROW: int = CHARACTERS_IN_ROW * CHARACTERS_PER_COLUMN

func _get_index_for_pos(pos: Vector2i) -> int:
	assert(pos.x >= FIRST_ROW_INDEX && pos.x <= (ROWS - Constants.ZERO_INDEXING_OFFSET), "Undefined row number for pos (%v)" % pos)
	assert(pos.y >= FIRST_COLUMN_INDEX && pos.y <= (CHARACTERS_IN_ROW - Constants.ZERO_INDEXING_OFFSET), "Undefined element for pos (%v)" % pos)
	var row: int = pos.x
	var column: int = pos.y
	return (row * (CHARACTERS_WITH_WHITE_SPACES_IN_ROW + NEWLINES_PER_ROW)) + ((column * CHARACTERS_PER_COLUMN) + OFFSET_FROM_CURSOR_TO_CHAR) 

enum Action { MOVE_DOWN, MOVE_UP, MOVE_LEFT, MOVE_RIGHT, INSERT, ERASE }

const INPUT_TO_ACTION_INDEX: Dictionary = { 
	"up": Action.MOVE_UP,
	"down": Action.MOVE_DOWN,
	"left": Action.MOVE_LEFT,
	"right": Action.MOVE_RIGHT,
	"A": Action.INSERT,
	"B": Action.ERASE,
}

const ACTION_TO_DIRECTION_INDEX: Dictionary = {
	Action.MOVE_UP : Vector2i(-1, 0),
	Action.MOVE_DOWN: Vector2i(1, 0),
	Action.MOVE_LEFT: Vector2i(0, -1),
	Action.MOVE_RIGHT: Vector2i(0, 1),
}

func _parse_input():
	for input in INPUT_TO_ACTION_INDEX.keys():
		if Input.is_action_just_pressed(input):
			var action: Action = INPUT_TO_ACTION_INDEX[input]
			_execute(action)
			break

const END_INSERTION: String = "@"	

func _execute(action : Action):
	match(action):
		Action.MOVE_UP, Action.MOVE_DOWN, Action.MOVE_LEFT, Action.MOVE_RIGHT:
			_move_cursor(action)
		Action.INSERT:
			if _get_char_from_cursor_pos() == END_INSERTION:
				insertion_finished.emit(string)
			else:
				_insert_current_character()
		Action.ERASE:
			_erase_last_character()

func _move_cursor(action: Action):
	var direction: Vector2i = ACTION_TO_DIRECTION_INDEX[action]	
	_remove_cursor()
	cursor_pos += direction;
	if cursor_pos.x < 0 || cursor_pos.x >= ROWS:
		InputController.take_control(self)
		hovering_letter_case.emit()
		return
	if cursor_pos.y < 0:
		cursor_pos.y = CHARACTERS_IN_ROW - 1
	cursor_pos.x %= ROWS
	cursor_pos.y %= CHARACTERS_IN_ROW
	_draw_cursor()

func _remove_cursor():
	$Panel/LetterBox.text[_get_index_for_pos(cursor_pos) + OFFSET_FROM_CHAR_TO_CURSOR] = Constants.EMPTY_SPACE

func _get_char_from_cursor_pos() -> String:
	return $Panel/LetterBox.text[_get_index_for_pos(cursor_pos)]	
	
func _insert_current_character():
	if string.length() < maximum_string_length:
		_add_current_character_to_string()
		Audio.SFX.play(SFX_PRESS_BUTTON)
	if string.length() == maximum_string_length:
		_set_cursor_on_end()

func _add_current_character_to_string():
	var character: String = _get_char_from_cursor_pos()
	string += character
	added_character.emit(character)

func _set_cursor_on_end():
	_remove_cursor()
	cursor_pos = _get_position_for_char(END_INSERTION)
	_draw_cursor()
			
func _erase_last_character():
	if string.length() >= Constants.ONE_CHARACTER:
		var last_character_index: int = string.length() - Constants.ZERO_INDEXING_OFFSET
		string = string.erase(last_character_index)
		erased_last_character.emit()

func switch_mode():
	match(letter_case):
		LetterCase.UPPER:
			letter_case = LetterCase.LOWER
			$Panel/LetterBox.text = $Panel/LetterBox.text.to_lower()
		LetterCase.LOWER:
			letter_case = LetterCase.UPPER
			$Panel/LetterBox.text = $Panel/LetterBox.text.to_upper()
