extends ProcessTest

func should_be_invalid_after_creation():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_EQ(process.get_type(), Constants.NOT_FOUND)
	EXPECT_EQ(process.get_update(), null)
	EXPECT_EQ(process.get_limit(), null)


func should_setup_properly():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_valid())
	
	process.setup(valid_callable, Update.new(UpdateTest.VALID_INTERVAL_ARRAY))
	
	EXPECT_TRUE(process.update.is_valid())
	EXPECT_TRUE(process.is_valid())


func should_setup_without_update():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_valid())
	
	process.setup(valid_callable)
	
	EXPECT_EQ(process.get_update(), null)
	EXPECT_TRUE(process.is_valid())


func should_set_permanent_flag_on_setup():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_permanent())
	
	process.setup(valid_callable, null, true)
	
	EXPECT_TRUE(process.is_permanent())


func should_force_permanent_flag_removal_on_setup_with_callable_update():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_permanent())
	
	process.setup(valid_callable, Update.new(valid_callable), true)
	
	EXPECT_EQ(process.get_update(), Update.Type.CALLABLE)
	EXPECT_FALSE(process.is_permanent())


func should_force_permanent_flag_removal_on_setup_with_signal_update():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_permanent())
	
	process.setup(valid_callable, Update.new(valid_signal), true)
	
	EXPECT_EQ(process.get_update(), Update.Type.SIGNAL)
	EXPECT_FALSE(process.is_permanent())


func should_connect_update_to_signal_on_setup_with_signal_update():
	var process: Process = get_base_process()
	
	process.setup(valid_callable, Update.new(valid_signal), true)
	
	EXPECT_EQ(process.get_update(), Update.Type.SIGNAL)
	EXPECT_TRUE(process.update.get_value().is_connected(process._signal_update))


func should_throw_warn_when_trying_to_setup_during_runtime():
	var process: Process = get_base_process()
		
	process.setup(valid_callable)
	process.start()
	
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())
	
	process.setup(valid_callable)


func should_fail_to_setup_with_invalid_init_method():
	var process: Process = get_base_process()
	
	@warning_ignore("unassigned_variable")
	var callable: Callable
	
	process.setup(callable)
	
	EXPECT_FALSE(process.is_valid())


func should_fail_to_setup_with_invalid_update():
	var process: Process = get_base_process()
	var invalid_update: Update = Update.new(null)
	
	process.setup(valid_callable, invalid_update)
	
	EXPECT_FALSE(process.is_valid())


func should_fail_to_setup_with_single_interval_and_modifier_update():
	var process: Process = get_base_process()
	var modifier: Modifier = Modifier.new()
	var update: Update = Update.new([UpdateTest.VALID_INTERVAL, modifier])
	
	EXPECT_EQ(update.get_type(), Update.Type.INTERVAL_WITH_MODIFIER)
	
	process.setup(valid_callable, update)
	
	EXPECT_FALSE(process.is_valid())


func should_still_be_invalid_after_using_setters_with_valid_arguments():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_valid())
	
	process.set_update(Update.new(UpdateTest.VALID_INTERVAL_ARRAY))
	process.set_initialization(valid_callable)
	
	EXPECT_TRUE(process.update.is_valid())
	EXPECT_FALSE(process.is_valid())


func should_set_new_initialization():
	var process: Process = get_base_process()
	process.setup(valid_callable)

	EXPECT_EQ(valid_callable, process._initialization)
		
	var second_valid_callable: Callable = func(): print("I am valid")
	process.set_initialization(second_valid_callable)
	
	EXPECT_EQ(second_valid_callable, process._initialization)


func should_fail_to_set_invalid_new_initialization():
	var process: Process = get_base_process()
	process.setup(valid_callable)

	EXPECT_EQ(valid_callable, process._initialization)
	
	@warning_ignore("unassigned_variable")
	var invalid_callable: Callable
	process.set_initialization(invalid_callable)
	
	EXPECT_NEQ(invalid_callable, process._initialization)



