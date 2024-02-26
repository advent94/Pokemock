extends SharedTestUtils

## Implements all functionalities for test execution.
class_name TestFixture

const TEST_PREFIX: String = "should"

# Initial implementation, ideally in future I would want to make it so you get graphic representation
# of each test and parse it in object oriented way, print stack for each test case and so on. It's
# just meant to be generic but simple in a way that we will only base results on Debugger errors for now

## Main usable function to run all tests contained by test structure.
func run_tests():
	run_test_fixture()

## Runs tests but only for specified test fixture
func run_test_fixture(node: Node = self):
	var test_cases: Array[Node] = node.get_node(TEST_CASES_NODE_NAME).get_children()
	for test_case in test_cases:
		run_test_case(test_case)

## Runs test methods for specific test case
func run_test_case(test_case: Node):
	assert(test_case, "Test case node can't be null")
	var children = test_case.get_children()
	if children.is_empty():
		var methods = test_case.get_method_list()
		for method in methods:
			var test_name = method["name"]
			if Functions.string_starts_with(test_name, TEST_PREFIX):
				run_test(test_case, test_name)
	else:
		for child in children:
			if child is TestFixture:
				print("Running test cases for %s" % child.name)
				run_test_case(child)

func run_test(test_case: Node, test_method: String):
	print("%s is calling testing method: %s" % [test_case.name, test_method])
	test_case.call(test_method)
	test_case.RESET_ALL_CALLS()
