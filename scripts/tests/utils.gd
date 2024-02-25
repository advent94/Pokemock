extends Node

## Methods and helpers used within Test Framework
class_name TestMethods

enum Type { EQ, NEQ, SAME_TYPE, BOOL }

const FAILED: bool = false
const _TYPE_TO_STR_INDEX = {
	Type.EQ: "EQUAL VARIABLES",
	Type.NEQ: "DIFFERENT VARIABLES",
	Type.SAME_TYPE: "SAME TYPE",
	Type.BOOL: "CONDITION FULFILLED"
}

var _call_status: bool = false
var _call_status_index: Array[bool] = []

func _reset():
	_call_status = false
	_call_status_index = []

## Default index for calls that refers to unique call status
const UNIQUE_CALL: int = -1

func _validate_call_status_index(index: int):
	assert(index >= UNIQUE_CALL && index < Constants.MAX_INT, 
			"Invalid called index (%d). Valid indexes: [%d - %d]" % 
			[index, UNIQUE_CALL, Constants.MAX_INT - Constants.ZERO_INDEXING_OFFSET])

func _resize_call_index(new_size: int):
	assert(new_size >= 0 && new_size > _call_status_index.size())
	var new_calls: Array[bool] = []
	new_calls.resize(new_size - _call_status_index.size())
	new_calls.fill(false)
	_call_status_index.append_array(new_calls)

## Returns callable which, when called. will update call status with index provided by user(unique by default)
func CALL_STATUS_UPDATE(index: int = UNIQUE_CALL) -> Callable:
	_validate_call_status_index(index)
	if index == UNIQUE_CALL:
		return func(): _call_status = true
	else:
		if _call_status_index.size() <= index:
			_resize_call_index(index + 1)
		return func(): _call_status_index[index] = true

func _warn_index_out_of_call_status_array_boundaries(index: int):
	var array_boundaries_str: String = "EMPTY"
	if _call_status_index.size() > 0:
		array_boundaries_str = "%d - %d" % [0, _call_status_index.size() - Constants.ZERO_INDEXING_OFFSET]
	push_warning("Index (%d) out of call status array boundaries [%s]. Returning FALSE." % 
			[index, array_boundaries_str])

## Sets call status with index provided by user to false (not called)
func RESET_CALL(index: int = UNIQUE_CALL):
	_validate_call_status_index(index)
	if index == UNIQUE_CALL:
		_call_status = false
	else:
		if _call_status_index.size() <= index:
			return
		_call_status_index[index] = false

## Sets every call status to false (not called)
func RESET_ALL_CALLS():
	_call_status = false

	var size = _call_status_index.size()
	_call_status_index.resize(0)
	_call_status_index.resize(size)
	_call_status_index.fill(false)

## Check call status with index provided by user (unique by default). Returns false if never updated
## or index is out of status array boundaries.
func CALLED(index: int = UNIQUE_CALL) -> bool:
	_validate_call_status_index(index)
	if index == UNIQUE_CALL:
		return _call_status
	else:
		if _call_status_index.size() <= index:
			_warn_index_out_of_call_status_array_boundaries(index)
			return false
		return _call_status_index[index]

func _add_status_to_current_case(_status: bool):
	pass
	#var test_framework: Node
	#	test_framework = get_parent().get_node("Test_TEMP")
	#	test_framework.add_result_to_current_case(status)

func _test_framework_active() -> bool:
	return false
	#return get_parent().has_node("Test_TEMP")

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

## Expects that both variables are equal, throws error otherwise.
func EXPECT_EQ(var1, var2):
	_EXPECT_EQ(var1, var2, Type.EQ)
	
## Expects that both variables are not equal, throws error otherwise.
func EXPECT_NEQ(var1, var2):
	_EXPECT_EQ(var1, var2, Type.NEQ)

## Expects that condition is fulfilled, throws error otherwise.
func EXPECT_TRUE(condition: bool):
	_EXPECT_BOOL(condition, true)

## Expects that condition is not fulfilled, throws error otherwise.
func EXPECT_FALSE(condition: bool):
	_EXPECT_BOOL(condition, false)

## Returns count that can't be negative. Just a syntax helper.
func TIMES(count: int) -> int:
	if count < 0:
		count = 0
	return count
	
func _EXPECT_BOOL(condition: bool, expected: bool):
	var status: bool = (condition == expected)
	if status == FAILED:
		_bool_error(expected)

## Expects that both variable types are the same, throws error otherwise.
func EXPECT_SAME_TYPE(var1, var2) -> bool:
	var status: bool = typeof(var1) == typeof(var2)
	#TBD 
	# if _test_framework_active():
	#     _add_status_to_current_case		
	if status == FAILED:
		_diff_type_error()
	return status
		
func _EXPECT_EQ(var1, var2, type: Type):
	var status: bool
	if not EXPECT_SAME_TYPE(var1, var2):
		return
	match type:
		Type.EQ: 
			status = (var1 == var2)
		Type.NEQ: 
			status = (var1 != var2)
	#TBD 
	# if _test_framework_active():
	#     _add_status_to_current_case		
	if status == FAILED:
		_eq_error(var1, var2, type)
