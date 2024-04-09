extends RefCounted

## Structure to contain information about [Process] updates. 
##
## It has intuitive, easy to use constructor that takes [Variant] as argument.[br][br]
## Possible arguments are:[br]
##  -   Update,[br]
##  -   [Array] [[float]] - Intervals,[br][code]CAUTION:[/code] Implicit array with two floats will be
## interpreted as duration and constant interval.[br]
##
##  -   [Array] = [[float], [float]/[int]] - Duration and number of steps/interval between each update,[br]
##      [code]CAUTION:[/code] Typed array will be interpreted as array of intervals,[br]
## [code]CAUTION:[/code] Const [Array] with same type values are force casted to typed arrays.[br]
##
##  -   [Array] = [[float], [Modifier]] - Interval and modifier [code] ONLY USED FOR CALLABLE UPDATE [/code][br]
##  -   [Array] = [[Array][[float]], [Array][[Modifier]]] - Array of intervals and modifiers to apply in each step,[br]
## [code]CAUTION:[/code] Both arrays sizes should be equal.[br]
##  -   [Callable] - callable that returns valid update with interval (time till next call) and modifier to apply[br]
## [code]CAUTION:[/code] First update modifier is not applied, can be null.[br]
##  -   [Signal] - signal that will be connected to update and will call update with proper modifiers directly[br][br]
##
## Validation takes place during object construction. To get information if object was created 
## successfuly, use method [method is_valid].[br]
##
## Creating Update object is as must to update any [Process].
class_name Update

## Classification based on constructor parameter
enum Type { 
	## Each object starts with invalid state and changes type after type interpretation and data validation.[br]
	## if it's still invalid, it means that incorrect parameters were passed during object construction and update
	## should be discarded.
	INVALID, 
	## Dictionary with array of intervals(seconds in float format), number of steps per update is equal to it's size.
	INTERVALS, 
	## Information about modifier to apply and time between next call, used in Callable update.
	INTERVAL_WITH_MODIFIER, 
	## Dictionary with intervals and modifiers, number of steps per update is equal to any array size. Sizes are equal. 
	INTERVALS_AND_MODIFIERS, 
	## Dictionary with constant update interval and total number of update steps that process update consists of.
	INTERVAL_WITH_UPDATE_STEPS, 
	## Callable being called to get time to next update and modifier to apply in current step.
	CALLABLE, 
	## Signal connected directly to update, it should emit modifiers necessary to apply for process update.
	SIGNAL,
}

## Minimal time between updates in seconds. Originally based on Timer restriction but might change in future.
const MIN_TIME_BETWEEN_UPDATES: float = Constants.MIN_TIME_BETWEEN_UPDATES

## Minimum steps update has to consist of.
const MIN_UPDATE_STEPS: int = 1

## Interval [Dictionary] key used in [enum INTERVAL_WITH_MODIFIER] and [enum INTERVAL_WITH_UPDATE_STEPS].
const INTERVAL_KEY: String = "interval"

## Interval array [Dictionary] key used in [enum INTERVALS] and [enum INTERVALS_AND_MODIFIERS].
const INTERVALS_KEY: String = "intervals"

## Modifier [Dictionary] key used in [enum INTERVAL_WITH_MODIFIER].
const MODIFIER_KEY: String = "modifier"

## Modifier array [Dictionary] key used in [enum INTERVALS_AND_MODIFIERS].
const MODIFIERS_KEY: String = "modifiers"

## Number of steps [Dictionary] key used in [enum INTERVALS], [enum INTERVALS_AND_MODIFIERS] and [enum INTERVAL_WITH_UPDATE_STEPS].
const STEPS_KEY: String = "steps"

const _DURATION_INDEX: int = 0
const _DESCRIPTOR_INDEX: int = 1
const _INTERVALS_ARRAY_INDEX: int = 0
const _MODIFIERS_ARRAY_INDEX: int = 1

## Timer used to schedule process updates.
var timer: AdvancedTimer = null

var _value: Variant = null:
	get = get_value
	
var _type: Type = Type.INVALID:
	get = get_type


