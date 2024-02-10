extends Node

func wait(time_in_sec: float):
	await get_tree().create_timer(time_in_sec).timeout

func wait_if_blocked(moving_object):
	assert(moving_object.has_node("Movement"), "%s doesn't have movement component." % get_parent().name)
	var movement: Node = moving_object.get_node("Movement")
	while movement.is_blocking():
			await movement.blocking_movement_finished

func char_assert(character:String, what: String):
	assert(is_char(character), "Only single characters can be %s. (tried: \"%s\")" % [what, character])	
	
func char_to_ASCII(character: String) -> int:
	char_assert(character, "converted to ASCII")
	return character.to_ascii_buffer()[0]

func is_char(string: String) -> bool:
	return string.length() == Constants.ONE_CHARACTER

func is_lower_case_letter(character: String) -> bool:
	char_assert(character, "lower case letter")
	var ascii: int = char_to_ASCII(character)
	return 	is_between(ascii, Constants.LOWER_CASE_ASCII_MIN_VALUE, Constants.LOWER_CASE_ASCII_MAX_VALUE)
	
func is_upper_case_letter(character: String) -> bool:
	char_assert(character, "upper case letter")
	var ascii: int = char_to_ASCII(character)
	return is_between(ascii, Constants.UPPER_CASE_ASCII_MIN_VALUE, Constants.UPPER_CASE_ASCII_MAX_VALUE)
		
func is_letter(character: String) -> bool:
	return is_lower_case_letter(character) || is_upper_case_letter(character)

func is_int(val) -> bool:
	return typeof(val) == TYPE_INT

func is_float(val) -> bool:
	return typeof(val) == TYPE_FLOAT

# This can be further developed to handle different in_betweens like vectors for points,
# characters for ascii etc
func is_between(val, minimum, maximum) -> bool:
	var _is_int: bool = is_int(val) && is_int(minimum) && is_int(maximum)
	var _is_float: bool = is_float(val) && is_float(minimum) && is_float(maximum)
	assert(_is_float || _is_int, "This operation works with numbers (for now at least)")
	return val >= minimum && val <= maximum

## Function used for conscious and safe integer division with ommiting floating part 
func safe_integer_division(a: int, b: int) -> int:
	assert(b != 0, "Null division assertion spotted (a = %d, b = %d)" % [a, b])
	@warning_ignore("integer_division")
	return a / b

func substr_found_in_string(substr: String, string: String) -> bool:
	return string.find(substr) != Constants.STRING_NOT_FOUND

func get_lines_from_string(string: String) -> PackedStringArray:
	return string.split("\n")

func rclamp(value: int, minimum: int, maximum: int) -> int:
	if value > maximum:
		value = minimum
	elif value < minimum:
		value = maximum
	return value
