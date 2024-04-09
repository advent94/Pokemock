extends ProcessTest

func should_execute_correctly():
	var process: Process = get_base_process()
	
	process.setup(valid_callable)
	process.start()
	process.paused.connect(CALL_STATUS_UPDATE(PAUSE))
	process.pause()
	
	EXPECT_TRUE(CALLED(PAUSE))
	EXPECT_TRUE(process.is_paused())


func should_ignore_when_invalid():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())

	process.paused.connect(CALL_STATUS_UPDATE(PAUSE))
	
	process.pause()
	
	EXPECT_FALSE(CALLED(PAUSE))
	EXPECT_FALSE(process.is_paused())


func should_ignore_when_valid_not_active():
	var process: Process = get_base_process()
	
	process.setup(valid_callable)
	
	EXPECT_TRUE(process.is_valid())
	EXPECT_FALSE(process.is_active())

	process.paused.connect(CALL_STATUS_UPDATE(PAUSE))
	
	process.pause()
	
	EXPECT_FALSE(CALLED(PAUSE))
	EXPECT_FALSE(process.is_paused())


func should_ignore_when_already_paused():
	var process: Process = get_base_process()
	
	process.setup(valid_callable)
	process.start()
	process.pause()
	
	EXPECT_TRUE(process.is_paused())
	
	process.paused.connect(CALL_STATUS_UPDATE(PAUSE))
	process.pause()
	
	EXPECT_FALSE(CALLED(PAUSE))
	EXPECT_TRUE(process.is_paused())


func should_pause_time_limit():
	var process: Process = get_base_process()
	var limiter: Limiter = Limiter.new(LimiterTest.VALID_TIME_LIMIT, process)
		
	process.setup(valid_callable)
	process.set_limit(limiter)
	process.start()
	
	EXPECT_TRUE(limiter.is_active())
	EXPECT_FALSE(limiter.is_paused())
	
	var value_before_pause: float = limiter.left()
	
	process.pause()
	
	await Functions.wait(TIME_FOR_CLEAN_UP)
	
	EXPECT_TRUE(limiter.is_paused())
	EXPECT_FALSE(limiter.is_active())
	EXPECT_FLOAT_EQ(value_before_pause, limiter.left())
	

func should_pause_pending_update():
	var process: Process = get_base_process()
	
	process.setup(valid_callable, valid_signal)
	process.start()
	
	process.update.timer = AdvancedTimer.new(VERY_LONG_TIME)
	process.add_child(process.update.timer)
	process.update.timer.start()
	
	EXPECT_FALSE(process.update.timer.is_paused())
	
	process.pause()
	
	EXPECT_TRUE(process.update.timer.is_paused())


func should_disable_signal_update():
	var process: Process = get_stubbed_process(valid_signal_with_modifier)
	
	process.inner_update_called.connect(CALL_STATUS_UPDATE(INNER_UPDATE))
	process.start()
	process.pause()
	
	valid_signal_with_modifier.emit(Modifier.new())
	
	EXPECT_FALSE(CALLED(INNER_UPDATE))


func should_call_inner_function_and_pause_running_process():
	var process: Process = get_stubbed_process(valid_signal)
	
	process.inner_pause_called.connect(CALL_STATUS_UPDATE(INNER_PAUSE))
	process.start()
	process.pause()
	
	EXPECT_TRUE(CALLED(INNER_PAUSE))
	EXPECT_TRUE(process.is_paused())


func should_kill_after_failing_inner_pause_function():
	var process: Process = get_stubbed_process(valid_signal)
	
	process.inner_pause_called.connect(CALL_STATUS_UPDATE(INNER_PAUSE))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	process.set_one_status_return(false)
	process.pause()
	
	EXPECT_TRUE(CALLED(INNER_PAUSE))
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_active())
	EXPECT_ERROR("Pause failed")
