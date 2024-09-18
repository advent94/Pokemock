extends Node

enum Mode { RUNTIME, DEBUG, TESTABILITY }

var _mode: Mode = Mode.DEBUG
var _warnings: PackedStringArray = []
var _errors: PackedStringArray = []
var _assertion: String

func set_mode(mode : Mode):
	_mode = mode

func get_mode() -> Mode:
	return _mode

func default_assertion(string: String = ""):
	return assertion(false, string)

func assertion(condition: bool, string: String = ""):
	if _mode == Mode.TESTABILITY && condition:
		_assertion = string
	else:
		assert(condition, string)

func error(string : String):
	if _mode == Mode.TESTABILITY:
		_errors.push_back(string)
	elif _mode == Mode.DEBUG:
		assert(false, string)
	else:
		push_error(string)

func warning(string : String):
	if _mode == Mode.TESTABILITY:
		_warnings.push_back(string)
	elif _mode == Mode.DEBUG:
		assert(false, string)
	else:
		push_warning(string)

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

func has_assert(string: String) -> bool:
	return _assertion == string
