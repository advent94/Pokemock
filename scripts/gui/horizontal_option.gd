extends Control

signal selected

enum Direction { UP, DOWN }
signal exited(direction: Direction)

@export var text : String
@export var active: bool = false
@export var has_indicator: bool = true

func _ready():
	_initialize()
	if active:
		activate()
	elif has_indicator:
		_draw_indicator()

func _initialize():
	$Text.text = Constants.SPACE_FOR_CURSOR + text

func activate():
	$HorizontalOptionInput.activate()
	_draw_cursor()

func deactivate():
	$HorizontalOptionInput.deactivate()
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
	$SFX.play()
	selected.emit()	

func _exit(direction: Direction):
	deactivate()
	exited.emit(direction)
