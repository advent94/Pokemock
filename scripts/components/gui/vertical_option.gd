extends Control

signal selected
signal exited(direction: Direction)

enum Direction { UP, DOWN }

@export var text : String
@export var active: bool = false
@export var has_indicator: bool = true

const SFX_PRESSED_BUTTON = preload(FilePaths.PRESS_AB_SFX)

func _ready():
	_initialize()
	if active:
		activate()
	elif has_indicator:
		_draw_indicator()

func _initialize():
	$Text.text = Constants.SPACE_FOR_CURSOR + text

func activate():
	$Input.activate()
	_draw_cursor()

func deactivate():
	$Input.deactivate()
	if has_indicator:
		_draw_indicator()
	else:
		_erase_cursor()

func _draw_cursor():
	$Text.text[Constants.FIRST_ELEMENT_IN_INDEX] = Constants.CURSOR

func _erase_cursor():
	$Text.text[Constants.FIRST_ELEMENT_IN_INDEX] = Constants.EMPTY_SPACE

func _draw_indicator():
	$Text.text[Constants.FIRST_ELEMENT_IN_INDEX] = Constants.SAVED_CURSOR	

func _select():
	await Audio.SFX.play(SFX_PRESSED_BUTTON).finished
	selected.emit()	

func _exit(direction: Direction):
	deactivate()
	exited.emit(direction)
