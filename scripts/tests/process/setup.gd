extends ProcessTest

func should_be_invalid_after_creation():
	var process: Process = get_base_process(invalid_callable)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_EQ(process.get_type(), Constants.NOT_FOUND)
	EXPECT_EQ(process.get_update(), null)
	EXPECT_EQ(process.get_limit(), null)


func should_setup_properly():
	var process: Process = get_base_process(valid_callable, Update.new(UpdateTest.VALID_INTERVAL_ARRAY))
	
	EXPECT_TRUE(process.update.is_valid())
	EXPECT_TRUE(process.is_valid())


func should_setup_without_update():
	var process: Process = get_base_process()
	
	EXPECT_EQ(process.get_update(), null)
	EXPECT_TRUE(process.is_valid())


func should_set_permanent_flag_on_setup():
	var process: Process = get_base_process(valid_callable, null, true)
	EXPECT_TRUE(process.is_permanent())


func should_force_permanent_flag_removal_on_setup_with_callable_update():
	var process: Process = get_base_process(valid_callable, Update.new(valid_callable), true)
	
	EXPECT_EQ(process.get_update(), Update.Type.CALLABLE)
	EXPECT_FALSE(process.is_permanent())


func should_force_permanent_flag_removal_on_setup_with_signal_update():
	var process: Process = get_base_process(valid_callable, Update.new(valid_signal), true)
	
	EXPECT_EQ(process.get_update(), Update.Type.SIGNAL)
	EXPECT_FALSE(process.is_permanent())


func should_connect_update_to_signal_on_setup_with_signal_update():
	var process: Process = get_base_process(valid_callable, Update.new(valid_signal), true)
	
	EXPECT_EQ(process.get_update(), Update.Type.SIGNAL)
	EXPECT_TRUE(process.update.get_value().is_connected(process._signal_update))


func should_fail_to_setup_with_invalid_init_method():
	var process: Process = get_base_process(invalid_callable)
	
	EXPECT_FALSE(process.is_valid())


func should_fail_to_setup_with_invalid_update():
	var invalid_update: Update = Update.new(null)
	var process: Process = get_base_process(valid_callable, invalid_update)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_ERROR("Invalid update data")


func should_fail_to_setup_with_single_interval_and_modifier_update():
	var modifier: Modifier = Modifier.new()
	var update: Update = Update.new([UpdateTest.VALID_INTERVAL, modifier])
	var process: Process = get_base_process(valid_callable, update)
	
	EXPECT_EQ(update.get_type(), Update.Type.INTERVAL_WITH_MODIFIER)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_ERROR("Invalid update data")


func should_still_be_invalid_after_using_setters_with_valid_arguments():
	var process: Process = get_base_process(invalid_callable)
	
	process.set_update(Update.new(UpdateTest.VALID_INTERVAL_ARRAY))
	process.set_initialization(valid_callable)
	
	EXPECT_TRUE(process.update.is_valid())
	EXPECT_FALSE(process.is_valid())


func should_set_new_initialization():
	var process: Process = get_base_process()

	EXPECT_EQ(valid_callable, process._initialization)
		
	var second_valid_callable: Callable = func(): print("I am valid")
	process.set_initialization(second_valid_callable)
	
	EXPECT_EQ(second_valid_callable, process._initialization)


func should_fail_to_set_invalid_new_initialization():
	var process: Process = get_base_process()

	EXPECT_EQ(valid_callable, process._initialization)
	
	process.set_initialization(invalid_callable)
	
	EXPECT_NEQ(invalid_callable, process._initialization)



