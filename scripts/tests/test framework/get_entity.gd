extends FrameworkTest

func should_get_entity_from_test_case():
	var test_fixture = create_test_fixture()
	var entities: Node = Node.new()
	entities.name = TESTED_ENTITIES_NODE_NAME
	var entity: Node = Node.new()
	entity.name = "Entity"
	entities.add_child(entity)
	test_fixture.add_child(entities)
	var test_case: Node = Node.new()
	var script: GDScript = get_test_script(ScriptType.TESTING)
	test_case.set_script(script)
	test_fixture.get_node(TEST_CASES_NODE_NAME).add_child(test_case)
	
	EXPECT_EQ(test_case.get_entity("Entity"), entity)

func should_get_entity_from_nested_test_case():
	var test_fixture = create_test_fixture()
	var entities: Node = Node.new()
	entities.name = TESTED_ENTITIES_NODE_NAME
	var entity: Node = Node.new()
	entity.name = "Entity"
	entities.add_child(entity)
	test_fixture.add_child(entities)
	var test_case: Node = Node.new()
	var nested_test_case: Node = Node.new()
	var script: GDScript = get_test_script(ScriptType.TESTING)
	nested_test_case.set_script(script)
	test_case.add_child(nested_test_case)
	test_fixture.get_node(TEST_CASES_NODE_NAME).add_child(test_case)
	
	EXPECT_EQ(nested_test_case.get_entity("Entity"), entity)
