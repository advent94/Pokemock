extends Test

class_name StringWrapperTest

const TESTED_MAX_CHARACTERS_PER_LINE: int = 16

const STR_STARTS_WITH_TWO_SPACES = Constants.EMPTY_SPACE + Constants.EMPTY_SPACE + "hello"
const STR_STARTS_WITH_ONE_SPACE = Constants.EMPTY_SPACE + "world"
const STR_WITHOUT_SPACES = "bee"
const STR_ENDS_WITH_SPACE = "space" + Constants.EMPTY_SPACE
const STR_ENDS_WITH_TWO_SPACES = "air" + Constants.EMPTY_SPACE + Constants.EMPTY_SPACE

func get_string_wrapper() -> StringWrapper:
	return StringWrapper.new(TESTED_MAX_CHARACTERS_PER_LINE)
