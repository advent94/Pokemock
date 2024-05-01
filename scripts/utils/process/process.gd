extends Node

## Base, abstract class and template for every single process. 
## 
## Provides basic structure that supports
## all necessary functionalities such as setup, start, update, pause, resume, restart, stop, finish, 
## termination, flags for being valid, active, paused, permanent, repeatable, [Limiter] based lifetime as
## well useful signals to inform whenever state changes.[br][br]
##
## [Limiter] is an amazing lifespan variant based entity that supports limits based on repetition, time 
## being active or lasts till we call termination signal. More information in [Limiter] class description.[br][br]
##
## [Update] is based on [Modifier] that is meant to change object's state in expected way. Each
## [Modifier] has it's own type that should be supported by specific type of process. Various processes
## can have same type when using same [Modifier] as it's base factor for classification.[br][br]
##
## Usage:
##
##[codeblock]func _init(update_args: Variant, args... , permanent: bool = false):
##    _type = Type.YOUR_TYPE
##    var callable: Callable = func(): your_init_method(args)
##    super(callable, update_args, permanent)
##
## # This method doesn't have to be inside class, just pass it through callable, it can be init arg.
## # If initialization can fail, make it a bool and return result. On false, error will be handled.
##func your_init_method(args):	
##    <initialize with args>
##
##func _update(modifier: Modifier) -> bool:
##    var success: bool = true
##    var result: bool = <use modifier to update state and get result>
##    if result == FAILED:
##        <do something about it>
##        success = false
##    else:
##        <maybe log or something>
##    return success
##
##func _pause() -> bool:
##    var success: bool = true
##    var result: bool = <perform some necessary changes for pause and get result>
##    if result == FAILED:
##        <do something about it>
##        success = false
##    return success
##
##func _resume() -> bool:
##    var success: bool = true
##    var result: bool = <perform some necessary changes for resume and get result>
##    if result == FAILED:
##        <do something about it>
##        success = false
##    return success
##
##func _get_default_modifier(step: int, step_count: int) -> Modifier:
##    return <your default modifier calculated based on current and total steps>
##
## # Implementing it as bool is not necessary if your clean up (or other functions) can't fail!
##func _stop():
##    <clean_up>
##[/codeblock]
##
## Real example:
##[codeblock]func _init(update_args: Variant, color: Color = Color.WHITE, affects_transparency: bool = false, permanent: bool = false):
##    _type = Type.FADE
##    var callable: Callable = func(): initialize_shader(color, affects_transparency)
##    super(callable, update_args, permanent)
##
##func initialize_shader(color: Color, affects_transparency: bool):	
##    owner.material.set_shader_parameter(FADE_COLOR, color)
##    owner.material.set_shader_parameter(FADE_AFFECTS_TRANSPARENCY, affects_transparency)
##    owner.material.set_shader_parameter(FADE_ACTIVE, true)
##
##func _update(modifier: Modifier):
##    owner.material.set_shader_parameter(FADE_MODIFIER, modifier.value)
##
##func _get_default_modifier(step: int, step_count: int) -> Modifier:
##    return FadeModifier.new(float(step)/step_count)
##
##func _stop():
##    owner.material.set_shader_parameter(FADE_ACTIVE, false)
##    owner.material.set_shader_parameter(FADE_MODIFIER, FadeModifier.MIN_COLOR_VALUE)
##[/codeblock]

# TODO: Update with link to concrete class family when one is finished

class_name Process

signal started
signal updated
signal iterated
signal paused
signal resumed
signal restarted
signal stopped
signal finished
signal killed
signal terminating

# NOTE: Implementing keep_alive flag set up during runtime can be possible if necessary but
# I found no reason to do that as process should have determined if it's good idea to keep
# it alive after last update was done/repetitions finished and if it can repeat at all.

