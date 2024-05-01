class_name AdvancedCounter
## Counter that can be customized. It supports starting value, two limits, decrementing,
## adding and removing any value, repetitions, negative values, reverse counting and restart on limit.
## It can also be set to fast or strict (default) modes.
##
## Constructor:
## [codeblock]AdvancedCounter.new(
##    limit = Constants.MAX_INT,
##    starting_value = 0,
##    r_limit = starting_value,
##    reps = 0,
##    increment_value = 1,
##    flags = default)[/codeblock]
## Flags: [AdvancedCounter.Flags]

extends Counter

signal changed(val: int)
signal decremented
signal repetition_finished
signal reverse_limit_reached

enum FlagsT { 
	REVERSE = 1, 
	NEGATIVE = 2 , 
	## Counter will restart (is set to starting value) once it reaches the limit
	RESTART = 4, 
	## Skips entire operation validation except for check if limit was reached, [code]USE WITH CAUTION[/code]
	FAST = 8, 
	## Throws error when invalid user input was used, overridden by FAST flag, true by default
	STRICT = 16 
}

var _flags: int = 0

## Limit for current value that is either min or max, depending if we are dealing with reversed counter
## or not
var _r_limit: int = 0

var _increment_value: int = INCREMENT_VALUE
var _repetition_counter: Counter = null
var _starting_value: int = 0
var _total_repetitions: int = 0

## [codeblock]AdvancedCounter.Flags.new(
##	 restarts_on_limit = false, 
##	 reverse = false, 
##	 negative = false,
##	 fast = false,
##	 strict  = true)[/codeblock]
class Flags:
	## Sum of bit flags that specifies counter's settings.
	var val: int = 0
	
	func _init(restarts_on_limit: bool = false, reverse: bool = false, negative: bool = false, fast: bool = false, strict: bool = true):
		if restarts_on_limit:
			val |= FlagsT.RESTART
		if reverse:
			val |= FlagsT.REVERSE
		if negative:
			val |= FlagsT.NEGATIVE
		if strict:
			val |= FlagsT.STRICT
		if fast:
			val |= FlagsT.FAST
			val &= ~FlagsT.STRICT

#TODO: Flagi, int czy klasa, jedno zastosowanie lol
func _init(limit: int = Constants.MAX_INT, starting_value: int = 0, r_limit: int = starting_value, reps: int = 0, increment_value: int = INCREMENT_VALUE, flags: Flags = Flags.new()):
	if limit == starting_value:
		#TODO: Test error that was assertion
		Log.error("Invalid parameters, limit shouldn't be equal to starting value(%d). Decrementing starting_value." % starting_value)
		starting_value -= Constants.ONE_ELEMENT
	
	# We set strict to validate r_limit properly which needs to happen before setting rest of flags
	_flags |= (flags.val & FlagsT.STRICT)
	_limit = limit
	_starting_value = starting_value
	_current_value = _starting_value
	_increment_value = increment_value
	if not set_r_limit(r_limit):
		remove_r_limit()
	
	set_flags(flags)
	set_increment_value(increment_value)
	set_repetitions(reps)
	
	if restarts_on_limit():
		finished.connect(restart)

## Reverse limit setter. Returns true if setting succeeded, false if value was invalid. Throws
## assertion in strict mode.
func set_r_limit(r_limit: int) -> bool:
	if _is_r_limit_valid(r_limit):
		_r_limit = r_limit
		return true
	if is_strict():
		Log.error("Invalid limit(%d)/r_limit(%d) values for starting value(%d)." % [_limit, r_limit, _starting_value])
	return false

func _is_r_limit_valid(r_limit: int) -> bool:
	return not ((_limit > _current_value && r_limit > _current_value) || (_limit < _current_value && r_limit < _current_value))

## Check if STRICT flag is set
func is_strict() -> bool:
	return _flags & FlagsT.STRICT

## Reverse limit "removal". It sets reverse limit to max/lowest possible value, depending on limit.
func remove_r_limit():
	Log.warning("Invalid limit(%d)/r_limit(%d) values for starting value(%d). Removing reverse limit." % [_limit, _r_limit, _starting_value])
	if _limit > _current_value:
		_r_limit = Constants.MIN_INT
	else:
		_r_limit = Constants.MAX_INT

## This function returns true if flags were set as user wanted, if there were forced adjustments
## made, it returns false instead. Flags are less important than current value and limit.
func set_flags(flags: Flags) -> bool:
	_flags = flags.val
	return not _adjust_flags()


func _adjust_flags() -> bool:
	var adjusted: bool = false
	
	if _limit < 0 || _current_value < 0 || _r_limit < 0:
		if not _flags & FlagsT.NEGATIVE:
			adjusted = true
		_flags |= FlagsT.NEGATIVE
	
	if _limit < _current_value:
		if not _flags & FlagsT.REVERSE:
			adjusted = true
		_flags |= FlagsT.REVERSE
	
	return adjusted

