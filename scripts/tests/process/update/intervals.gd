extends UpdateTest

func should_fail_to_initialize_for_empty_interval_array():
	var update: Update = Update.new(EMPTY_INTERVAL_ARRAY)
	
	EXPECT_EQ(update.get_value(), null)
	EXPECT_EQ(update.get_type(), Update.Type.INVALID)
	EXPECT_ERROR("Interval array is empty")


func should_use_reference_to_existing_array():
	var valid_interval_array: Array[float] = [VALID_INTERVAL]
	var update: Update = Update.new(valid_interval_array)
	
	EXPECT_EQ(update.get_value()[Update.INTERVALS_KEY], valid_interval_array)
	
	update._value[Update.INTERVALS_KEY][Constants.FIRST_ELEMENT_IN_INDEX] = INVALID_INTERVAL
	
	EXPECT_EQ(update.get_value()[Update.INTERVALS_KEY], valid_interval_array)


func should_make_array_copy():
	var valid_interval_array: Array[float] = [VALID_INTERVAL]	
	var update: Update = Update.new(valid_interval_array, true)
		
	EXPECT_EQ(update.get_value()[Update.INTERVALS_KEY], valid_interval_array)
	
	update._value[Update.INTERVALS_KEY][Constants.FIRST_ELEMENT_IN_INDEX] = INVALID_INTERVAL
	
	EXPECT_NEQ(update.get_value()[Update.INTERVALS_KEY], valid_interval_array)


func should_save_valid_interval_array():
	var update: Update = Update.new(VALID_INTERVAL_ARRAY)
	var update_implicit: Update = Update.new(IMPLICIT_VALID_INTERVAL_ARRAY)
	var update_two_elements_float_array: Update = Update.new(FLOAT_ARRAY_WITH_TWO_VALID_INTERVALS)
	
	EXPECT_EQ(update.get_value()[Update.INTERVALS_KEY], VALID_INTERVAL_ARRAY)
	EXPECT_EQ(update.get_type(), Update.Type.INTERVALS)
	EXPECT_EQ(update_implicit.get_value()[Update.INTERVALS_KEY], VALID_INTERVAL_ARRAY)
	EXPECT_EQ(update_implicit.get_type(), Update.Type.INTERVALS)
	EXPECT_EQ(update_two_elements_float_array.get_value()[Update.INTERVALS_KEY], FLOAT_ARRAY_WITH_TWO_VALID_INTERVALS)
	EXPECT_EQ(update_two_elements_float_array.get_type(), Update.Type.INTERVALS)


func should_not_interpret_implicit_array_with_two_floats_as_interval_array():
	var update: Update = Update.new(implicit_valid_duration_with_interval_descriptor)
	
	EXPECT_NEQ(update.get_type(), Update.Type.INTERVALS)
	EXPECT_FALSE(update.get_value().keys().has(Update.INTERVALS_KEY))


func should_save_corrected_interval_array_without_changing_original():
	var invalid_interval_array: Array[float] = INVALID_INTERVAL_ARRAY.duplicate()
	var implicit_invalid_interval_array: Array = IMPLICIT_INVALID_INTERVAL_ARRAY.duplicate()
	var update: Update = Update.new(invalid_interval_array, true)
	var update_implicit: Update = Update.new(implicit_invalid_interval_array, true)
	
	EXPECT_EQ(update.get_value()[Update.INTERVALS_KEY], VALID_INTERVAL_ARRAY)
	EXPECT_EQ(update.get_type(), Update.Type.INTERVALS)
	EXPECT_EQ(update_implicit.get_value()[Update.INTERVALS_KEY], VALID_INTERVAL_ARRAY)
	EXPECT_EQ(update_implicit.get_type(), Update.Type.INTERVALS)
	
	EXPECT_EQ(invalid_interval_array, INVALID_INTERVAL_ARRAY)
	EXPECT_EQ(implicit_invalid_interval_array, IMPLICIT_INVALID_INTERVAL_ARRAY)


func should_save_corrected_interval_array_changing_original():
	var invalid_interval_array: Array[float] = INVALID_INTERVAL_ARRAY.duplicate()
	var implicit_invalid_interval_array: Array = IMPLICIT_INVALID_INTERVAL_ARRAY.duplicate()
	var update: Update = Update.new(invalid_interval_array)
	var update_implicit: Update = Update.new(implicit_invalid_interval_array)
	
	EXPECT_EQ(update.get_value()[Update.INTERVALS_KEY], VALID_INTERVAL_ARRAY)
	EXPECT_EQ(update.get_type(), Update.Type.INTERVALS)
	EXPECT_EQ(update_implicit.get_value()[Update.INTERVALS_KEY], VALID_INTERVAL_ARRAY)
	EXPECT_EQ(update_implicit.get_type(), Update.Type.INTERVALS)
	
	EXPECT_NEQ(invalid_interval_array, INVALID_INTERVAL_ARRAY)
	EXPECT_NEQ(implicit_invalid_interval_array, IMPLICIT_INVALID_INTERVAL_ARRAY)


func should_fail_to_interpret_float_array_as_update_with_interval_and_steps():
	var update: Update = Update.new(FLOAT_ARRAY_WITH_TWO_VALID_INTERVALS)
	
	EXPECT_NEQ(update.get_type(), Update.Type.INTERVAL_WITH_UPDATE_STEPS)
	EXPECT_FALSE(update.get_value().keys().has(Update.INTERVAL_KEY))