# NOTE: ACTIVE flag could be replaced with states or just more flags like STARTING/RUNNING/STOPPING/UPDATING
# it's might not be necessary but definitely good reminder/idea to sit on.

## Flags that can describe process state. They shouldn't be set manually.
enum Flags { 
	## Process was setup properly with valid update and didn't encounter any error.
	VALID = 1, 
	## Process was started and is currently being executed or paused.
	ACTIVE = 2, 
	## Process is paused, waiting for resume.
	PAUSED = 4, 
	## Process can be repeated. Necessary to support iterations.
	REPEATABLE = 8, 
	## Process is kept alive after finish in final state.
	KEEP_IN_FINAL_STATE = 16, 
	## Process is finished but still alive.
	FINISHED = 32,
	## Process is being kept alive till killed/stopped manually.
	PERMANENT = 64,
}

var _flags: int = Constants.NO_FLAGS:
	get = get_flags

var _type: int = Constants.NOT_FOUND:
	get = get_type

## Structure storing update value as well as it's type. Used for periodic updates.
var update: Update = null

## Lifespan guardian. Once limit is passed, unless process is kept alive, it should be removed.
var limiter: Limiter = null

# NOTE: This is not a method itself because it might have different arguments and it's meant to be 
# called with same arguments (ones that are passed in concrete class object constructor)
var _initialization: Callable

#region Setup
func _init(init_method: Callable, update_args: Variant = null, permanent: bool = false, keep_final: bool = false):
	if not is_active():
		set_initialization(init_method)
		
		if permanent:
			_flags |= Flags.PERMANENT
			if keep_final:
				_flags |= Flags.KEEP_IN_FINAL_STATE
		
		if _initialization.is_valid():
			_flags |= Flags.VALID
		
		if update_args != null:
			set_update(update_args)	
	else:
		Log.warning("Tried to call \"init(callable, update = %s, permanent = %s)\" during active %s." % [str(update_args), str(permanent), get_identity()])

## Setter for initialization. If should_restart is set to true, it will stop process, set new initialization
## method and start process using new initialization.
func set_initialization(init_method: Callable, should_restart: bool = false):
	if init_method.is_valid():
		if not should_restart:
			_initialization = init_method
		else:
			restart(func(): _initialization = init_method)


## Setter for update. If update was already set, it will stop process, set validate and set a new update
## and start process setting up new updates.
func set_update(args: Variant):
	if update != null:
		return _restart_with_new_update(args)
	
	return _handle_update_setup(args)


func _restart_with_new_update(args: Variant):
	restart(func(): _handle_update_setup(args))

func _handle_update_setup(args: Variant):
	update = Update.new(args)
	
	match(update.get_type()):
		Update.Type.INVALID, Update.Type.INTERVAL_WITH_MODIFIER:
			_handle_invalid_update()
		Update.Type.SIGNAL:
			_handle_signal_update()
		Update.Type.CALLABLE:
			_flags &= ~Flags.PERMANENT
		_:
			_flags |= Flags.REPEATABLE


func _handle_invalid_update():
	Log.error("Invalid update data. %s \"%s\" wasn't initialized properly." % [get_identity().to_pascal_case(), get_type_str()])
	_flags &= ~Flags.VALID


func _handle_signal_update():
	var terminator = update.get_value()
	
	if terminator != null && terminator is Signal:
		terminator.connect(_signal_update)
	else:
		_handle_invalid_update()
	
	_flags &= ~Flags.PERMANENT
#endregion
#region Termination

## [code]USE WITH CAUTION[/code][br]
## Method to kill process without proper clean up. It's generally used when stop
## returns errors or there is some issue with removing current process.
func terminate():
	const TIME_FOR_CLEAN_UP: float = Constants.MIN_TIME_BETWEEN_UPDATES
	
	terminating.emit()
	var signals = [started, updated, iterated, paused, resumed, restarted, stopped, killed, terminating]
	for sig in signals:
		Functions.disconnect_all(sig)
	await _remove_active_timer()
	await Functions.wait(TIME_FOR_CLEAN_UP)
	free()

