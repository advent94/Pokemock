extends StringWrapperTest

const SHORT_ONE_LINE_STRING: String = "Hello World!"
const LONG_STRING: String = "Hello, it's me, Mario!"
const DEVIL_MAY_CRY_QUOTE: String = "It's been a while since we've last met.\nHow about a kiss from little brother?\n
		Or better yet, how about kiss from THIS?"
const ONE_PIECE_QUOTE: String = "You want my treasure, you can have it. I left everything I gathered together in one place. Now, you just have to find it."
const INDENTED_POKEMON_QUOTE: String = "        Hello!        Welcome   to   the pokemon world! My    name is Oak but people call me professor      "
	
const WRAPPED_LONG_STRING: String = "Hello, it's me,\nMario!"
const WRAPPED_DEVIL_MAY_CRY_QUOTE: String = "It's been a\nwhile since\nwe've last met.\nHow about a kiss\nfrom little\nbrother?\n
		Or better yet,\nhow about kiss\nfrom THIS?" 
const WRAPPED_ONE_PIECE_QUOTE: String = "You want my\ntreasure, you\ncan have it. I\nleft everything\nI gathered\ntogether in one\nplace. Now, you\njust have to\nfind it."
const WRAPPED_INDENTED_POKEMON_QUOTE: String = "        Hello!\n       Welcome\n  to   the\npokemon world!\nMy    name is\nOak but people\ncall me\nprofessor      "

func should_return_same_one_line_string():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_string(SHORT_ONE_LINE_STRING), SHORT_ONE_LINE_STRING)

func should_return_wrapped_long_string():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_string(LONG_STRING), WRAPPED_LONG_STRING)

func should_return_wrapped_dmc_quote():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_string(DEVIL_MAY_CRY_QUOTE), WRAPPED_DEVIL_MAY_CRY_QUOTE)

func should_return_wrapped_op_quote():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_string(ONE_PIECE_QUOTE), WRAPPED_ONE_PIECE_QUOTE)

func should_return_wrapped_indented_pokemon_quote():
	var string_wrapper: StringWrapper = get_string_wrapper()
	EXPECT_EQ(string_wrapper.wrap_string(INDENTED_POKEMON_QUOTE), WRAPPED_INDENTED_POKEMON_QUOTE)
