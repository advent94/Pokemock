extends Test

class_name CounterTest

const NEGATIVE_VALUE: int = -1

const ONE_DEFAULT_INCREMENT: int = DEFAULT_INCREMENT_VALUE
const TWO_DEFAULT_INCREMENTS: int = 2 * DEFAULT_INCREMENT_VALUE

const NO_REPETITIONS: int = 0
const ONE_REPETITION: int = 1
const TWO_REPETITIONS: int = 2

const POSITIVE_LIMIT_REACHED: int = 0
const NEGATIVE_LIMIT_REACHED: int = 1
const POSITIVE_R_LIMIT_REACHED: int = 2
const NEGATIVE_R_LIMIT_REACHED: int = 3

const TESTED_COUNTER_NAME: String = "Test"
const TESTED_VALID_NEGATIVE_R_LIMIT: int = -1
const TESTED_NEW_INCREMENT_VALUE: int = 2

const DEFAULT_STARTING_VALUE: int = 0
const DEFAULT_LIMIT: int = Constants.MAX_INT
const DEFAULT_R_LIMIT: int = DEFAULT_STARTING_VALUE
const DEFAULT_REPETITIONS: int = 0
const DEFAULT_INCREMENT_VALUE = Counter.INCREMENT_VALUE
const DEFAULT_FLAG_SETUP_STR: String = "STRICT"

const R_LIMIT_EQUAL_TO_DEFAULT_LIMIT: int = DEFAULT_LIMIT

const RESET_FLAG_SET: bool = true
const FAST_FLAG_SET: bool = true

const RESET_FLAG_UNSET: bool = false
const REVERSE_FLAG_UNSET: bool = false
const NEGATIVE_FLAG_UNSET: bool = false
const FAST_FLAG_UNSET: bool = false
const STRICT_FLAG_UNSET: bool = false

var FLAGS_WITH_RESET_SET: AdvancedCounter.Flags = AdvancedCounter.Flags.new(RESET_FLAG_SET)
var FLAGS_WITH_STRICT_UNSET: AdvancedCounter.Flags = AdvancedCounter.Flags.new(RESET_FLAG_UNSET, 
		REVERSE_FLAG_UNSET, NEGATIVE_FLAG_UNSET, FAST_FLAG_UNSET, STRICT_FLAG_UNSET)
var FLAGS_WITH_FAST_SET: AdvancedCounter.Flags = AdvancedCounter.Flags.new(RESET_FLAG_UNSET, 
		REVERSE_FLAG_UNSET, NEGATIVE_FLAG_UNSET, FAST_FLAG_SET, STRICT_FLAG_UNSET)
		
func get_system() -> Node:
	var system: Node = CAPTURED_NODE(get_entity("Counters").duplicate())
	return system

func get_counter_that_resets() -> AdvancedCounter:
	return AdvancedCounter.new(ONE_DEFAULT_INCREMENT, DEFAULT_STARTING_VALUE, DEFAULT_R_LIMIT, 
			DEFAULT_REPETITIONS, DEFAULT_INCREMENT_VALUE, FLAGS_WITH_RESET_SET)

func get_non_strict_counter():
	return AdvancedCounter.new(DEFAULT_LIMIT, DEFAULT_STARTING_VALUE, DEFAULT_R_LIMIT, 
			DEFAULT_REPETITIONS, DEFAULT_INCREMENT_VALUE, FLAGS_WITH_STRICT_UNSET)

func get_fast_counter():
	return AdvancedCounter.new(ONE_DEFAULT_INCREMENT, DEFAULT_STARTING_VALUE, DEFAULT_R_LIMIT, 
			DEFAULT_REPETITIONS, DEFAULT_INCREMENT_VALUE, FLAGS_WITH_FAST_SET)