## Method that stops the process before finishing it. Used when faults are reported
## or when owner is removed before effect finishes. Safe to be called to kill faulty process.
func die():
	_flags &= ~Flags.VALID
	_finish()
	
	if _should_terminate():
		terminate()
	else:
		queue_free()
		killed.emit()


func _should_terminate() -> bool:
	return get_parent() == null || killed.get_connections().is_empty()

func _handle_error(msg: String):
	Log.error(msg)
	return die()
#endregion
#region Start
## After initialization and updates are set and process is valid, it is necessary to call this
## method to start the process. If process is already active when method is called, nothing will happen
## unless restart is forced. If initialization or update validation fail, process will be killed.
func start(should_force_restart: bool = false):
	if is_active():
		if should_force_restart:
			restart()
	
	elif is_valid():
		_flags |= Flags.ACTIVE
		
		if not _initialize():
			return _handle_error("Initialization failed! Couldn't start %s \"%s\"." % [get_identity(), get_type_str()])
			
		if limiter != null: 
			limiter.start()
		
		started.emit()
	else:
		return _handle_error("Tried to start invalid %s \"%s\"." % [get_identity(), get_type_str()])


func _initialize() -> bool:
	var init_result = _initialization.call()
	
	if init_result != null && init_result is bool && init_result == false:
		return false
	
	if _should_update():
		_execute_update()
	
	return true
#endregion
#region Update
func _should_update() -> bool:
	return update != null && not (update.get_type() == Update.Type.SIGNAL)


func _signal_update(modifier: Modifier):
	if not is_valid():
		return _handle_error("Tried to update invalid %s \"%s\"." % [get_identity(), get_type_str()])
	
	elif is_paused() || not is_active():
		# NOTE: Could add log here
		return
	
	elif modifier == null:
		return _handle_error("Null modifier. Killing %s." % get_identity())
		
	elif modifier._type != _type:
		return _handle_error("Invalid modifier type(%s). Type expected: %s. Killing %s." % [modifier.get_type_str(), get_type_str(), get_identity()])
	
	else:
		var update_result = _update(modifier)
		
		if update_result != null && update_result is bool && update_result == false:
			return _handle_error("Update failed! Killing %s \"%s\"." % [get_identity(), get_type_str()])
		
		updated.emit()


## Step value used to identify when we don't need to capture modifiers and call a new update.
const INITIALIZATION: int = -1

## Helper.
const FIRST_STEP: int = 0

## Value used to determine when intervals are corrupted.
const CORRUPTED_INTERVAL: float = -2.137

# NOTE: Options in future: implement different error handling mechanism. Differentiate execute_update
# based on _type of update provided (implement separate function for each type of update or for each
# different group of updates)

