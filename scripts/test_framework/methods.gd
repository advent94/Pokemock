extends TestUtils

#TODO: Add missing documentation, fix formatting if needed

## Methods and helpers used within Test Framework
class_name Test

var _call_status: bool = false
var _callable: Callable
	
func teardown():
	RESET_ALL_CALLS()
	FREE_CAPTURED_NODES()

func GET_NODE_CONTAINER(_name: String = TEMP_NODE_PARENT_NAME) -> Node:
	if _node_container_index.keys().has(_name):
		return _node_container_index[_name]
		
	var node: Node = _add_node_container(_name)
	return node


func NODE(_name: String = "", container_name: String = TEMP_NODE_PARENT_NAME) -> Node:
	var node: Node = Node.new()
	
	if not _name.is_empty():
		node.name = _name
	
	return CAPTURED_NODE(node, container_name)


func CAPTURE_NODE(node: Node, container_name: String = TEMP_NODE_PARENT_NAME):
	GET_NODE_CONTAINER(container_name).add_child(node)


func CAPTURED_NODE(node: Node, container_name: String = TEMP_NODE_PARENT_NAME) -> Node:
	CAPTURE_NODE(node, container_name)
	
	return node


func CLEAR_NODE_CONTAINER(_name: String = TEMP_NODE_PARENT_NAME):
	assert(_node_container_index.keys().has(_name))
	
	var container: Node = _node_container_index[_name]
	container.queue_free()
	_node_container_index.erase(_name)


func FREE_CAPTURED_NODES(_name: String = ""):
	if _name.is_empty():
		for node in _node_container_index.values():
			node.queue_free()
		
		_node_container_index.clear()
	else:
		CLEAR_NODE_CONTAINER(_name)


## Returns callable which, when called. will update call status with index provided by user(unique by default)
func CALL_STATUS_UPDATE(index: int = UNIQUE_CALL) -> Callable:
	_validate_call_status_index(index)
	if index == UNIQUE_CALL:
		if not _callable.is_valid():
			_callable = func(): _call_status = true
			
		return _callable
	
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

# TODO/NOTE: It's more intuitive to return callable but also set it for time
# period, specially when we need to use same call update  multiple times.
# Because of that, for now default value is going to remember call it was set
# on. If it will be necessary, call status index can become Dictionary containing
# all callables created during method/TC/Fixture (TBD)

## Sets every call status to false (not called) as well as resets callables
func RESET_ALL_CALLS():
	_call_status = false
	
	@warning_ignore("unassigned_variable")
	var callable: Callable
	_callable = callable
	
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

func EXPECT_FLOAT_EQ(var1: float, var2: float):
	_EXPECT_EQ(var1, var2, Type.FLOAT_EQ)

func EXPECT_FLOAT_NEQ(var1: float, var2: float):
	_EXPECT_EQ(var1, var2, Type.FLOAT_NEQ)

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
	var status: bool = typeof(var1) == typeof(var2) || var1 == null || var2 == null
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
		Type.FLOAT_EQ:
			status = is_equal_approx(var1, var2)
		Type.FLOAT_NEQ:
			status = not is_equal_approx(var1, var2)
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
