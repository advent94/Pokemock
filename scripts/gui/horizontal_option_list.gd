extends PanelContainer

signal option_selected(option: int)
signal returned

@export_multiline var options: String = "OPTION1\nOPTION2"
@export var active: bool = false

var option_count: int
var cursor_pos_index: Array[int] = []
var current_option: int = 0

func _ready():
	_initialize()
	if active: activate()
	
func _initialize():
	var _options: PackedStringArray = options.split("\n")
	option_count = _options.size()
	cursor_pos_index = _get_cursor_pos_index(_options)
	$Options.text = _get_formated_text(_options)

const EMPTY_SPACE_AFTER_OPTION: String  = Constants.NEW_LINE + Constants.EMPTY_LINE

func _get_cursor_pos_index(_options: PackedStringArray) -> Array[int]:
	var total_length: int = _options[Constants.FIRST_ELEMENT_IN_INDEX].length()
	var _cursor_pos_index: Array[int] = [Constants.STRING_BEGIN]
	for i in range(1, _options.size()):
		_cursor_pos_index.push_back(total_length + (i * (EMPTY_SPACE_AFTER_OPTION.length() + Constants.SPACE_FOR_CURSOR.length())))
		total_length += _options[i].length()
	return _cursor_pos_index

func _get_formated_text(_options: PackedStringArray) -> String:
	var formated_text: String = String()
	for option in _options:
		formated_text += Constants.SPACE_FOR_CURSOR + option + Constants.NEW_LINE + Constants.EMPTY_LINE
	formated_text = formated_text.erase(formated_text.length() - EMPTY_SPACE_AFTER_OPTION.length(), 
			EMPTY_SPACE_AFTER_OPTION.length())
	return formated_text
	
func activate():
	$HorizontalOptionInput.activate()
	_draw_cursor()

func deactivate():
	$HorizontalOptionInput.deactivate()
	_remove_current_cursor()

func _draw_cursor():
	$Options.text[cursor_pos_index[current_option]] = Constants.CURSOR	
	
func _remove_current_cursor():
	$Options.text[cursor_pos_index[current_option]] = Constants.SPACE_FOR_CURSOR

enum Direction { UP, DOWN }

func move_cursor(direction: Direction):
	_remove_current_cursor()
	_set_next_cursor_pos(direction)
	_draw_cursor()

func _set_next_cursor_pos(direction: Direction):
	match(direction):
		Direction.UP:
			current_option -= Constants.ONE_ELEMENT
		Direction.DOWN:
			current_option += Constants.ONE_ELEMENT
	current_option = Functions.rclamp(current_option, Constants.FIRST_ELEMENT_IN_INDEX, 
			option_count - Constants.ZERO_INDEXING_OFFSET)

func _select_current_option():
	option_selected.emit(current_option)
	
func _return():
	returned.emit()
	
func _play_sfx():
	$SFX.play()

func wait_if_sfx_playing():
	while $SFX.playing:
		await $SFX.finished