# NOTE: Not every check seems to be necessary. It's over the top protection in case update gets
# corrupted after being created. It's fine for now, if it will somehow negatively impact performance,
# remove additional checks.
func _execute_update(step: int = INITIALIZATION):
	if update == null:
		return _handle_error("Null update! Killing %s \"%s\"." % [get_identity(), get_type_str()])
	
	var modifier: Modifier 
	var interval: float
	var update_id: int = step - INITIALIZATION
	
	if update.get_type() == Update.Type.CALLABLE:
		var called_update = update.get_value().call(step)
		
		if called_update == null:
			return _finish()
		
		elif not (called_update is Update) || called_update is Update && called_update._type != Update.Type.INTERVAL_WITH_MODIFIER:
			return _handle_error("Invalid update data received from update call(id = %d). Killing %s \"%s\"." % [update_id, get_identity(), get_type_str()])
		
		else:
			if ((called_update.get_value().keys().has(Update.MODIFIER_KEY) && called_update.get_value()[Update.MODIFIER_KEY] is Modifier) && 
					(called_update.get_value().keys().has(Update.INTERVAL_KEY) && called_update.get_value()[Update.INTERVAL_KEY] is float)):
				modifier = called_update.get_value()[Update.MODIFIER_KEY]
				interval = called_update.get_value()[Update.INTERVAL_KEY]
			else:
				return _handle_error("Corrupted update received from update call(id = %d)! Killing %s \"%s\"" % [update_id, get_identity(), get_type_str()])
	
	elif step != INITIALIZATION:
		modifier = _get_modifier(step)
	
	if step != INITIALIZATION:
		if modifier == null:
			return _handle_error("Null modifier. Killing %s \"%s\"." % [get_identity(), get_type_str()])
			
		if modifier._type != _type:
			return _handle_error("Invalid modifier type(%s). Type expected: %s. Killing %s." % [modifier.get_type_str(), get_type_str(), get_identity()])
		
		var update_result = _update(modifier)
		
		if update_result != null && update_result is bool && update_result == false:
			return _handle_error("Update(id = %d) failed! Killing %s \"%s\"." % [update_id, get_identity(), get_type_str()])
		
		updated.emit()
	
	if update.get_type() != Update.Type.CALLABLE:
		if step != INITIALIZATION:
			if _is_step_update_valid():
				if step == update.get_value()[Update.STEPS_KEY] - Constants.ZERO_INDEXING_OFFSET:
					return await _finish_iteration()
				
			else:
				return _handle_error("Corrupted update received in update(id = %d)! Killing %s \"%s\"." % [update_id, get_identity(), get_type_str()])
		

		interval = _get_interval(step + Constants.ONE_STEP)
		
		if is_equal_approx(interval, CORRUPTED_INTERVAL):
			return _handle_error("Corrupted interval.")
	
	elif not interval:
		return _finish()
		
	if interval < Update.MIN_TIME_BETWEEN_UPDATES:
		Log.warning("Invalid interval(%f), changing to minimal value(%f)." % [interval, Update.MIN_TIME_BETWEEN_UPDATES])
		interval = Update.MIN_TIME_BETWEEN_UPDATES
	
	_schedule_update(step + Constants.ONE_STEP, interval)


func _get_modifier(step: int) -> Modifier:
	var modifier: Modifier = null
	if update.get_type() == Update.Type.INTERVALS_AND_MODIFIERS:
		if _modifiers_found(step):
			modifier = update.get_value()[Update.MODIFIERS_KEY][step]
		else:
			return _handle_error("Corrupted modifier array. Killing %s \"%s\"" % [get_identity(), get_type_str()])
		
	else:
		if update.get_value() is Dictionary && update.get_value().keys().has(Update.STEPS_KEY) && update.get_value()[Update.STEPS_KEY] is int && update.get_value()[Update.STEPS_KEY] > 0:
			modifier = _get_default_modifier(step + Constants.ZERO_INDEXING_OFFSET, update.get_value()[Update.STEPS_KEY])
		else:
			return _handle_error("Corrupted structure, can't find steps. Killing %s \"%s\"" % [get_identity(), get_type_str()])
		
	return modifier


func _modifiers_found(index: int = Constants.NOT_FOUND) -> bool:
	return (update.get_value() is Dictionary && update.get_value().keys().has(Update.MODIFIERS_KEY) && update.get_value()[Update.MODIFIERS_KEY] is Array[Modifier] && 
			((update.get_value()[Update.MODIFIERS_KEY].size() - Constants.ZERO_INDEXING_OFFSET) >= index))

## Should be overloaded
func _get_default_modifier(_step: int, _max_steps: int) -> Modifier:
	return _handle_error("Invalid call! Try overloading this method.\nCorrupt modifier. Killing %s \"%s\"" % [get_identity(), get_type_str()])

