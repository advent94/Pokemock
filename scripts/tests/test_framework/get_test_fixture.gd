extends FrameworkTest

func should_get_test_fixture():
	var node: Node = create_empty_testing_node()
	var fixture: Node = CAPTURED_NODE(create_test_fixture())
	fixture.get_node(TEST_CASES_NODE_NAME).add_child(node)
	
	EXPECT_TRUE(node.get_test_fixture() != null)


func should_fail_to_get_test_fixture_when_missing_test_cases():
	var node: Node = create_empty_testing_node()
	var fixture: Node = create_test_fixture()
	fixture.get_node(TEST_CASES_NODE_NAME).free()
	fixture.add_child(node)
	
	EXPECT_TRUE(node.get_test_fixture() == null)
	
	CAPTURE_NODE(fixture)


func should_fail_to_get_test_fixture_with_missing_name_postfix():
	var node: Node = create_empty_testing_node()
	var fixture: Node = create_test_fixture()
	fixture.name = fixture.name.erase(fixture.name.length() - "Test".length(), "Test".length())
	fixture.get_node(TEST_CASES_NODE_NAME).add_child(node)
	
	EXPECT_TRUE(node.get_test_fixture() == null)
	
	CAPTURE_NODE(fixture)
