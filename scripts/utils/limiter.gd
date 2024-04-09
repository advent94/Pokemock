extends RefCounted

## Wrapper to store and operate with different limits. 
## 
## Limiter supports [Timer], [Counter] and [Signal]. It translates [int] input
## as [Counter] limit and [float] as time in seconds. [Timer] should be started,
## [Counter] incremented, [Signal] emitted. This class wraps it all around.[br][br]
##
## Usage:
## [codeblock]var limiter: Limiter = Limiter.new(limit)
## limiter.add_observer(method_to_call_after_limiter_activates)
## ...
## limiter.start() / limiter.increment() / ... somewhere signal gets called
## ...
## [inside limiter's value, signal is called to activate, this leads to calling observers]
## [/codeblock]

class_name Limiter

## Possible types.
enum Type { 
	INVALID,
	COUNTER,
	TIMER,
	SIGNAL,
}

## Minimum number of [Counter] ticks.
const MIN_TICKS: int = 1

## Minimal time for [Timer] to timeout.
const MIN_TIMEOUT: float = Constants.MIN_TIME_BETWEEN_UPDATES

var _value: Variant

#region Initialization
func _init(limit: Variant = MIN_TICKS, owner: Node = null):
	set_limit(limit, owner)

## Sets new limit.[br]
## [code]CAUTION:[/code] Beware of setting new limit before clearing up existing [Timer].
func set_limit(limit: Variant, owner: Node = null):
	if _value != null && _value is Timer:
		Log.warning("Reusing Timer based limiter. Make sure that existing Timer is properly removed.")
	
	limit = _validate(limit)
	
	if limit is int:
		_value = Counter.new(limit)
		return
	
	if _should_use_global_timers(limit, owner):
		Log.warning("Null owner for Timer based Limiter. Changing to default(Global Timers)")
		owner = Timers
		
	if limit is float:
		_value = _create_new_timer(limit, owner)
		return
	
	if limit is Timer:
		if limit.get_parent() == null:
			Log.warning("Timer with null parent as limit. Adding child to specified owner.")
			owner.add_child(limit)
	
	_value = limit


func _validate(limit: Variant) -> Variant:
	const ALLOWED_LIMIT_VARIANTS: PackedStringArray = [
		"int", "float", "Counter", "Timer", "Signal"
	]

	if limit == null:
		Log.error("Limit is null! Limiter is invalid.")
	
	elif limit is int:
		if limit < MIN_TICKS:
			Log.warning("Number of ticks(%d) is lower than minimal allowed number of ticks(%d). Changed to %d." % 
					[limit, MIN_TICKS, MIN_TICKS])
			limit = MIN_TICKS
		
	elif limit is float:
		if limit < MIN_TIMEOUT:
			Log.warning("Timeout(%f) is lower than minimal allowed value(%f). Changed to %f." % [limit, MIN_TIMEOUT, MIN_TIMEOUT])
			limit = MIN_TIMEOUT
	
	elif not (limit is Counter) && not (limit is Timer) && not (limit is Signal):
		Log.error("Invalid limit(%s). Allowed limit variants are: %s" % [str(limit), str(ALLOWED_LIMIT_VARIANTS)])
		limit = null
	
	return limit

func _should_use_global_timers(limit: Variant, owner : Node) -> bool:
	return ((limit is float) || (limit is Timer && limit.get_parent() == null)) && owner == null

func _create_new_timer(limit: float, owner: Node) -> Timer:
	var timer: Timer = AdvancedTimer.new(limit)
	timer.name = "Limiter"
	owner.add_child(timer)
	timer.timeout.connect(timer.queue_free)
	timer.tree_exited.connect(func(): _value = null)
	return timer
#endregion
#region Observers Management
## Removes observer call.
func remove_observer(callable: Callable):
	if is_valid():
		if _value is Counter:
			_value.finished.disconnect(callable)
		elif _value is Timer:
			_value.timeout.disconnect(callable)
		elif _value is Signal:
			_value.disconnect(callable)


## Adds observer that will be called after limiter activates.
func add_observer(callable: Callable):
	if is_valid():
		if _value is Counter:
			_value.finished.connect(callable)
		elif _value is Timer:
			_value.timeout.connect(callable)
		else:
			_value.connect(callable)
#endregion
#region Flow Control
## Starts [Timer].
func start() -> bool:
	if is_valid():
		if _value is Timer:
			_value.start()
			return true
	
	return false


## Stops [Timer].
func stop() -> bool:
	if is_valid():
		if _value is Timer:
			_value.stop()
			return true
	
	return false


#TODO: Add test to flag in reset
## Restarts [Timer] or [Counter].
func reset(should_start: bool = true):
	if is_valid():
		if _value is Timer:
			_value.stop()
			
			if should_start:
				_value.start()
		
		elif _value is Counter:
			_value.restart()


## Pauses [Timer].
func pause() -> bool:
	if is_valid():
		if _value is Timer:
			(_value as AdvancedTimer).pause()
			return true
	
	return false


## Resumes paused [Timer].
func resume() -> bool:
	if is_valid():
		if _value is Timer:
			(_value as AdvancedTimer).resume()
			return true
	
	return false


## Increments [Counter].
func increment() -> bool:
	if is_valid():
		if _value is Counter:
			_value.increment()
			return true
	
	return false
#endregion
#region Utilities
## Returns limit. Seconds for [Timer], ticks for [Counter], signal for [Signal], null if invalid.
func get_limit() -> Variant:
	if is_valid():
		if _value is Timer:
			return _value.wait_time
		elif _value is Counter:
			return _value.get_limit()
	
	return _value


## Returns time/ticks left. Seconds for [Timer], ticks for [Counter]. Returns null if not applicable.
func left() -> Variant:
	if is_valid():
		if _value is Timer:
			if not _value.is_stopped():
				return _value.time_left
			else:
				return _value.wait_time
		
		elif _value is Counter:
			return _value.get_limit() - _value.get_value()
	
	return null	


## Returns information if limiter is active (specially useful to check [Timer] status)
func is_active() -> bool:
	if is_valid():
		if _value is Timer:
			return not _value.paused && not _value.is_stopped()
		else:
			return true
	return false


## Returns information if [Timer] limiter is paused.
func is_paused() -> bool:
	if is_valid() && _value is Timer:
		return _value.paused
		
	return false


## Returns type of used limiter.
func get_type() -> Type:
	if _value is Timer:
		return Type.TIMER
	elif _value is Counter:
		return Type.COUNTER
	elif _value is Signal:
		return Type.SIGNAL
	
	return Type.INVALID


## Checks if limiter was initialized properly and it's value isn't null.
func is_valid() -> bool:
	return _value != null
#endregion
