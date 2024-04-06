extends FrameworkTest
	
func should_accept_node_with_postfix_and_test_cases_as_test_fixture():
	var test_fixture: Node = CAPTURED_NODE(create_test_fixture())
	
	EXPECT_TRUE(is_test_fixture(test_fixture))


func should_reject_node_with_postfix_without_test_cases_as_test_fixture():
	var node: Node = NODE(VALID_TEST_FIXTURE_NAME)
	
	EXPECT_FALSE(is_test_fixture(node))


func should_rejest_node_without_postfix_with_test_cases_as_test_fixture():
	var node: Node = CAPTURED_NODE(create_test_fixture())
	node.name = INVALID_TEST_FIXTURE_NAME
	
	EXPECT_FALSE(is_test_fixture(node))


func should_reject_main_node_as_test_fixture():
	var main_node: Node = CAPTURED_NODE(create_main_node())
	
	EXPECT_FALSE(is_test_fixture(main_node))
