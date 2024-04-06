extends StringWrapperTest

# WORDS
const COMPLEX_WORD: String = "Internationalisation"
const SHORT_WORD: String = "cat"
const LONG_WORD: String = "metamorphosis"

# WORD ARRAYS
const SHORT_WORD_ARRAY: PackedStringArray = [ SHORT_WORD ]
const TWO_SHORT_WORDS_ARRAY: PackedStringArray = [ SHORT_WORD, SHORT_WORD ]
const THREE_SHORT_WORDS_ARRAY: PackedStringArray = [ SHORT_WORD, SHORT_WORD, SHORT_WORD ]
const TWO_LONG_WORDS_ARRAY: PackedStringArray = [ LONG_WORD, LONG_WORD ]
const THREE_LONG_WORDS_ARRAY: PackedStringArray = [ LONG_WORD, LONG_WORD, LONG_WORD ]
const ONE_LONG_TWO_SHORT_WORDS_ARRAY: PackedStringArray = [ LONG_WORD, SHORT_WORD, SHORT_WORD ]
const ONE_COMPLEX_WORD_ARRAY: PackedStringArray = [ COMPLEX_WORD ]
const ONE_COMPLEX_ONE_SHORT_WORD_ARRAY: PackedStringArray = [ COMPLEX_WORD, SHORT_WORD ]
const ONE_SHORT_ONE_COMPLEX_WORD_ARRAY: PackedStringArray = [ SHORT_WORD, COMPLEX_WORD ]
const ONE_COMPLEX_ONE_LONG_WORD_ARRAY: PackedStringArray = [ COMPLEX_WORD, LONG_WORD ]
const SHORT_COMPLEX_SHORT_WORDS_ARRAY: PackedStringArray = [ SHORT_WORD, COMPLEX_WORD, SHORT_WORD ]
const SHORT_COMPLEX_LONG_WORDS_ARRAY: PackedStringArray = [ SHORT_WORD, COMPLEX_WORD, LONG_WORD ]
const TWO_SHORT_ONE_COMPLEX_WORD_ARRAY: PackedStringArray = [ SHORT_WORD, SHORT_WORD, COMPLEX_WORD ]
const TWO_COMPLEX_WORDS_ARRAY: PackedStringArray = [ COMPLEX_WORD, COMPLEX_WORD ]

# COMBINED STRINGS
const TWO_WORDS_ONE_LINE: String = SHORT_WORD + Constants.EMPTY_SPACE + SHORT_WORD
const THREE_WORDS_ONE_LINE: String = SHORT_WORD + Constants.EMPTY_SPACE + SHORT_WORD + Constants.EMPTY_SPACE + SHORT_WORD

# EXPECTED WRAPPED LINE ARRAYS
const TWO_WORDS_ONE_LINE_ARRAY: PackedStringArray = [ TWO_WORDS_ONE_LINE ]
const THREE_WORDS_ONE_LINE_ARRAY: PackedStringArray = [ THREE_WORDS_ONE_LINE ]
const THREE_WORDS_TWO_LINES_ARRAY: PackedStringArray = [ LONG_WORD, TWO_WORDS_ONE_LINE ]
const ONE_COMPLEX_WORD_TWO_LINES_ARRAY: PackedStringArray = [ "Internationalis-", "ation"]
const ONE_COMPLEX_ONE_SHORT_WORD_TWO_LINES_ARRAY: PackedStringArray = [ "Internationalis-", 
		("ation" + Constants.EMPTY_SPACE + SHORT_WORD)]
const ONE_COMPLEX_ONE_LONG_WORD_THREE_LINES_ARRAY: PackedStringArray = [ "Internationalis-", "ation", LONG_WORD]
const ONE_SHORT_ONE_COMPLEX_WORD_THREE_LINES_ARRAY: PackedStringArray = [ SHORT_WORD, "Internationalis-", "ation" ]
const TWO_SHORT_ONE_COMPLEX_WORD_THREE_LINES_ARRAY: PackedStringArray = [ (SHORT_WORD + Constants.EMPTY_SPACE + SHORT_WORD), 
		"Internationalis-", "ation" ]
const SHORT_COMPLEX_SHORT_WORDS_THREE_LINES_ARRAY: PackedStringArray = [ SHORT_WORD, "Internationalis-", 
		("ation" + Constants.EMPTY_SPACE + SHORT_WORD) ]
const SHORT_COMPLEX_LONG_WORDS_FOUR_LINES_ARRAY: PackedStringArray = [ SHORT_WORD, "Internationalis-", 
		"ation", LONG_WORD ]
const TWO_COMPLEX_WORDS_FOUR_LINES_ARRAY: PackedStringArray = [ "Internationalis-", "ation", "Internationalis-", "ation"]
	
func should_return_array_with_one_line_for_one_short_word():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(SHORT_WORD_ARRAY), SHORT_WORD_ARRAY)

func should_return_array_with_one_line_for_two_short_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(TWO_SHORT_WORDS_ARRAY), TWO_WORDS_ONE_LINE_ARRAY)

func should_return_array_with_two_lines_for_two_long_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(TWO_LONG_WORDS_ARRAY), TWO_LONG_WORDS_ARRAY)

func should_return_array_with_one_line_for_three_short_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(THREE_SHORT_WORDS_ARRAY), THREE_WORDS_ONE_LINE_ARRAY)

func should_return_array_with_two_lines_for_one_long_two_short_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(ONE_LONG_TWO_SHORT_WORDS_ARRAY), THREE_WORDS_TWO_LINES_ARRAY)

func should_return_array_with_three_lines_for_three_long_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(THREE_LONG_WORDS_ARRAY), THREE_LONG_WORDS_ARRAY)

func should_return_array_with_two_lines_for_complex_word():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(ONE_COMPLEX_WORD_ARRAY), ONE_COMPLEX_WORD_TWO_LINES_ARRAY)

func should_return_array_with_two_lines_for_one_complex_and_one_short_word():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(ONE_COMPLEX_ONE_SHORT_WORD_ARRAY), ONE_COMPLEX_ONE_SHORT_WORD_TWO_LINES_ARRAY)
	
func should_return_array_with_three_lines_for_one_complex_and_one_long_word():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(ONE_COMPLEX_ONE_LONG_WORD_ARRAY), ONE_COMPLEX_ONE_LONG_WORD_THREE_LINES_ARRAY)

func should_return_array_with_three_lines_for_one_normal_and_one_complex_word():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(ONE_SHORT_ONE_COMPLEX_WORD_ARRAY), ONE_SHORT_ONE_COMPLEX_WORD_THREE_LINES_ARRAY)

func should_return_array_with_three_lines_for_short_complex_short_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(SHORT_COMPLEX_SHORT_WORDS_ARRAY), SHORT_COMPLEX_SHORT_WORDS_THREE_LINES_ARRAY)

func should_return_array_with_four_lines_for_short_complex_long_words():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(SHORT_COMPLEX_LONG_WORDS_ARRAY), SHORT_COMPLEX_LONG_WORDS_FOUR_LINES_ARRAY)

func should_return_array_with_three_lines_for_two_short_one_complex_word():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(TWO_SHORT_ONE_COMPLEX_WORD_ARRAY), TWO_SHORT_ONE_COMPLEX_WORD_THREE_LINES_ARRAY)

func should_add_two_complex_words_and_return_array_with_four_lines():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_words(TWO_COMPLEX_WORDS_ARRAY), TWO_COMPLEX_WORDS_FOUR_LINES_ARRAY)
