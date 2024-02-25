class_name Counter

signal finished
signal incremented

const INCREMENT_VALUE: int = 1

var _limit: int = 0
var _current_value: int = 0

func _init(limit: int = Constants.MAX_INT):
	assert(limit > 0, "Base counter limit must be higher than 0")
	_limit = limit

func increment():
	if not is_finished:
		_current_value += INCREMENT_VALUE
		incremented.emit()
	check_if_limit_was_reached()

func check_if_limit_was_reached():
	if _current_value >= _limit:
		on_limit_reach()

func on_limit_reach():
		finish()

func get_value() -> int:
	return _current_value

func get_limit() -> int:
	return _limit
	
var is_finished: bool = false

func finish():
	if not is_finished:
		is_finished = true
		finished.emit()