func _init(variant: Variant, should_copy: bool = false):
	const VALID_CONTENT: PackedStringArray = [
		"Update",
		"Array[float]",
		"Array = [float, float/int]",
		"Array = [float, Modifier]",
		"Array = [Array[float], Array[Modifier]]",
		"Callable",
		"Signal",
	]

	if variant is Update:
		_copy_constructor(variant, should_copy)
	else:
		_type = _identify_type(variant)
		match(_type):
			Type.INVALID:
				Log.error("Invalid variant(%s).\nAccepted variants are: %s" % [type_string(typeof(variant)), str(VALID_CONTENT)])
			Type.INTERVALS:
				_initialize_intervals(variant, should_copy)
			Type.INTERVAL_WITH_MODIFIER:
				_initialize_single_interval_with_modifier(variant)
			Type.INTERVALS_AND_MODIFIERS:
				_initialize_intervals_with_modifiers(variant, should_copy)
			Type.INTERVAL_WITH_UPDATE_STEPS:
				_initialize_interval_with_step_count(variant)
			Type.CALLABLE:
				_initialize_callable(variant)
			Type.SIGNAL:
				_value = variant


func _copy_constructor(update: Update, should_copy: bool):
	if (update.get_value() is Array || update.get_value() is Dictionary) && should_copy:
		_value = update.get_value().duplicate(true)
	else:
		_value = update.get_value()
	_type = update._type


#region Identification
func _identify_type(variant: Variant) -> Type:
	const _VALID_VARIANT_ARRAY_SIZE: int = 2
	
	var type: Type = Type.INVALID
	
	if variant is Signal:
		type = Type.SIGNAL
	
	elif variant is Callable:
		type = Type.CALLABLE
	
	# NOTE: Constant implicit array with floats will be interpreted as typed array (Array[] becomes Array[float]
	# This can cause some problems so it's important to write it down
	elif not variant is Array[float] && variant is Array && variant.size() == _VALID_VARIANT_ARRAY_SIZE:
		if _has_duration_and_descriptor(variant):
			type = Type.INTERVAL_WITH_UPDATE_STEPS
		
		elif _has_single_interval_and_modifier(variant):
			type = Type.INTERVAL_WITH_MODIFIER
		
		elif _has_intervals_and_modifiers(variant):
			type = Type.INTERVALS_AND_MODIFIERS
	
	elif _has_intervals(variant):
		type = Type.INTERVALS
	
	return type


func _has_duration_and_descriptor(variant: Variant) -> bool:
	return variant[_DURATION_INDEX] is float && (variant[_DESCRIPTOR_INDEX] is float || variant[_DESCRIPTOR_INDEX] is int)

func _has_single_interval_and_modifier(variant: Variant) -> bool:
	return variant[_INTERVALS_ARRAY_INDEX] is float && variant[_MODIFIERS_ARRAY_INDEX] is Modifier

func _has_intervals_and_modifiers(variant: Variant) -> bool:
	return (variant[_INTERVALS_ARRAY_INDEX] is Array[float] || Functions.is_implicitly_typed_array(variant[_INTERVALS_ARRAY_INDEX], TYPE_FLOAT) &&
		(variant[_MODIFIERS_ARRAY_INDEX] is Array[Modifier] || Functions.is_implicitly_typed_array(variant[_MODIFIERS_ARRAY_INDEX], TYPE_OBJECT, "Modifier")))

func _has_intervals(variant: Variant) -> bool:
	return variant is Array[float] || Functions.is_implicitly_typed_array(variant, TYPE_FLOAT)
#endregion
#region Initialization
func _initialize_intervals(variant: Variant, should_copy):
	if variant.is_empty():
		Log.error("Interval array is empty, update is invalid!")
		_type = Type.INVALID
	else:
		var intervals: Array = _valid_interval_array(variant, should_copy)
		_value = { INTERVALS_KEY: intervals , STEPS_KEY: intervals.size() }


func _valid_interval_array(interval_array: Variant, should_copy: bool) -> Array:

	var valid_array: Array = _get_validated_interval_array(interval_array, should_copy)
	
	if not valid_array.is_empty():
		return valid_array
	
	if not interval_array is Array[float]:
		var array: Array[float] = []
		array.assign(interval_array)
		interval_array = array
	
	if should_copy:
		return interval_array.duplicate()
	
	return interval_array


