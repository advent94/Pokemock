extends Node

class_name TestMethods

enum Type { EQ, NEQ, SAME_TYPE, BOOL }

const FAILED: bool = false
const TYPE_TO_STR_INDEX = {
	Type.EQ: "EQUAL VARIABLES",
	Type.NEQ: "DIFFERENT VARIABLES",
	Type.SAME_TYPE: "SAME TYPE",
	Type.BOOL: "CONDITION FULFILLED"
}

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
	EXPECTED: " + TYPE_TO_STR_INDEX[type] + "
	VAR_1 = \"" + str(var1) + "\"" + "
	VAR_2 = \"" + str(var2) + "\"" + "
	PATH: " + _trim_stack(get_stack(), 3)
	push_error(msg)

func _diff_type_error():
	var msg: String = "
	TEST FAILED!
	EXPECTED: " + TYPE_TO_STR_INDEX[Type.SAME_TYPE] + "
	VAR_1 TYPE != VAR_2 TYPE" + "
	PATH: " + _trim_stack(get_stack(), 4)
	push_error(msg)


func _bool_error(cond: bool):
	var msg: String = "
	TEST FAILED!
	EXPECTED: " + TYPE_TO_STR_INDEX[Type.BOOL] +" (" + str(cond).to_upper() + ")" + "
	CONDITION = " + str(not cond).to_upper() + "
	PATH: " + _trim_stack(get_stack(), 3)
	push_error(msg)	

func EXPECT_EQ(var1, var2):
	_EXPECT_EQ(var1, var2, Type.EQ)

func EXPECT_NEQ(var1, var2):
	_EXPECT_EQ(var1, var2, Type.NEQ)

func EXPECT_TRUE(condition: bool):
	_EXPECT_BOOL(condition, true)

func EXPECT_FALSE(condition: bool):
	_EXPECT_BOOL(condition, false)

func TIMES(count: int) -> int:
	if count < 0:
		count = 0
	return count
	
func _EXPECT_BOOL(condition: bool, expected: bool):
	var status: bool = (condition == expected)
	if status == FAILED:
		_bool_error(expected)

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
