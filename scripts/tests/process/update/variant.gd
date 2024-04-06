extends UpdateTest

func should_properly_validate_variants():
	const INVALID_DESCRIPTOR: String = "INVALID"
	const INVALID_SIZE_ARRAY: Array = [0, 1, 2]
	const IMPLICIT_FLOAT_ARRAY: Array = [INVALID_INTERVAL]
	const VALID_SIZE_INVALID_TYPE_ARRAY: Array = [VALID_INTERVAL, INVALID_DESCRIPTOR]
	const VALID_DURATION_WITH_COUNT_DESCRIPTOR: Array = [VALID_DURATION, VALID_UPDATE_COUNT]
	const VALID_DURATION_WITH_INVALID_DESCRIPTOR: Array = [VALID_DURATION, INVALID_DESCRIPTOR]
	
	var modifier: Modifier = Modifier.new()
	var modifier_array: Array[Modifier] = [modifier]
	var implicit_valid_intervals_with_modifiers: Array = [[VALID_INTERVAL], [modifier]]
	var explicit_valid_intervals_with_modifiers: Array = [VALID_INTERVAL_ARRAY, modifier_array]
	var valid_interval_with_modifier: Array = [VALID_INTERVAL, modifier]
	var update: Update = Update.new(null)
	
	@warning_ignore("unassigned_variable")
	var callable: Callable
	
	EXPECT_EQ(update._identify_type(EMPTY_INTERVAL_ARRAY), Update.Type.INTERVALS)
	EXPECT_EQ(update._identify_type(IMPLICIT_FLOAT_ARRAY), Update.Type.INTERVALS)
	EXPECT_EQ(update._identify_type(FLOAT_ARRAY_WITH_TWO_VALID_INTERVALS), Update.Type.INTERVALS)
	EXPECT_EQ(update._identify_type(VALID_DURATION_WITH_COUNT_DESCRIPTOR), Update.Type.INTERVAL_WITH_UPDATE_STEPS)
	EXPECT_EQ(update._identify_type(implicit_valid_duration_with_interval_descriptor), Update.Type.INTERVAL_WITH_UPDATE_STEPS)
	EXPECT_EQ(update._identify_type(implicit_valid_intervals_with_modifiers), Update.Type.INTERVALS_AND_MODIFIERS) 
	EXPECT_EQ(update._identify_type(explicit_valid_intervals_with_modifiers), Update.Type.INTERVALS_AND_MODIFIERS)
	EXPECT_EQ(update._identify_type(valid_interval_with_modifier), Update.Type.INTERVAL_WITH_MODIFIER)
	EXPECT_EQ(update._identify_type(callable), Update.Type.CALLABLE)
	EXPECT_EQ(update._identify_type(valid_signal), Update.Type.SIGNAL)
	
	EXPECT_EQ(update._identify_type(INVALID_SIZE_ARRAY), Update.Type.INVALID)
	EXPECT_EQ(update._identify_type(VALID_SIZE_INVALID_TYPE_ARRAY), Update.Type.INVALID)
	EXPECT_EQ(update._identify_type(VALID_DURATION_WITH_INVALID_DESCRIPTOR), Update.Type.INVALID)

func should_copy_existing_update():
	var update: Update = Update.new(VALID_INTERVAL_ARRAY.duplicate())
	var shallow_update_copy: Update = Update.new(update)
	
	EXPECT_EQ(update.get_value(), shallow_update_copy.get_value())
	EXPECT_EQ(update.get_type(), shallow_update_copy.get_type())
	
	update._value[0] = INVALID_INTERVAL
	
	EXPECT_EQ(update.get_value(), shallow_update_copy.get_value())


func should_make_deep_copy_of_existing_update():
	var update: Update = Update.new(VALID_INTERVAL_ARRAY.duplicate())
	var deep_update_copy: Update = Update.new(update, true)
		
	EXPECT_EQ(update.get_value(), deep_update_copy.get_value())
	EXPECT_EQ(update.get_type(), deep_update_copy.get_type())
	
	update._value[0] = INVALID_INTERVAL
	
	EXPECT_NEQ(update.get_value(), deep_update_copy.get_value())
