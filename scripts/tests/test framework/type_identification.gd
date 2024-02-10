extends TestingFramework

func should_accept_node_with_test_fixtures_as_main():
	var main_node: Node = create_main_node()
	
	EXPECT_TRUE(is_main(main_node))

func should_reject_node_with_no_postfix_children_with_test_cases_as_main():
	var main_node: Node = Node.new()
	var test_fixture: Node = create_test_fixture()
	test_fixture.name = INVALID_TEST_FIXTURE_NAME
	main_node.add_child(test_fixture)
	
	EXPECT_FALSE(is_main(main_node))

func should_reject_node_with_test_postfix_children_without_test_cases_as_main():
	var main_node: Node = Node.new()
	var node: Node = Node.new()
	node.name = VALID_TEST_FIXTURE_NAME
	main_node.add_child(node)
	
	EXPECT_FALSE(is_main(main_node))

func should_reject_valid_test_fixture_as_main():
	var test_fixture: Node = create_test_fixture()
	
	EXPECT_FALSE(is_main(test_fixture))
	
func should_accept_node_with_postfix_and_test_cases_as_test_fixture():
	var test_fixture: Node = create_test_fixture()
	
	EXPECT_TRUE(is_test_fixture(test_fixture))

func should_reject_node_with_postfix_without_test_cases_as_test_fixture():
	var node: Node = Node.new()
	node.name = VALID_TEST_FIXTURE_NAME
	
	EXPECT_FALSE(is_test_fixture(node))
	
func should_rejest_node_without_postfix_with_test_cases_as_test_fixture():
	var node: Node = create_test_fixture()
	node.name = INVALID_TEST_FIXTURE_NAME
	
	EXPECT_FALSE(is_test_fixture(node))
	
func should_reject_main_node_as_test_fixture():
	var main_node: Node = create_main_node()
	
	EXPECT_FALSE(is_test_fixture(main_node))