func _get_validated_interval_array(interval_array: Variant, should_copy: bool) -> Array:
	var warn: bool = false
	var fixed_intervals: Array = []
	var float_fixed_intervals: Array[float] = []
	var invalid_intervals: Array[int] = []
	
	if interval_array is Array[float]:
		fixed_intervals = float_fixed_intervals
		
	for i in range(interval_array.size()):
		if not _is_interval_valid(interval_array[i]):
			if not warn:
				if not should_copy:
					fixed_intervals = interval_array
				else:
					fixed_intervals = interval_array.duplicate()
				warn = true
			
			fixed_intervals[i] = MIN_TIME_BETWEEN_UPDATES
			invalid_intervals.push_back(i)
	
	if warn:
		Log.warning("Interval array(%s) contains invalid values in indexes: (%s)!\nSetting them to minimal value(%f)" % 
				[str(interval_array), str(invalid_intervals), MIN_TIME_BETWEEN_UPDATES])
	
	return fixed_intervals


func _is_interval_valid(interval: float) -> bool:
	return interval >= MIN_TIME_BETWEEN_UPDATES


func _initialize_single_interval_with_modifier(variant: Variant):
	var interval: float = variant[_INTERVALS_ARRAY_INDEX]
	var modifier: Modifier = variant[_MODIFIERS_ARRAY_INDEX]
	
	if not _is_interval_valid(interval):
		Log.warning("Update interval(%f) is invalid. Setting minimal value(%f)." % [interval, MIN_TIME_BETWEEN_UPDATES])
		interval = MIN_TIME_BETWEEN_UPDATES
	
	_value = { INTERVAL_KEY: interval, MODIFIER_KEY: modifier } 


func _initialize_intervals_with_modifiers(variant: Variant, should_copy: bool):
	if variant[_MODIFIERS_ARRAY_INDEX].size() != variant[_INTERVALS_ARRAY_INDEX].size():
		Log.error("Size of modifiers array(%d) is different than size of intervals array(%d)!" % 
				[variant[_MODIFIERS_ARRAY_INDEX].size(), variant[_INTERVALS_ARRAY_INDEX].size()])
		_type = Type.INVALID
	else:
		var intervals: Array[float] = _valid_interval_array(variant[_INTERVALS_ARRAY_INDEX], should_copy)
		var modifiers: Array[Modifier] = []
		modifiers.assign(variant[_MODIFIERS_ARRAY_INDEX])
		
		if should_copy:
			var modifiers_copy: Array[Modifier] = []
			for modifier in modifiers:
				modifiers_copy.push_back(Modifier.new(modifier))
			modifiers = modifiers_copy
		
		_value = { INTERVALS_KEY: intervals, MODIFIERS_KEY: modifiers, STEPS_KEY: intervals.size() }


func _initialize_interval_with_step_count(variant: Variant):
	if variant[_DURATION_INDEX] < MIN_TIME_BETWEEN_UPDATES:
		Log.error("Duration(%f) is shorter than one possible interval(%f)." % 
				[variant[_DURATION_INDEX], MIN_TIME_BETWEEN_UPDATES])
		_type = Type.INVALID
	else:
		_value = _interval_with_step_count(variant)


func _interval_with_step_count(variant: Variant) -> Dictionary:
	var interval: float = variant[_DESCRIPTOR_INDEX]
	var steps: int = variant[_DESCRIPTOR_INDEX]
	
	match typeof(variant[_DESCRIPTOR_INDEX]):
		Variant.Type.TYPE_INT:
			if steps <= 0:
				Log.warning("Update step count(%d) is less than 0. Setting minimal value(%d)." % [steps, MIN_UPDATE_STEPS])
				steps = MIN_UPDATE_STEPS
			
			interval = variant[_DURATION_INDEX] / float(steps)
		Variant.Type.TYPE_FLOAT:
			if not _is_interval_valid(interval):
				Log.warning("Update interval(%f) is invalid. Setting minimal value(%d)." % 
						[interval, MIN_TIME_BETWEEN_UPDATES])
				interval = MIN_TIME_BETWEEN_UPDATES
			
			steps = int(variant[_DURATION_INDEX]/interval)
		
	return { INTERVAL_KEY: interval, STEPS_KEY: steps }


func _initialize_callable(callable: Callable):
	if not callable.is_valid():
		Log.error("Invalid callable!")
		_type = Type.INVALID
	else:
		_value = callable
#endregion
#region Utilities
## Returns data necessary to schedule process updates.
func get_value():
	return _value

## Returns update type.
func get_type() -> Type:
	return _type

## Returns true if type is not [enum INVALID].
func is_valid() -> bool:
	return _type != Type.INVALID
#endregion
