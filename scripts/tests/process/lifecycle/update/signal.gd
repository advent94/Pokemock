extends ProcessTest

func should_throw_error_and_die_when_signal_update_called():
	var process: Process = get_base_process()
	
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.set_update(valid_signal)
	valid_signal.emit(Modifier.new())
	
	EXPECT_EQ(process.get_update(), Update.Type.SIGNAL)
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_ERROR("Tried to update invalid process")


func should_fail_with_null_modifier():
	var process: Process = get_base_process()
	
	setup_and_start_signal_modifier_test_process(process)
	valid_signal_with_modifier.emit(null)
	
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_ERROR("Null modifier")


func should_fail_with_invalid_modifier_type():
	var process: Process = get_base_process()
	
	setup_and_start_signal_modifier_test_process(process)
	valid_signal_with_modifier.emit(FakeInvalidModifier.new())
	
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_ERROR("Invalid modifier type")


func should_die_with_no_overloaded_inner_update():
	var process: Process = get_base_process()
	
	setup_and_start_signal_modifier_test_process(process)
	valid_signal_with_modifier.emit(Modifier.new())
	
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_ERROR("Invalid update called")


func should_succeed_and_call_inner_update():
	var process: Process = get_stubbed_process(valid_signal_with_modifier)
	
	setup_and_start_signal_modifier_test_process(process)
	valid_signal_with_modifier.emit(Modifier.new())
	
	EXPECT_TRUE(CALLED(UPDATE))
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())


func should_die_after_inner_update_fails():
	var process: Process = get_stubbed_process(valid_signal_with_modifier)
	
	setup_and_start_signal_modifier_test_process(process)
	process.set_one_status_return(false)
	valid_signal_with_modifier.emit(Modifier.new())
	
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_ERROR("Update failed")
