class_name Functions

# TODO: Write documentation if necessary and definitely write tests
# TODO/NOTE: It's interesting idea to create subclasses to differentiate which function is related
# to which object type ex. Functions.String.is_char() etc.

const FAIL: int = -1

static func wait(time_in_sec: float):
	await Counters.get_tree().create_timer(time_in_sec).timeout


static func wait_if_blocked(moving_object):
	Log.assertion(moving_object.has_node("Movement"), "%s doesn't have movement component." % moving_object.get_parent().name)
	
	var movement: Node = moving_object.get_node("Movement")
	
	while movement.is_blocking():
			await movement.blocking_movement_finished


static func char_to_ASCII(character: String) -> int:
	if not is_char(character):
		Log.assertion(is_char(character), "Only single characters can be convered to ASCII. (tried: \"%s\")" % character)
	
	return character.to_ascii_buffer()[0]


static func is_char(string: String) -> bool:
	return string.length() == Constants.ONE_CHARACTER


static func is_lower_case_letter(character: String) -> bool:
	if not is_char(character):
		return false
		
	var ascii: int = char_to_ASCII(character)
	return 	is_between(ascii, Constants.LOWER_CASE_ASCII_MIN_VALUE, Constants.LOWER_CASE_ASCII_MAX_VALUE)


static func is_upper_case_letter(character: String) -> bool:
	if not is_char(character):
		return false
		
	var ascii: int = char_to_ASCII(character)
	return is_between(ascii, Constants.UPPER_CASE_ASCII_MIN_VALUE, Constants.UPPER_CASE_ASCII_MAX_VALUE)


static func is_letter(character: String) -> bool:
	return is_lower_case_letter(character) || is_upper_case_letter(character)

# This can be further developed to handle different in_betweens like vectors for points,
# characters for ascii etc
static func is_between(val, minimum, maximum) -> bool:
	var is_int: bool = val is int && minimum is int && maximum is int
	var is_float: bool = val is float && minimum is float && maximum is float
	
	if not (is_float || is_int):
		Log.error("This operation works with numbers (for now at least). Returning false.")
		return false
	
	return (val >= minimum && val <= maximum) || (val <= minimum && val >= maximum)


## Function used for conscious and safe integer division with ommiting floating part 
static func safe_integer_division(a: int, b: int) -> int:
	Log.assertion(b != 0, "Null division assertion spotted (a = %d, b = %d)" % [a, b])
	@warning_ignore("integer_division")
	return a / b

static func get_lines_from_string(string: String) -> PackedStringArray:
	return string.split("\n")

static func rclamp(value: int, minimum: int, maximum: int) -> int:
	if value > maximum:
		value = minimum
	elif value < minimum:
		value = maximum
	return value

static func tabs_replaced_with_spaces(string: String, spaces_per_tab: int) -> String:
	var spaces: String = ""
	spaces = spaces.rpad(spaces_per_tab, " ")
	return string.replace("\t", spaces)

static func get_children_names(node: Node) -> PackedStringArray:
	var children = node.get_children()
	var names: PackedStringArray = []
	for child in children:
		names.push_back(child.name)
	return names

static func string_starts_with(string: String, substr: String) -> bool:
	return string.substr(Constants.FIRST_ELEMENT_IN_INDEX, substr.length()) == substr

static func string_find_n_occurrence(string: String, substr: String, occurrence: int) -> int:
	if occurrence <= 0 || (string.count(substr) < occurrence):
		return FAIL
		
	var counter: int = 0
	var pos = Constants.FIRST_ELEMENT_IN_INDEX
	while counter < occurrence:
		pos = string.find(substr, pos) + Constants.ONE_CHARACTER
		counter += 1
	return pos


static func bound_callable(method: Callable, object) -> Callable:
	return func(): method.call(object)

static func call_on_node_exit(callable: Callable, node: Node):
	node.tree_exiting.connect(callable)

static func disconnect_last_callable(sig: Signal):
	var connections = sig.get_connections()
	if not connections.is_empty():
		sig.disconnect(connections.back()["callable"])

static func disconnect_all(sig: Signal):
	var connections = sig.get_connections()
	for connection in connections:
		sig.disconnect(connection["callable"])
		
static func enum_to_str(enum_value: int, enums: Dictionary) -> String:
	if not enums.values().has(enum_value):
		Log.warning("Dictionary (%s) has no key_id = %s" % [str(enums), str(enum_value)])
		return Constants.INVALID_ENUM
	
	var value = enums.keys()[enum_value]
	
	if not value is String:
		Log.warning("Value(%s) in dictionary(%s) for key %s is not String" % [str(value), str(enums), str(enum_value)])
		return Constants.INVALID_ENUM
	
	return str(value)

static func is_implicitly_typed_array(array: Variant, type: Variant.Type, obj_type: String = "") -> bool:
	if not (array is Array):
		return false
	match(type):
		Variant.Type.TYPE_FLOAT:
			return array.all(func(variant) -> bool: return (variant is float))
		Variant.Type.TYPE_OBJECT:
			return _is_implicitly_typed_object_array(array, obj_type)
		_:
			Log.warning("Not implemented!")
			return false

static func _is_implicitly_typed_object_array(array: Array, obj_type: String) -> bool:
	match(obj_type):
		"Modifier":
			return array.all(func(variant) -> bool: return (variant is Modifier))
		_:
			Log.warning("Not implemented!")
			return false

static func any_contains(array: Array[String], string: String, strict: bool = true) -> bool:
	if strict:
		for element in array:
			if element.contains(string):
				return true
	
	else:
		for element in array:
			if element.to_lower().contains(string.to_lower()):
				return true
	
	return false
