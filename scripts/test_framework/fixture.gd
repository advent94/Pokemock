extends SharedTestUtils

## Implements all functionalities for test execution.
class_name TestFixture

# NOTE: This should either be adjustable or removed. Idea would be to support every method inside
# test case class itself or create visible distinction between test method and helper.
const TEST_PREFIX: String = "should"

# Initial implementation, ideally in future idea is to make it render graphic node representation
# of each test and parse it in object oriented way, print stack for each test case and so on. It's
# just meant to be generic but as simple as possible.

## Main usable function to run all tests contained by test structure.
func run_tests():
	run_test_fixture()

## Runs tests but only for specified test fixture
func run_test_fixture(node: Node = self):
	var test_cases: Array[Node] = node.get_node(TEST_CASES_NODE_NAME).get_children()
	for test_case in test_cases:
		run_test_case(test_case, name)

# NOTE: "await" was added here to wait for each test to finish before starting next one.
# It's true for GTEST approach, also ability to structurize results and ability to stop whole
# execution as soon as any exception is found (not applicable for now). 

# CAUTION / TODO: Current solution is using one testing environment to handle call status
# and temporary nodes for each Test Case but not test method.
# This might be not ideal in future and maybe each test method should have it's own testing 
# environment or small part of it. There is also potential in implementing multithreading
# test case/method/fixture run but it's all matter of design choice. It should be kept simple and 
# work this way as long as it works and doesn't need any further changes.

## Runs test methods for specific test case
func run_test_case(test_case: Node, source: String):
	assert(test_case, "Test case node can't be null")
	
	if not source.is_empty():
		source = source + "." + test_case.name
	else:
		source = test_case.name
	
	var children = test_case.get_children()
	if children.is_empty():
		var methods = test_case.get_method_list()
		for method in methods:
			var test_name = method["name"]
			if Functions.string_starts_with(test_name, TEST_PREFIX):
				await run_test(test_case, test_name, source)
	else:
		for child in children:
			run_test_case(child, source)

func run_test(test_case: Node, test_method: String, source: String):
	print("%s.%s()" % [source, test_method])
	await test_case.call(test_method)
	test_case.teardown()
