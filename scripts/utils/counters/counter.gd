extends RefCounted
class_name Counter

signal finished
signal incremented
signal restarted

const INCREMENT_VALUE: int = 1

var _limit: int = 0
var _current_value: int = 0


## NOTE: WRITE DOCUMENTATION!

func _init(limit: int = Constants.MAX_INT):
	assert(limit > 0, "Base counter limit must be higher than 0")
	_limit = limit

func increment():
	if not _is_finished:
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
	
var _is_finished: bool = false

func is_finished() -> bool:
	return _is_finished

func finish():
	if not _is_finished:
		_is_finished = true
		finished.emit()

## NOTE: WRITE TESTS!
func restart():
	_current_value = 0
	_is_finished = false
	restarted.emit()
