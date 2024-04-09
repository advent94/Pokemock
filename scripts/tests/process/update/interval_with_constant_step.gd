extends UpdateTest

func should_save_expected_interval_for_duration_and_valid_steps():
	var update: Update = Update.new([VALID_DURATION, VALID_UPDATE_COUNT])
	
	EXPECT_EQ(update.get_value()[Update.INTERVAL_KEY], VALID_INTERVAL)


func should_save_expected_steps_for_duration_and_valid_interval():
	var update: Update = Update.new([VALID_DURATION, VALID_INTERVAL])
	
	EXPECT_EQ(update.get_value()[Update.STEPS_KEY], VALID_UPDATE_COUNT)


func should_save_expected_steps_for_implicit_array_with_valid_duration_and_interval():
	var update: Update = Update.new(implicit_valid_duration_with_interval_descriptor)
	
	EXPECT_EQ(update.get_value()[Update.STEPS_KEY], VALID_UPDATE_COUNT)


func should_save_expected_interval_for_duration_and_invalid_steps():
	var update: Update = Update.new([VALID_DURATION, INVALID_UPDATE_COUNT])
	
	EXPECT_EQ(update.get_value()[Update.INTERVAL_KEY], VALID_INTERVAL)


func should_save_expected_steps_for_duration_and_invalid_interval():
	var update: Update = Update.new([VALID_DURATION, INVALID_INTERVAL])
	
	EXPECT_EQ(update.get_value()[Update.STEPS_KEY], VALID_UPDATE_COUNT)


func should_fail_to_initialize_for_low_duration():
	const INVALID_DURATION_WITH_VALID_COUNT = [INVALID_DURATION, VALID_UPDATE_COUNT]
	const INVALID_DURATION_WITH_VALID_INTERUPT = [INVALID_DURATION, VALID_INTERVAL]
	
	var update_with_steps: Update = Update.new(INVALID_DURATION_WITH_VALID_COUNT)
	var update_with_interupt: Update = Update.new(INVALID_DURATION_WITH_VALID_INTERUPT)
		
	EXPECT_EQ(update_with_steps.get_value(), null)
	EXPECT_EQ(update_with_steps.get_type(), Update.Type.INVALID)
	EXPECT_EQ(update_with_interupt.get_value(), null)
	EXPECT_EQ(update_with_interupt.get_type(), Update.Type.INVALID)
	EXPECT_ERROR()


func should_fail_to_interpret_float_array_as_update_with_interval_and_steps():
	var update: Update = Update.new(FLOAT_ARRAY_WITH_TWO_VALID_INTERVALS)
	
	EXPECT_NEQ(update.get_type(), Update.Type.INTERVAL_WITH_UPDATE_STEPS)
	EXPECT_FALSE(update.get_value().keys().has(Update.INTERVAL_KEY))
