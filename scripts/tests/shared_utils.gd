extends Node

class_name SharedTestUtils

const TEST_CASES_NODE_NAME: String = "TestCases"
const TESTED_ENTITIES_NODE_NAME: String = "TestedEntity"

## Gets node from TestedEntity tree. Used to easily access, modify entities for testing purposes.
func get_entity(entity_name: String) -> Node:
	var test_fixture = get_test_fixture()
	assert(test_fixture, "Couldn't find test fixture. Make sure that your test scene hierarchy is properly set.")
	assert(test_fixture.has_node("TestedEntity"), "Test fixture(%s) has no TestedEntity node." % test_fixture.name)
	var tested_entity = test_fixture.get_node("TestedEntity")
	assert(tested_entity.has_node(entity_name), "Test fixture(%s) has no entity named: \"%s\"" % [test_fixture.name, entity_name])
	return tested_entity.get_node(entity_name)

## Returns test's fixture or null if not found.
func get_test_fixture() -> Node:
	var found: bool = false
	var node = self
	while found != true && node:
		found = is_test_fixture(node)
		if not found:
			node = node.get_parent()
	if not found:
		node = null
	return node

## Returns true when node's name ends with "Test" and it has tree with test cases to run.
func is_test_fixture(node: Node) -> bool:
	var children_names = Functions.get_children_names(node)
	return node.name.ends_with("Test") and children_names.has(TEST_CASES_NODE_NAME)