func _is_step_update_valid() -> bool:
	return (update.get_value() is Dictionary && 
			update.get_value().keys().has(Update.STEPS_KEY) && 
			update.get_value()[Update.STEPS_KEY] is int && 
			update.get_value()[Update.STEPS_KEY] > 0)

## Should be overloaded
func _update(_modifier: Modifier) -> bool:
	Log.error("Invalid call! Try overloading this method.\nInvalid update called. Killing %s \"%s\"." % [get_identity(), get_type_str()])
	return false

# NOTE: Timer is not removed here unless we call finish before
# TODO: Make rest of visual effects implement is_repeatable/change flag to var
func _finish_iteration():
	if not is_repeatable():
		return _handle_error("FATAL ERROR! This %s cannot be repeated." % get_identity())
	
	if limiter != null:
		limiter.increment()
	
	iterated.emit()
	
	if is_permanent() && is_kept_in_final_state() && is_finished():
		return
	
	return await _start_new_iteration()


func _start_new_iteration():
	if is_active():
		await _remove_active_timer()
		
		var init_result = _initialize()
		
		if init_result != null && init_result is bool && init_result == false:
			return _handle_error("Initialization failed! Couldn't start new iteration (%s \"%s\")." % [get_identity(), get_type_str()])


# NOTE/TODO: Possible need for change not to wait? Maybe divide this between new iteration (just stop timer, 
# free it when finished) and termination. Would use await only for termination (faster updates)
func _remove_active_timer():
	if update != null && update.timer != null:
		update.timer.queue_free()
		await update.timer.tree_exited
		update.timer = null


func _get_interval(step: int) -> float:
	if update.get_type() == Update.Type.INTERVALS || update.get_type() == Update.Type.INTERVALS_AND_MODIFIERS:
		if (update.get_value() is Dictionary && update.get_value().keys().has(Update.INTERVALS_KEY) && update.get_value()[Update.INTERVALS_KEY] is Array && 
		(update.get_value()[Update.INTERVALS_KEY].size() - Constants.ZERO_INDEXING_OFFSET) >= step && update.get_value()[Update.INTERVALS_KEY][step] is float):
			return update.get_value()[Update.INTERVALS_KEY][step]
			
	elif update.get_type() == Update.Type.INTERVAL_WITH_UPDATE_STEPS:
		if (update.get_value() is Dictionary && update.get_value().keys().has(Update.INTERVAL_KEY) && update.get_value()[Update.INTERVAL_KEY] is float):
			return update.get_value()[Update.INTERVAL_KEY]
	return CORRUPTED_INTERVAL


func _schedule_update(next_step: int, interval: float):
	const NEW_TIMER_NAME: String = "Update"
	
	if update.timer == null:
		update.timer = AdvancedTimer.new(interval)
		update.timer.name = NEW_TIMER_NAME
		
	if update.timer.get_parent() == null:
		add_child(update.timer)
		
	Functions.disconnect_all(update.timer.timeout)
	update.timer.timeout.connect(func(): _execute_update(next_step))
	update.timer.wait_time = interval
	update.timer.one_shot = true
	update.timer.start()
#endregion
#region Lifecycle Control
## Pauses update timer, limiter and calls internal pause to pause the process.[br]
## Does nothing when called from invalid process.
func pause():
	if _should_pause():
		if limiter != null:
			limiter.pause()
		
		if update != null && update.timer != null:
			update.timer.pause()
		
		var pause_result = _pause()
		
		if pause_result != null && pause_result is bool && pause_result == false:
			return _handle_error("Pause failed! Killing %s \"%s\"." % [get_identity(), get_type_str()])
		
		_flags |= Flags.PAUSED
		paused.emit()


func _should_pause() -> bool:
	return is_valid() && not is_paused() && is_active()

## Can be overloaded to support pause.
func _pause():
	pass

