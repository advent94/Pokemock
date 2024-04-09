extends UpdateTest

func should_save_intervals_and_modifiers():
	var modifier: Modifier = Modifier.new()
	var modifiers: Array[Modifier] = [ modifier ]
	var implicit_modifiers = [ modifier ]
		
	var update: Update = Update.new([VALID_INTERVAL_ARRAY, modifiers])
	var implicit_update: Update = Update.new([IMPLICIT_VALID_INTERVAL_ARRAY, implicit_modifiers])
	
	var expected_result: Dictionary = {}
	expected_result[Update.INTERVALS_KEY] = VALID_INTERVAL_ARRAY
	expected_result[Update.MODIFIERS_KEY] = modifiers
	expected_result[Update.STEPS_KEY] = VALID_INTERVAL_ARRAY.size()
	
	EXPECT_EQ(update.get_value(), expected_result)
	EXPECT_EQ(update.get_type(), Update.Type.INTERVALS_AND_MODIFIERS)
	EXPECT_EQ(implicit_update.get_value(), expected_result)
	EXPECT_EQ(implicit_update.get_type(), Update.Type.INTERVALS_AND_MODIFIERS)


func should_be_invalid_for_different_size_modifier_and_interval_array():
	var modifier1: Modifier = Modifier.new()
	var modifier2: Modifier = Modifier.new()
	var array_with_two_modifiers: Array[Modifier] = [ modifier1, modifier2 ]
	var implicit_array_with_two_modifiers = [ modifier1, modifier2 ]
	
	var update: Update = Update.new([VALID_INTERVAL_ARRAY, array_with_two_modifiers])
	var implicit_update: Update = Update.new([IMPLICIT_VALID_INTERVAL_ARRAY, implicit_array_with_two_modifiers])
	
	EXPECT_EQ(update.get_value(), null)
	EXPECT_EQ(update.get_type(), Update.Type.INVALID)
	EXPECT_EQ(implicit_update.get_value(), null)
	EXPECT_EQ(implicit_update.get_type(), Update.Type.INVALID)
	EXPECT_ERROR("Size of modifiers array")


func should_save_corrected_interval_array_with_modifiers_without_changing_original():
	var modifier: Modifier = Modifier.new()
	var modifiers: Array[Modifier] = [ modifier ]
	var implicit_modifiers = [ modifier ]
	var invalid_interval_array: Array[float] = INVALID_INTERVAL_ARRAY.duplicate()
	var implicit_invalid_interval_array = IMPLICIT_INVALID_INTERVAL_ARRAY.duplicate()
	
	var update: Update = Update.new([invalid_interval_array, modifiers], true)
	var implicit_update: Update = Update.new([implicit_invalid_interval_array, implicit_modifiers], true)
	
	var expected_result: Dictionary = {}
	expected_result[Update.INTERVALS_KEY] = VALID_INTERVAL_ARRAY
	expected_result[Update.MODIFIERS_KEY] = modifiers
	
	EXPECT_EQ(update.get_value()[Update.INTERVALS_KEY], expected_result[Update.INTERVALS_KEY])
	EXPECT_EQ(update.get_type(), Update.Type.INTERVALS_AND_MODIFIERS)
	EXPECT_EQ(implicit_update.get_value()[Update.INTERVALS_KEY], expected_result[Update.INTERVALS_KEY])
	EXPECT_EQ(implicit_update.get_type(), Update.Type.INTERVALS_AND_MODIFIERS)
	
	EXPECT_EQ(invalid_interval_array, INVALID_INTERVAL_ARRAY)
	EXPECT_EQ(implicit_invalid_interval_array, IMPLICIT_INVALID_INTERVAL_ARRAY)
	
	EXPECT_NEQ(update.get_value()[Update.MODIFIERS_KEY], expected_result[Update.MODIFIERS_KEY])
	EXPECT_NEQ(implicit_update.get_value()[Update.MODIFIERS_KEY], expected_result[Update.MODIFIERS_KEY])


func should_save_corrected_interval_array_with_modifiers_changing_original():
	var modifier: Modifier = Modifier.new()
	var modifiers: Array[Modifier] = [ modifier ]
	var implicit_modifiers = [ modifier ]
	var invalid_interval_array: Array[float] = INVALID_INTERVAL_ARRAY.duplicate()
	var implicit_invalid_interval_array = IMPLICIT_INVALID_INTERVAL_ARRAY.duplicate()
	
	var update: Update = Update.new([invalid_interval_array, modifiers])
	var implicit_update: Update = Update.new([implicit_invalid_interval_array, implicit_modifiers])
	
	var expected_result: Dictionary = {}
	expected_result[Update.INTERVALS_KEY] = VALID_INTERVAL_ARRAY
	expected_result[Update.MODIFIERS_KEY] = modifiers
	expected_result[Update.STEPS_KEY] = VALID_INTERVAL_ARRAY.size()
	
	EXPECT_EQ(update.get_value(), expected_result)
	EXPECT_EQ(update.get_type(), Update.Type.INTERVALS_AND_MODIFIERS)
	EXPECT_EQ(implicit_update.get_value(), expected_result)
	EXPECT_EQ(implicit_update.get_type(), Update.Type.INTERVALS_AND_MODIFIERS)
	
	EXPECT_NEQ(invalid_interval_array, INVALID_INTERVAL_ARRAY)
	EXPECT_NEQ(implicit_invalid_interval_array, IMPLICIT_INVALID_INTERVAL_ARRAY)
