extends TestMethods

class_name FrameworkTest

const VALID_TEST_FIXTURE_NAME: String = "ValidTest"
const INVALID_TEST_FIXTURE_NAME: String = "Invalid"

func create_main_node() -> Node:
	var main_node: Node = Node.new()
	main_node.add_child(create_test_fixture())	
	return main_node
	
func create_test_fixture() -> Node:
	var test_fixture: Node = Node.new()
	test_fixture.name = VALID_TEST_FIXTURE_NAME
	test_fixture.add_child(create_test_cases())
	return test_fixture
	
func create_test_cases() -> Node:
	var test_cases: Node = Node.new()
	test_cases.name = TEST_CASES_NODE_NAME
	return test_cases

func create_empty_testing_node() -> Node:
	var script: GDScript = get_test_script(ScriptType.TESTING)
	var node: Node = Node.new()
	node.set_script(script)
	return node
	
var call_counter: int = 0

func was_function_called(count = 1) -> bool:
	return call_counter == count

const ONE_FUNCTION_CALL: int = 1

func register_function_call():
	call_counter += ONE_FUNCTION_CALL

func reset_counter():
	call_counter = 0

func initialize():
	reset_counter()

const SOURCE_CODE_WITH_TEST_METHOD: String = "extends TestMethods\n\nsignal called\nfunc should_return_true():
	\n	called.emit()\n	EXPECT_TRUE(true)"
const SOURCE_CODE_WITH_TWO_TEST_METHODS: String = "extends TestMethods\n\nsignal called\nfunc should_return_true():
	\n	called.emit()\n	EXPECT_TRUE(true)\n\nfunc should_return_false():\n	called.emit()\n	EXPECT_FALSE(false)"
const TESTING_SOURCE_CODE: String = "extends TestFixture\n\nfunc run_all_tests():\n	for child in get_children():\n		run_test_fixture(child)"

enum ScriptType { ONE_TEST_METHOD, TWO_TEST_METHODS, TESTING }
const TYPE_TO_SCRIPT_INDEX: Dictionary = {
	ScriptType.ONE_TEST_METHOD: SOURCE_CODE_WITH_TEST_METHOD,
	ScriptType.TWO_TEST_METHODS: SOURCE_CODE_WITH_TWO_TEST_METHODS,
	ScriptType.TESTING: TESTING_SOURCE_CODE,
}

func get_test_script(type: ScriptType) -> GDScript:
	var script: GDScript = GDScript.new()
	script.source_code = TYPE_TO_SCRIPT_INDEX[type]
	script.reload()
	return script

func get_node_with_connected_script(_name: String, type: ScriptType) -> Node:
	var node: Node = Node.new()
	node.name = _name
	var script: GDScript = get_test_script(type)
	node.set_script(script)
	node.called.connect(register_function_call)
	return node

func get_testable_fixture(_name: String) -> TestFixture:
	var test_fixture: TestFixture = TestFixture.new()
	var test_cases: Node = Node.new()
	test_cases.name = TEST_CASES_NODE_NAME
	var first_test_case: Node = get_node_with_connected_script("First", ScriptType.ONE_TEST_METHOD)
	var second_test_case: Node = get_node_with_connected_script("Second", ScriptType.ONE_TEST_METHOD)
	test_cases.add_child(first_test_case)
	test_cases.add_child(second_test_case)
	test_fixture.add_child(test_cases)
	return test_fixture

func run_test_case(node: Node):
	var fixture: TestFixture = TestFixture.new()
	fixture.run_test_case(node)
