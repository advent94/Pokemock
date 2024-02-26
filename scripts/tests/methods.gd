extends TestUtils

## Methods and helpers used within Test Framework
class_name TestMethods

var _call_status: bool = false

#func _reset():
#	_call_status = false
#	_call_status_index = []

## Returns callable which, when called. will update call status with index provided by user(unique by default)
func CALL_STATUS_UPDATE(index: int = UNIQUE_CALL) -> Callable:
	_validate_call_status_index(index)
	if index == UNIQUE_CALL:
		return func(): _call_status = true
	else:
		if _call_status_index.size() <= index:
			_resize_call_index(index + 1)
		return func(): _call_status_index[index] = true

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

## Returns count that can't be negative. Just a syntax helper.
func TIMES(count: int) -> int:
	if count < 0:
		count = 0
	return count
