extends Node

enum Mode { RUNTIME, DEBUG, TESTABILITY }

var _mode: Mode = Mode.RUNTIME
var _warnings: PackedStringArray = []
var _errors: PackedStringArray = []

func set_mode(mode : Mode):
	_mode = mode

func get_mode() -> Mode:
	return _mode

func warning(string : String):
	if _mode == Mode.TESTABILITY:
		_warnings.push_back(string)
	else:
		push_warning(string)

func error(string : String):
	if _mode == Mode.TESTABILITY:
		_errors.push_back(string)
	else:
		push_error(string)

func info(msg : String):
	if _mode == Mode.DEBUG:
		print(msg)

func clear():
	_warnings.clear()
	_errors.clear()

func has_error(string : String) -> bool:
	return Functions.any_contains(_errors, string, false)

func has_warning(string : String) -> bool:
	return Functions.any_contains(_warnings, string, false)
