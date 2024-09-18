extends Test
class_name UpdateTest

signal valid_signal

const EMPTY_INTERVAL_ARRAY: Array[float] = []
const VALID_INTERVAL: float = Update.MIN_TIME_BETWEEN_UPDATES
const VALID_DURATION: float = VALID_INTERVAL
const VALID_UPDATE_COUNT: int = 1
const INVALID_UPDATE_COUNT: int = 0
const INVALID_INTERVAL: float = 0.0
const INVALID_DURATION = INVALID_INTERVAL
const VALID_INTERVAL_ARRAY: Array[float] = [VALID_INTERVAL]
const FLOAT_ARRAY_WITH_TWO_VALID_INTERVALS: Array[float] = [VALID_INTERVAL, VALID_INTERVAL]
const IMPLICIT_VALID_INTERVAL_ARRAY = [VALID_INTERVAL]
const INVALID_INTERVAL_ARRAY: Array[float] = [INVALID_INTERVAL]
const IMPLICIT_INVALID_INTERVAL_ARRAY = [INVALID_INTERVAL]

# NOTE: This array can't be constant because Godot converts implicit constant arrays of same
# element type to typed arrays.
var implicit_valid_duration_with_interval_descriptor: Array = [VALID_DURATION, VALID_INTERVAL]
