extends ProcessTest

func should_get_corrupted_interval_and_die():
	var process: Process = get_base_process()
	var update: Update = Update.new([VERY_LONG_TIME, SHORT_INTERVAL])
	
	process.setup(valid_callable, update)
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.update._value.erase(Update.STEPS_KEY)
	process.start()
	
	await process.killed

	EXPECT_FALSE(CALLED(UPDATE))	
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())


func should_schedule_first_update():
	var update: Update = Update.new([VERY_LONG_TIME, VERY_LONG_TIME])
	var process: Process = get_base_process()
	process.setup(valid_callable, update)
	
	EXPECT_EQ(process.update.timer, null)
	
	process.start()
	
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())
	EXPECT_NEQ(process.update.timer, null)
	EXPECT_FALSE(process.update.timer.time_left == 0)
	EXPECT_FALSE(process.update.timer.is_stopped())


func should_die_after_schedule_due_to_update_corruption():
	var update: Update = Update.new([VERY_LONG_TIME, LONGER_INTERVAL])
	var process: Process = get_base_process()
	process.setup(valid_callable, update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))	
	process.start()
	
	process.update = null
	
	await process.killed
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))


func should_die_after_being_unable_to_find_modifier_in_update():
	var update: Update = Update.new([[LONGER_INTERVAL], [Modifier.new()]])
	var process: Process = get_base_process()
	process.setup(valid_callable, update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))	
	process.start()
	
	process.update._value.erase(Update.MODIFIERS_KEY)
	
	await process.killed
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))


func should_update_with_specified_modifier():
	var update: Update = Update.new([[SHORT_INTERVAL], [Modifier.new()]])
	var process: Process = get_stubbed_process(update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.finished.connect(CALL_STATUS_UPDATE(FINISH))
	process.start()
	
	await Functions.wait(LONGER_INTERVAL)

	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(CALLED(UPDATE))
	EXPECT_FALSE(CALLED(FINISH))


func should_fail_to_update_with_default_modifiers_without_steps():
	var update: Update = Update.new([VERY_LONG_TIME, SHORT_INTERVAL])
	var process: Process = get_stubbed_process(update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	process.update._value.erase(Update.STEPS_KEY)
	
	await process.killed

	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))


func should_get_null_default_modifiers_and_die():
	var update: Update = Update.new([VERY_LONG_TIME, SHORT_INTERVAL])
	var process: Process = get_stubbed_process(update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	process.set_default_mod(null)

	await process.killed
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))


func should_get_invalid_default_modifiers_and_die():
	var update: Update = Update.new([VERY_LONG_TIME, SHORT_INTERVAL])
	var process: Process = get_stubbed_process(update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	process.set_default_mod(FakeInvalidModifier.new())

	await process.killed
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))


func should_get_valid_default_modifiers_but_fail_update_and_die():
	var update: Update = Update.new([VERY_LONG_TIME, SHORT_INTERVAL])
	var process: Process = get_stubbed_process(update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	process.set_one_status_return(false)

	await process.killed
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))


func should_get_valid_default_modifiers_and_update():
	var update: Update = Update.new([VERY_LONG_TIME, SHORT_INTERVAL])
	var process: Process = get_stubbed_process(update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.inner_update_called.connect(CALL_STATUS_UPDATE(INNER_UPDATE))
	process.start()

	await process.updated
	
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(INNER_UPDATE))


func should_get_valid_default_modifiers_do_update_and_finish():
	var update: Update = Update.new([SHORT_INTERVAL, SHORT_INTERVAL])
	var process: Process = get_stubbed_process(update)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.finished.connect(CALL_STATUS_UPDATE(FINISH))
	process.set_limit(1)
	process.start()

	await process.finished
	
	EXPECT_TRUE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	EXPECT_TRUE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(FINISH))
