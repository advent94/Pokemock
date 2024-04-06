class_name Constants

# Limits

const MIN_INT: int = -9223372036854775808
const MAX_INT: int = 9223372036854775807

# Time
const ONE_SECOND: float = 1.0
## Time for action without delay
const NOW: float = 0.0
const MIN_TIME_BETWEEN_UPDATES: float = 0.05

# Common iterators
const ONE_CHARACTER: int = 1
const ONE_ELEMENT: int = 1
const ONE_STEP: int = 1

# Flags
const NO_FLAGS: int = 0

# ASCII
const LOWER_CASE_ASCII_MIN_VALUE: int = 97
const LOWER_CASE_ASCII_MAX_VALUE: int = 122
const UPPER_CASE_ASCII_MIN_VALUE: int = 65
const UPPER_CASE_ASCII_MAX_VALUE: int = 90 

const ASCII_LETTER_CASE_OFFSET: int = LOWER_CASE_ASCII_MIN_VALUE - UPPER_CASE_ASCII_MIN_VALUE

# Array utils
const FIRST_ELEMENT_IN_INDEX: int = 0
## Offset to calculate value that's based on indexed elements
const ZERO_INDEXING_OFFSET: int = 1
const EMPTY: int = 0

# String utils
const STRING_NOT_FOUND: int = -1
const NOT_FOUND: int = -1
const EMPTY_SPACE: String = " "
const NEW_LINE: String = "\n"
const EMPTY_LINE: String = NEW_LINE
const STRING_BEGIN: int = 0
const INVALID_ENUM: String = "INVALID_ENUM"

# GUI utils
const CURSOR: String = ">"
const SAVED_CURSOR: String = "<"
const INDICATOR: String = SAVED_CURSOR
const SPACE_FOR_CURSOR: String = EMPTY_SPACE
const WORD_CONTINUATION: String = "-"
