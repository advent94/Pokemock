extends TestMethods

class_name Testing

const TEST_CASES_NODE_NAME: String = "TestCases"
const TEST_PREFIX: String = "should"
const TESTED_ENTITIES_NODE_NAME: String = "TestedEntity"

func get_entity(entity_name: String) -> Node:
	var test_fixture = get_test_fixture()
	assert(test_fixture, "Couldn't find test fixture. Make sure that your test scene hierarchy is properly set.")
	assert(test_fixture.has_node("TestedEntity"), "Test fixture(%s) has no TestedEntity node." % test_fixture.name)
	var tested_entity = test_fixture.get_node("TestedEntity")
	assert(tested_entity.has_node(entity_name), "Test fixture(%s) has no entity named: \"%s\"" % [test_fixture.name, entity_name])
	return tested_entity.get_node(entity_name)

func is_test_fixture(node: Node) -> bool:
	var children_names = Functions.get_children_names(node)
	return node.name.ends_with("Test") and children_names.has(TEST_CASES_NODE_NAME)

# Initial implementation, ideally in future I would want to make it so you get graphic representation
# of each test and parse it in object oriented way, print stack for each test case and so on. It's
# just meant to be generic but simple in a way that we will only base results on Debugger errors for now

func is_main(node: Node) -> bool:
	var result = true
	var children_names = Functions.get_children_names(node)
	for children_name in children_names:
		if not children_name.ends_with("Test"):
			result = false
			break
	if result:
		var children = node.get_children()
		for child in children:
			if not Functions.get_children_names(child).has("TestCases"):
				result = false
				break
	return result
	
func get_test_fixture() -> Node:
	var found: bool = false
	var node = self
	while found != true && node:
		found = is_test_fixture(node)
		if not found:
			node = node.get_parent()
	return node

func run_all_tests():
	for child in get_children():
		run_test_fixture(child)
	
func run_test_fixture(node: Node):
	var test_cases: Array[Node] = node.get_node(TEST_CASES_NODE_NAME).get_children()
	for test_case in test_cases:
		run_test_case(test_case)

func run_test_case(test_case: Node):
	assert(test_case, "Test case node can't be null")
	var children = test_case.get_children()
	if children.is_empty():
		var tests = test_case.get_method_list()
		for test in tests:
			var test_name = test["name"]
			if Functions.string_starts_with(test_name, TEST_PREFIX):
				print("%s is calling testing method: %s" % [test_case.name, test_name])
				test_case.call(test_name)
	else:
		for child in children:
			if child.has_method("run_test_case"):
				print("Running test cases for %s" % child.name)
				run_test_case(child)

func run_tests():
	if is_main(self):
		run_all_tests()
	elif is_test_fixture(self):
		run_test_fixture(self)
	else:
		run_test_case(self)