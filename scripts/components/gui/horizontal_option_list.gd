extends PanelContainer

signal saved_option(current_option : int)
signal left(direction: EscapeDirection)

enum EscapeDirection { UP, DOWN }

@export var title: String = ""
@export_multiline var options: String = "OPTION1\nOPTION2"
@export var active: bool = false
@export var allow_vertical_escape: bool = true
@export var save_last_option: bool = false

var option_count: int = 0
var _cursor_pos_index: Array[int] = []
var current_option: int = 0

func _ready():
	_initialize()
	if active: 
		activate()
	elif save_last_option:
		_draw_saved_cursor()

func _initialize():
	var _options: PackedStringArray = options.split("\n")
	option_count = _options.size()
	_cursor_pos_index = _fill_cursor_pos_index(_options)
	$Options.text = _get_formated_text(_options)

const EMPTY_SPACE_AFTER_TITLE: String = Constants.NEW_LINE + Constants.EMPTY_LINE

func _fill_cursor_pos_index(_options: PackedStringArray) -> Array[int]:
	var _option_index: Array[int] = []
	var should_include_title: bool = not title.is_empty()
	var total_length: int = 0 
	if should_include_title:
		total_length += (title.length() + EMPTY_SPACE_AFTER_TITLE.length())
	for i in range(option_count):
		var lpad = Constants.SPACE_FOR_CURSOR.length() + _options[i].count(Constants.EMPTY_SPACE)
		_option_index.push_back(total_length + lpad - Constants.ZERO_INDEXING_OFFSET)
		total_length += _options[i].length() + Constants.SPACE_FOR_CURSOR.length()
	return _option_index
	
func _get_formated_text(_options: PackedStringArray) -> String:
	var _text: String = String()
	if not title.is_empty():
		_text += title + EMPTY_SPACE_AFTER_TITLE
	for option in _options:
		_text += Constants.SPACE_FOR_CURSOR + option
	return _text

func activate():
	$Input.activate()
	_draw_cursor()

enum Cursor { EMPTY, ACTIVE, SAVED }
const SYMBOLS: Dictionary = {
	Cursor.EMPTY: Constants.EMPTY_SPACE,
	Cursor.ACTIVE: Constants.CURSOR,
	Cursor.SAVED: Constants.SAVED_CURSOR,
}

func _draw_cursor():
	draw(Cursor.ACTIVE)
	
func _draw_saved_cursor():
	draw(Cursor.SAVED)

func draw(cursor: Cursor):
	$Options.text[_cursor_pos_index[current_option]] = SYMBOLS[cursor]
	
enum Direction { LEFT, RIGHT }

func _move_cursor(direction: Direction):
	_remove_current_cursor()
	_set_next_cursor_pos(direction)
	_draw_cursor()

func _remove_current_cursor():
	draw(Cursor.EMPTY)
	
func _set_next_cursor_pos(direction: Direction):
	match direction:
		Direction.LEFT:
			current_option -= Constants.ONE_ELEMENT
		Direction.RIGHT:
			current_option += Constants.ONE_ELEMENT
	if allow_vertical_escape:
		current_option = Functions.rclamp(current_option, Constants.FIRST_ELEMENT_IN_INDEX, option_count - Constants.ZERO_INDEXING_OFFSET)
	else:
		current_option = clamp(current_option, Constants.FIRST_ELEMENT_IN_INDEX, option_count - Constants.ZERO_INDEXING_OFFSET)

func initialize_for_option(option: int):
	if save_last_option && Functions.is_between(option, Constants.FIRST_ELEMENT_IN_INDEX, option_count - Constants.ZERO_INDEXING_OFFSET):
		_remove_current_cursor()
		current_option = option
		if active:
			_draw_cursor()
		else:
			_draw_saved_cursor()
	
func deactivate():
	if save_last_option:
		saved_option.emit(current_option)
		_draw_saved_cursor()
	else: 
		_remove_current_cursor()
	$Input.deactivate()
	
func leave(direction: EscapeDirection):
	left.emit(direction)
