extends StringWrapperTest

const STR_STARTS_WITH_TWO_SPACES_ARRAY: PackedStringArray = [STR_STARTS_WITH_TWO_SPACES]
const STR_STARTS_WITH_ONE_SPACE_ARRAY: PackedStringArray = [STR_STARTS_WITH_ONE_SPACE]
const STR_WITHOUT_SPACES_ARRAY: PackedStringArray = [STR_WITHOUT_SPACES]
const STR_ENDS_WITH_SPACE_ARRAY: PackedStringArray = [STR_ENDS_WITH_SPACE]
const STR_ENDS_WITH_TWO_SPACES_ARRAY: PackedStringArray = [STR_ENDS_WITH_TWO_SPACES]

const STR_TO_EXPECTED_ARRAY: Dictionary = {
	STR_STARTS_WITH_TWO_SPACES: STR_STARTS_WITH_TWO_SPACES_ARRAY,
	STR_STARTS_WITH_ONE_SPACE: STR_STARTS_WITH_ONE_SPACE_ARRAY,
	STR_WITHOUT_SPACES: STR_WITHOUT_SPACES_ARRAY,
	STR_ENDS_WITH_SPACE: STR_ENDS_WITH_SPACE_ARRAY,
	STR_ENDS_WITH_TWO_SPACES : STR_ENDS_WITH_TWO_SPACES_ARRAY,
}

var single_word_array_count: int = STR_TO_EXPECTED_ARRAY.size() - Constants.ONE_ELEMENT

func should_return_expected_arrays_with_single_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	
	for key_id in range(single_word_array_count):
		var key: String = STR_TO_EXPECTED_ARRAY.keys()[key_id]
		EXPECT_EQ(STR_TO_EXPECTED_ARRAY[key], string_wrapper.split_to_words(key))