## Changes increment value. Changes sign if counter is reversed.
func set_increment_value(increment_value: int):
	#TODO: Test setting increment value equal to 0
	if increment_value == 0:
		Log.warning("Failed to set increment value equal to 0.")
		return
	if is_reverse():
		increment_value = -increment_value
	_increment_value = increment_value

## Checks if counter is reversed (incrementing value will decrement it etc.).
func is_reverse() -> bool:
	return _flags & FlagsT.REVERSE

# TODO/NOTE/CAUTION: Consider implementing proper division between assertions and warnings.
# Should invalid limit throw assertion or warning, when and why? This is something that should
# be defined and standarized. 
#
# No. It should clamp and mention in warning that value over limit was tried to be pushed

func _limited_modifier(modifier: int) -> int:
	if _r_limit <= _current_value && _r_limit < _limit:
		modifier = clamp(modifier, _r_limit - _current_value, _limit - _current_value)
	elif _r_limit >= _current_value && _r_limit > _limit:
		modifier = clamp(modifier, _limit - _current_value, _r_limit - _current_value)
	return modifier

## If it's higher than 0, internal counter is being started that will increment each time main
## counter reaches limit. Value then is reset to number, signal about repetition being finished is emited
## and internal counter gets incremented. After internal counter reaches it's limit, it calls to
## main counter to finish.
func set_repetitions(reps: int):
	if is_strict() && (reps < 0):
		# TODO: Negative counter test for strict? Think if strict is even necessary
		Log.warning("Tried to use negative counter (%d)." % reps)
	else:
		reps = clamp(reps, 0, Constants.MAX_INT)

	_total_repetitions = reps
	
	if _total_repetitions > 0:
		_repetition_counter = Counter.new(_total_repetitions)
		_repetition_counter.connect("finished", finish)
	else:
		_repetition_counter = null

## Check if RESTART flag is set.
func restarts_on_limit() -> bool:
	return _flags & FlagsT.RESTART

## Restarts counter's current value and repetitions, not settings!
func restart():
	_current_value = _starting_value
	set_repetitions(_total_repetitions)
	_is_finished = false

## Adds preconfigured modifier (by default, 1) to current value. Emits incremented signal.
## When used with FAST flag, it doesn't check limits.
func increment():
	var increment_value: int = _increment_value
	if not is_fast():
		increment_value = _limited_modifier(increment_value)
	_increment(increment_value)

## Check if FAST flag is set. FAST and STRICT can't work together.
func is_fast() -> bool:
	return _flags & FlagsT.FAST

func _increment(increment_value: int):
	if not _is_finished:
		_current_value += increment_value
		incremented.emit()
		_check_if_limit_was_reached()

func _check_if_limit_was_reached():
	if (_current_value >= _limit && _r_limit < _current_value) || (_current_value <= _limit && _r_limit > _current_value):
		_on_limit_reach()
	elif (_limit > _current_value && _current_value >= _r_limit) || (_limit < _current_value && _current_value <= _r_limit) :
		reverse_limit_reached.emit()

func _on_limit_reach():
	if is_oneshot():
		finish()
	else:
		repetition_finished.emit()
		_repetition_counter.increment()
		_current_value = _starting_value

## Checks if there are any repetitions planned.
func is_oneshot():
	return _repetition_counter == null

## Reverse incrementation with decremented signal emission.
func decrement():
	var decrement_value: int = -_increment_value
	if not is_fast():
		decrement_value = _limited_modifier(decrement_value)
	_decrement(decrement_value)

func _decrement(decrement_value: int):
	if not _is_finished:
		_current_value += decrement_value
		decremented.emit()
		_check_if_limit_was_reached()

## Allows to add any int value to current counter's value.
func add(modifier: int):
	if modifier == 0:
		return
	if not is_fast():
		modifier = _limited_modifier(modifier)
	_add(modifier)

func _add(modifier: int):
	if not _is_finished:
		_current_value += modifier
		changed.emit(modifier)
		_check_if_limit_was_reached()

## Reverse add operation.
func subtract(modifier: int = 1):
	add(-modifier)

## Check if NEGATIVE flag was set. Set automatically when limit, starting_value or r_limit
## are negative.
func can_be_negative() -> bool:
	return _flags & FlagsT.NEGATIVE

## Returns combined string to display current flags set.
func get_flags_str() -> String:
	var array: PackedStringArray = []
	if is_reverse():
		array.push_back("REVERSE")
	if can_be_negative():
		array.push_back("NEGATIVE")
	if restarts_on_limit():
		array.push_back("RESTART")
	if _flags & FlagsT.STRICT:
		array.push_back("STRICT")
	return ", ".join(array)

## Get number of total repetitions
func get_total_repetitions() -> int:
	return _total_repetitions

## Checks how many repetitions are left
func get_repetitions_left() -> int:
	if _repetition_counter != null:
		return _total_repetitions - _repetition_counter.get_value()
	return _total_repetitions

## Getter for reverse limit
func get_reverse_limit() -> int:
	return _r_limit

## Getter to check current increment value
func get_increment_value() -> int:
	return _increment_value
