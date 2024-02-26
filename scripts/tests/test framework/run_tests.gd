extends FrameworkTest
	
func should_not_call_anything():
	initialize()
	var node: Node = Node.new()
	run_test_case(node)
	EXPECT_FALSE(was_function_called())
	
func should_call_method_from_source():
	initialize()
	var node: Node = get_node_with_connected_script("Node", ScriptType.ONE_TEST_METHOD)
	run_test_case(node)
	EXPECT_TRUE(was_function_called())

func should_call_two_different_methods_from_source():
	initialize()
	var node: Node = get_node_with_connected_script("Node", ScriptType.TWO_TEST_METHODS)
	run_test_case(node)
	EXPECT_TRUE(was_function_called(TIMES(2)))

func should_execute_childs_test_methods():
	initialize()
	var fixture: TestFixture = TestFixture.new()
	var child: Node = get_node_with_connected_script("Child", ScriptType.ONE_TEST_METHOD)
	fixture.add_child(child)
	fixture.run_test_case(child)
	EXPECT_TRUE(was_function_called())

func should_execute_children_test_methods():
	initialize()
	var fixture: TestFixture = TestFixture.new()
	var child: Node = get_node_with_connected_script("Child", ScriptType.ONE_TEST_METHOD)
	var second_child: Node = get_node_with_connected_script("Second Child", ScriptType.ONE_TEST_METHOD)
	fixture.add_child(child)
	fixture.add_child(second_child)
	fixture.run_test_case(child)
	fixture.run_test_case(second_child)
	EXPECT_TRUE(was_function_called(TIMES(2)))
	
func should_execute_test_fixture():
	initialize()
	var test_fixture: TestFixture = get_testable_fixture("ShouldExecuteFixtureTest")
	test_fixture.run_test_fixture()
	
	EXPECT_TRUE(was_function_called(TIMES(2)))

func should_execute_all_fixtures():
	initialize()
	var main_node: Node = Node.new()
	var main_script: GDScript = get_test_script(ScriptType.TESTING)
	main_node.set_script(main_script)
	var first_test_fixture: Node = get_testable_fixture("FirstTest")
	var second_test_fixture: Node = get_testable_fixture("SecondTest")
	main_node.add_child(first_test_fixture)
	main_node.add_child(second_test_fixture)
	
	main_node.run_all_tests()
	
	EXPECT_TRUE(was_function_called(TIMES(4)))
