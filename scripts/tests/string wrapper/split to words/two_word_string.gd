extends StringWrapperTesting

const ONE_WORD_ARRAY: PackedStringArray = [
	STR_STARTS_WITH_TWO_SPACES,
	STR_STARTS_WITH_ONE_SPACE,
	STR_WITHOUT_SPACES,
	STR_ENDS_WITH_SPACE,
	STR_ENDS_WITH_TWO_SPACES,
]

#     A   B   C   D   E
# A  AA  BA  CA  DA  EA
# B  AB  BB  CB  DB  EB
# C  AC  BC  CC  DC  EC
# D  AD  BD  CD  DD  ED
# E  AE  BE  CE  DE  EE

func get_string_matrix() -> PackedStringArray:
	var matrix: PackedStringArray = []
	matrix.resize(ONE_WORD_ARRAY.size() * ONE_WORD_ARRAY.size())
	for y in range(ONE_WORD_ARRAY.size()):
		for x in range(ONE_WORD_ARRAY.size()):
			matrix[x + (ONE_WORD_ARRAY.size() * y)] = ONE_WORD_ARRAY[x] + " " + ONE_WORD_ARRAY[y]
	return matrix

var expected_two_word_array_matrix: Array[PackedStringArray] = [
	PackedStringArray(["  hello", "  hello"]), PackedStringArray([" world", "  hello"]), 
	PackedStringArray(["bee", "  hello"]), PackedStringArray(["space", "   hello"]), 
	PackedStringArray(["air", "    hello"]),
	
	PackedStringArray(["  hello", " world"]), PackedStringArray([" world", " world"]), 
	PackedStringArray(["bee", " world"]), PackedStringArray(["space", "  world"]), 
	PackedStringArray(["air", "   world"]),
	
	PackedStringArray(["  hello", "bee"]), PackedStringArray([" world", "bee"]), 
	PackedStringArray(["bee", "bee"]), PackedStringArray(["space", " bee"]), 
	PackedStringArray(["air", "  bee"]),
	
	PackedStringArray(["  hello", "space "]), PackedStringArray([" world", "space "]), 
	PackedStringArray(["bee", "space "]), PackedStringArray(["space", " space "]), 
	PackedStringArray(["air", "  space "]),
	
	PackedStringArray(["  hello", "air  "]), PackedStringArray([" world", "air  "]), 
	PackedStringArray(["bee", "air  "]), PackedStringArray(["space", " air  "]), 
	PackedStringArray(["air", "  air  "]),
]

var string_wrapper: Node

func _ready():
	string_wrapper = get_entity("StringWrapper")
	
func should_return_expected_two_word_array():
	var string_matrix: PackedStringArray = get_string_matrix()
	for i in range(expected_two_word_array_matrix.size()):
		EXPECT_EQ(string_wrapper.split_to_words(string_matrix[i]), expected_two_word_array_matrix[i])
