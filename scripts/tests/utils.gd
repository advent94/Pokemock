extends SharedTestUtils

## Class with utilities used by testing methods
class_name TestUtils

enum Type { EQ, NEQ, SAME_TYPE, BOOL }

const FAILED: bool = false

## Default index for calls that refers to unique call status
const UNIQUE_CALL: int = -1

const _TYPE_TO_STR_INDEX = {
	Type.EQ: "EQUAL VARIABLES",
	Type.NEQ: "DIFFERENT VARIABLES",
	Type.SAME_TYPE: "SAME TYPE",
	Type.BOOL: "CONDITION FULFILLED"
}

var _call_status_index: Array[bool] = []

func _resize_call_index(new_size: int):
	assert(new_size >= 0 && new_size > _call_status_index.size())
	var new_calls: Array[bool] = []
	new_calls.resize(new_size - _call_status_index.size())
	new_calls.fill(false)
	_call_status_index.append_array(new_calls)

func _trim_stack(stack: PackedStringArray, elements: int) -> String:
	if elements > 0:
		for i in range(elements):
			stack.remove_at(0)
	var result: String = ""
	for element in stack:
		result += element + "\n"
	if result[result.length() - 1] == "\n":
		result.erase(result.length() - 1)
	return result

func _validate_call_status_index(index: int):
	assert(index >= UNIQUE_CALL && index < Constants.MAX_INT, 
			"Invalid called index (%d). Valid indexes: [%d - %d]" % 
			[index, UNIQUE_CALL, Constants.MAX_INT - Constants.ZERO_INDEXING_OFFSET])

func _eq_error(var1, var2, type: Type):
	var msg: String = "
	TEST FAILED!
	EXPECTED: " + _TYPE_TO_STR_INDEX[type] + "
	VAR_1 = \"" + str(var1) + "\"" + "
	VAR_2 = \"" + str(var2) + "\"" + "
	PATH: " + _trim_stack(get_stack(), 3)
	push_error(msg)

func _diff_type_error():
	var msg: String = "
	TEST FAILED!
	EXPECTED: " + _TYPE_TO_STR_INDEX[Type.SAME_TYPE] + "
	VAR_1 TYPE != VAR_2 TYPE" + "
	PATH: " + _trim_stack(get_stack(), 4)
	push_error(msg)

func _bool_error(cond: bool):
	var msg: String = "
	TEST FAILED!
	EXPECTED: " + _TYPE_TO_STR_INDEX[Type.BOOL] +" (" + str(cond).to_upper() + ")" + "
	CONDITION = " + str(not cond).to_upper() + "
	PATH: " + _trim_stack(get_stack(), 3)
	push_error(msg)	
	
func _warn_index_out_of_call_status_array_boundaries(index: int):
	var array_boundaries_str: String = "EMPTY"
	if _call_status_index.size() > 0:
		array_boundaries_str = "%d - %d" % [0, _call_status_index.size() - Constants.ZERO_INDEXING_OFFSET]
	push_warning("Index (%d) out of call status array boundaries [%s]. Returning FALSE." % 
			[index, array_boundaries_str])

func _add_status_to_current_case(_status: bool):
	pass
	#var test_framework: Node
	#	test_framework = get_parent().get_node("Test_TEMP")
	#	test_framework.add_result_to_current_case(status)

func _test_framework_active() -> bool:
	return false
	#return get_parent().has_node("Test_TEMP")
