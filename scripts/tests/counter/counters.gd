extends CounterTesting

func should_add_new_clock_with_registered_name():
	var system: Node = get_system()
	var counter_index: Dictionary = system._name_to_counter
	
	EXPECT_EQ(counter_index.size(), Constants.EMPTY)
	EXPECT_FALSE(system.exists(TESTED_COUNTER_NAME))
	
	system.register(TESTED_COUNTER_NAME)
	
	EXPECT_TRUE(system.exists(TESTED_COUNTER_NAME))
	EXPECT_EQ(counter_index.size(), Constants.ONE_ELEMENT)
	EXPECT_TRUE(counter_index.keys().has(TESTED_COUNTER_NAME))


func should_return_same_counter_as_registered():
	var system: Node = get_system()
	var counter: Counter = system.register(TESTED_COUNTER_NAME)
	
	EXPECT_EQ(counter, system.get_instance(TESTED_COUNTER_NAME))


func should_remove_counter_after_it_finishes():
	var system: Node = get_system()
	system.register(TESTED_COUNTER_NAME, Counter.new(1))
	
	EXPECT_TRUE(system.exists(TESTED_COUNTER_NAME))
	
	system.get_instance(TESTED_COUNTER_NAME).increment()

	EXPECT_FALSE(system.exists(TESTED_COUNTER_NAME))


func should_not_remove_counter_that_resets():
	var system: Node = get_system()
	var counter: AdvancedCounter = get_counter_that_resets()
	system.register(TESTED_COUNTER_NAME, counter)
	
	EXPECT_TRUE(system.exists(TESTED_COUNTER_NAME))
	counter.increment()
	EXPECT_TRUE(system.exists(TESTED_COUNTER_NAME))
	

func should_remove_counter_on_node_exit():
	var system: Node = get_system()
	system.register(TESTED_COUNTER_NAME)
	
	EXPECT_TRUE(system.exists(TESTED_COUNTER_NAME))
	
	var node: Node = Node.new()
	system.bind_to_node(TESTED_COUNTER_NAME, node)
	await node.tree_exiting
	
	EXPECT_FALSE(system.exists(TESTED_COUNTER_NAME))
