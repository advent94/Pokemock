extends PanelContainer

signal stopped
signal finished

@export var active: bool = true
@export_multiline var dialogue_text: String

const SFX_PRESS_BUTTON = preload(FilePaths.PRESS_AB_SFX)

const LINE_HEIGTH: int = 8
const LINE_SCROLL_OFFSET: Vector2 = Vector2(0, -(LINE_HEIGTH * 2))
const MAX_LINES_IN_DIALOGUE_BOX: int = 2
const MAX_CHARACTERS_PER_LINE: int = 16

const TEXT_SPEED_INDEX: Dictionary = {
	Options.TextSpeed.SLOW: 0.1,
	Options.TextSpeed.NORMAL: 0.07,
	Options.TextSpeed.FAST: 0.005,
}

@onready var dialogue: Label = $Boundaries/Dialogue
@onready var movement: Node2D = $Boundaries/Dialogue/Movement
@onready var cursor: Label = $Boundaries/Cursor
@onready var char_render_timer: Timer = $Boundaries/Dialogue/CharacterRenderTimer

var wrapper: StringWrapper = StringWrapper.new(MAX_CHARACTERS_PER_LINE)
var current_line = 0
var text_speed: int

# TODO: FLAGS!
var _is_reading: bool = false
var _is_finished: bool = false
var _is_skipping: bool = false

var _characters_to_read: int = 0

func _ready():
	if active:
		load_dialogue(dialogue_text)
	else:
		hide()
		$Input.deactivate()
	
func load_dialogue(string: String):
	_is_finished = false
	dialogue.visible_characters = 0
	dialogue.text = wrapper.wrap_string(string)
	if current_line > 0:
		dialogue.position -= LINE_SCROLL_OFFSET * abs((current_line - MAX_LINES_IN_DIALOGUE_BOX))
	load_line(MAX_LINES_IN_DIALOGUE_BOX)

func load_line(line: int):
	current_line = line
	_characters_to_read = get_char_count_to_read_from_line(current_line)
	start_reading()

func get_char_count_to_read_from_line(line: int) -> int:
	const NO_LINES: int = 0
	const NO_CHARACTERS: int = 0

	if line == NO_LINES:
		return NO_CHARACTERS
	if line >= dialogue.text.count(Constants.EMPTY_LINE) + Constants.ONE_CHARACTER:
		return dialogue.text.length()
	return Functions.string_find_n_occurrence(dialogue.text, Constants.NEW_LINE, line)


func start_reading():
	cursor.deactivate()
	char_render_timer.start()
	_is_reading = true

func _physics_process(_delta):
	if _is_skipping:
		_on_character_render_timer_timeout()

func _on_character_render_timer_timeout():
	_skip_white_characters()
	_show_next_character()

func _skip_white_characters():
	while (dialogue.visible_characters < _characters_to_read) && _ignore_character():
		read_next_character()

func _ignore_character()-> bool:
	return dialogue.text[dialogue.visible_characters] in [Constants.EMPTY_LINE, Constants.EMPTY_SPACE]
	
func _show_next_character():
	if dialogue.visible_characters < _characters_to_read:
		read_next_character()

func read_next_character():
	if _is_reading:
		dialogue.visible_characters += Constants.ONE_CHARACTER
		
		if dialogue.visible_characters >= _characters_to_read:
			stopped.emit()
		
		if dialogue.visible_characters >= dialogue.text.length():
			finished.emit()
			_is_finished = true

func _start_scrolling():
	if not _is_reading && not _is_finished:
		scroll()


func scroll():
	Audio.SFX.play(SFX_PRESS_BUTTON)
	if not movement.is_blocking():
		cursor.deactivate()
		var new_pos: Vector2 = dialogue.position + LINE_SCROLL_OFFSET
		movement.move(new_pos, Constants.ONE_SECOND * 0.1)
		
		await Functions.wait_if_blocked(dialogue)
		
		cursor.activate()
		current_line += Constants.ONE_ELEMENT
		load_line(current_line)


func stop_reading():
	cursor.activate()
	char_render_timer.stop()
	_is_reading = false

func set_text_speed(options: Options):
	$Boundaries/Dialogue/CharacterRenderTimer.wait_time = TEXT_SPEED_INDEX[options.text_speed]

func _start_skipping():
	_is_skipping = true

func _stop_skipping():
	_is_skipping = false
