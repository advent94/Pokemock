extends StringWrapperTest

const SMALL_STRING: String = "Test"
const SMALL_STRING_ARRAY: PackedStringArray = ["Test"]
const COMPLEX_STRING: String = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrUuVvWwXxYyZz123456789"
const COMPLEX_STRING_ARRAY: PackedStringArray = ["AaBbCcDdEeFfGgH-", "hIiJjKkLlMmNnOo-", "PpQqRrUuVvWwXxY-", "yZz123456789" ]
	
func should_return_array_with_initial_string():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.split_complex_word(SMALL_STRING), SMALL_STRING_ARRAY)

func should_return_array_with_divided_strings_for_complex_string():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.split_complex_word(COMPLEX_STRING), COMPLEX_STRING_ARRAY)
