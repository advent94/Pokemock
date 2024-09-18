extends UpdateTest

func should_save_interval_and_modifier():
	var modifier: Modifier = Modifier.new()
	var update: Update = Update.new([VALID_INTERVAL, modifier])
	
	var expected_result: Dictionary = {}
	expected_result[Update.INTERVAL_KEY] = VALID_INTERVAL
	expected_result[Update.MODIFIER_KEY] = modifier
	
	EXPECT_EQ(update.get_value(), expected_result)
	EXPECT_EQ(update.get_type(), Update.Type.INTERVAL_AND_MODIFIER)


func should_save_corrected_interval_with_modifier():
	var modifier: Modifier = Modifier.new()
	var update: Update = Update.new([INVALID_INTERVAL, modifier])
	
	var expected_result: Dictionary = {}
	expected_result[Update.INTERVAL_KEY] = VALID_INTERVAL
	expected_result[Update.MODIFIER_KEY] = modifier
	
	EXPECT_EQ(update.get_value(), expected_result)
	EXPECT_EQ(update.get_type(), Update.Type.INTERVAL_AND_MODIFIER)
