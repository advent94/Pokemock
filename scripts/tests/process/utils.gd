extends Test
class_name ProcessTest

signal valid_signal
signal valid_signal_with_modifier(mod: Modifier)

const TIME_FOR_CLEAN_UP: float = 0.05
const SHORT_INTERVAL: float = TIME_FOR_CLEAN_UP
const LONGER_INTERVAL: float = 0.5
const INVALID_INTERVAL: float = -1.0
const VERY_LONG_TIME: float = 3600.0
const VALID_SHORT_INTERVAL_ARRAY: Array[float] = [1.0, 3.2]

#region Calls
const TERMINATION: int = 0
const KILL_COMMAND: int = 1
const START: int = 2
const FREE_RESOURCES: int = 3
const PAUSE: int = 4
const RESUME: int = 5
const RESTART: int = 6
const STOP: int = 7
const UPDATE: int = 8
const FINISH: int = 9
const INITIALIZATION: int = 10
const INNER_START: int = 11
const INNER_PAUSE: int = 12
const INNER_RESUME: int = 13
const INNER_RESTART: int = 14
const INNER_STOP: int = 15
const INNER_UPDATE: int = 16
const CALL_BETWEEN: int = 17
#endregion

const EXPECTED_RESTART_CALL_ORDER: Array[int] = [ STOP, CALL_BETWEEN, START, RESTART ]

var valid_callable: Callable = func initialize() -> bool: return true


func setup_and_start_signal_modifier_test_process(process: Process):
	Functions.disconnect_all(valid_signal_with_modifier)
	
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.setup(valid_callable, valid_signal_with_modifier)
	process.start()
	
	EXPECT_EQ(process.get_update(), Update.Type.SIGNAL)
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(process.is_valid())


func start_and_expect_dead_process_after_invalid_update(process: Process):
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.finished.connect(CALL_STATUS_UPDATE(FINISH))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(CALLED(FINISH))
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_FALSE(process.is_valid())	
	EXPECT_FALSE(process.is_active())


class FakeInvalidModifier:
	extends Modifier
	
	func _init():
		const INVALID_MODIFIER_TYPE: int = -2
		
		_type = INVALID_MODIFIER_TYPE
	
	func get_type_str() -> String:
		return "INVALID_MODIFIER_TYPE"

class ProcessStub:
	extends Process
	
	signal initialization_called
	signal inner_start_called
	signal inner_stop_called
	signal inner_pause_called
	signal inner_resume_called
	signal inner_update_called
	signal get_default_modifier_called
	
	var _status: bool = true
	var _switch: bool = false
	var _onetime: bool = false
	var _replaced_default_mod: Modifier = null
	var _use_replaced_default_mod: bool = false
	
	
	func _init(update_args: Variant):
		setup(initialization, update_args)
	
	func set_status_return(status: bool):
		_status = status
	
	func set_one_status_return(status: bool):
		_onetime = status
		_switch = true
	
	func set_default_mod(mod: Modifier):
		_use_replaced_default_mod = true
		_replaced_default_mod = mod
		
	func _get_status() -> bool:
		if _switch:
			_switch = false
			return _onetime
		
		return _status

	func initialization() -> bool:
		initialization_called.emit()
		return _get_status()
	
	func _start() -> bool:
		inner_start_called.emit()
		return _get_status()
	
	func _stop() -> bool:
		inner_stop_called.emit()
		return _get_status()

	func _pause() -> bool:
		inner_pause_called.emit()
		return _get_status()

	func _resume() -> bool:
		inner_resume_called.emit()
		return _get_status()
	
	func _update(_mod: Modifier) -> bool:
		inner_update_called.emit()
		return _get_status()
	
	
	func _get_default_modifier(_step: int, _max_steps: int) -> Modifier:
		get_default_modifier_called.emit()
		
		if _use_replaced_default_mod:
			_use_replaced_default_mod = false
			return _replaced_default_mod
		
		return Modifier.new()


func get_base_process() -> Process:
	return CAPTURED_NODE(Process.new())

func get_stubbed_process(update_args: Variant) -> ProcessStub:
	return CAPTURED_NODE(ProcessStub.new(update_args))
