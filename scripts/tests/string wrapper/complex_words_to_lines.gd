extends StringWrapperTesting

const SMALL_STRING: String = "Test"
const SMALL_STRING_ARRAY: PackedStringArray = ["Test"]
const COMPLEX_STRING: String = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrUuVvWwXxYyZz123456789"
const COMPLEX_STRING_ARRAY: PackedStringArray = ["AaBbCcDdEeFfGgH-", "hIiJjKkLlMmNnOo-", "PpQqRrUuVvWwXxY-", "yZz123456789" ]

var string_wrapper: Node

func _ready():
	string_wrapper = get_entity("StringWrapper")
	string_wrapper.max_characters_per_line = TESTED_MAX_CHARACTERS_PER_LINE
	
func should_return_array_with_initial_string():
	EXPECT_EQ(string_wrapper.split_complex_word(SMALL_STRING), SMALL_STRING_ARRAY)

func should_return_array_with_divided_strings_for_complex_string():
	EXPECT_EQ(string_wrapper.split_complex_word(COMPLEX_STRING), COMPLEX_STRING_ARRAY)