## Resumes update timer, limiter and calls internal resume method to resume the process.[br]
## Does nothing when called from invalid process.
func resume():
	if _should_resume():
		if limiter != null:
			limiter.resume()
		
		if update != null && update.timer != null:
			update.timer.resume()
		
		var resume_result = _resume()
		
		if resume_result != null && resume_result is bool && resume_result == false:
			return _handle_error("Resume failed! Killing %s \"%s\"." % [get_identity(), get_type_str()])
		
		_flags &= ~Flags.PAUSED
		resumed.emit()


func _should_resume() -> bool:
	return is_valid() && is_paused() && is_active()

## Can be overloaded to support resume.
func _resume():
	pass

## Stops and starts process again. If given [Callable] argument, calls it between start and stop.[br]
## Does nothing when called from invalid process.
func restart(call_between: Variant = null):
	if is_valid():
		stop()
		# NOTE: State can change if stop fails and we go to terminate. This is why we check again.
		if is_valid():
			if call_between != null && call_between is Callable && call_between.is_valid():
				call_between.call()
			start()
			restarted.emit()

## Stops update timer, resets limiter (stopping [Timer] if applicable), changes active flag to unset
## and calls internal stop method.[br]
## Does nothing when called from invalid process.
func stop():
	if is_active():
		if limiter != null:
			limiter.reset(false)
		
		if update != null && update.timer != null:
			update.timer.queue_free()
			update.timer = null
		
		_flags &= ~Flags.ACTIVE
	
		var stop_result = _stop()
		
		if stop_result != null && stop_result is bool && stop_result == false:
			_flags &= ~Flags.VALID
			Log.error("Stop failed! Terminating %s \"%s\"." % [get_identity(), get_type_str()])
			terminate()
		else:
			stopped.emit()


## Clean up method. Should be overloaded.
func _stop():
	pass


func _finish():
	if _should_stop():
		stop()
	
	if is_valid():
		finished.emit()
		_flags |= Flags.FINISHED


func _should_stop() -> bool:
	return not is_permanent() || not is_valid()

## [Limiter] setter that uses it's constructor to create limiter based supported variants.
func set_limit(limit: Variant):
	if limiter != null:
		limiter.remove_observer(_finish)
	
	if limit is Limiter:
		limiter = limit

	else:
		limiter = Limiter.new(limit, self)
	
	limiter.add_observer(_finish)
#endregion
#region Utilities
## Check if process was properly initialized and still valid.
func is_valid() -> bool:
	return (_flags & Flags.VALID && _initialization.is_valid() &&
		(update == null || (update != null && update.get_type() != Update.Type.INVALID)))

## Check if process is currently being executed.
func is_active() -> bool:
	return _flags & Flags.ACTIVE

## Check if process is being paused.
func is_paused() -> bool:
	return _flags & Flags.PAUSED

## Check if process supports repetitions.
func is_repeatable() -> bool:
	return _flags & Flags.REPEATABLE

## Check if process will be removed after it's finished.
func is_permanent() -> bool:
	return _flags & Flags.PERMANENT

# NOTE/TODO: Added two new flags, should test them ;-;

## Check if process will be kept alive after it's finished.
func is_kept_in_final_state() -> bool:
	return _flags & Flags.KEEP_IN_FINAL_STATE 

func is_finished() -> bool:
	return _flags & Flags.FINISHED

## Returns identity string, should be unique for each concrete class family.
func get_identity() -> String:
	const PROCESS_IDENTITY: String = "process"
	return PROCESS_IDENTITY

## Returns type as string. Should be overloaded in different base class.
func get_type_str() -> String:
	return "BASE_PROCESS"

## Returns type. Type should be set to proper enum in concrete class.
func get_type() -> int:
	return _type

## Returns set flags.
func get_flags() -> int:
	return _flags

## Returns limit based on current variant.
func get_limit():
	if limiter != null:
		return limiter.get_limit()
	
	return null

## Returns current update type or null.
func get_update() -> Variant:
	if update != null:
		return update.get_type()
	else:
		return null
#endregion
