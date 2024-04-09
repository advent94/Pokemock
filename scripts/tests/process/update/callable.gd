extends UpdateTest

func should_not_initialize_for_invalid_callable():
	@warning_ignore("unassigned_variable")
	var callable: Callable
	var update: Update = Update.new(callable)
	
	EXPECT_EQ(update.get_type(), Update.Type.INVALID)
	EXPECT_EQ(update.get_value(), null)
	EXPECT_ERROR("Invalid callable")


func should_initialize_valid_callable():
	var callable: Callable = func(args): return args
	var update: Update = Update.new(callable)
	
	EXPECT_EQ(update.get_type(), Update.Type.CALLABLE)
	EXPECT_EQ(update.get_value(), callable)
