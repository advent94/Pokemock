extends ProcessTest

func should_deactivate_running_process():
	var process: Process = get_base_process()
	
	process.setup(valid_callable)
	process.start()
	
	EXPECT_TRUE(process.is_active())
	
	process.stopped.connect(CALL_STATUS_UPDATE(STOP))
	process.stop()
	
	EXPECT_FALSE(process.is_active())
	EXPECT_TRUE(CALLED(STOP))


func should_ignore_when_invalid():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())

	process.stopped.connect(CALL_STATUS_UPDATE(STOP))
	
	process.stop()
	
	EXPECT_FALSE(CALLED(STOP))


func should_not_execute_on_inactive_process():
	var process: Process = get_base_process()
	
	process.setup(valid_callable)
	process.start()
	
	process.stop()
	process.stopped.connect(CALL_STATUS_UPDATE(STOP))
	process.stop()
	
	EXPECT_FALSE(CALLED(STOP))


func should_reset_counter_limit():
	var process: Process = get_base_process()
	var limiter: Limiter = Limiter.new(CounterTest.TWO_DEFAULT_INCREMENTS)
	
	limiter.increment()
	
	EXPECT_EQ(limiter.left(), CounterTest.DEFAULT_INCREMENT_VALUE)
	
	process.setup(valid_callable)
	process.set_limit(limiter)
	process.start()
	process.stop()
	
	EXPECT_EQ(limiter.left(), CounterTest.TWO_DEFAULT_INCREMENTS)


func should_reset_time_limit():
	var process: Process = get_base_process()
	var limiter: Limiter = Limiter.new(LimiterTest.VALID_TIME_LIMIT, process)
	
	EXPECT_FLOAT_EQ(limiter.left(), LimiterTest.VALID_TIME_LIMIT)
	
	process.setup(valid_callable)
	process.set_limit(limiter)
	process.start()
	
	await Functions.wait(Constants.MIN_TIME_BETWEEN_UPDATES)

	EXPECT_TRUE(limiter.left() < LimiterTest.VALID_TIME_LIMIT)
	EXPECT_TRUE(limiter.is_active())
	
	process.stop()
	
	EXPECT_EQ(limiter.left(), LimiterTest.VALID_TIME_LIMIT)
	EXPECT_FALSE(limiter.is_active())


func should_remove_pending_update():
	var process: Process = get_base_process()
	
	process.setup(valid_callable, valid_signal)
	process.start()
	
	process.update.timer = AdvancedTimer.new(VERY_LONG_TIME)
	process.add_child(process.update.timer)
	process.update.timer.start()
	
	EXPECT_FALSE(process.update.timer.is_stopped())
	EXPECT_TRUE(process.update.timer != null)
	
	process.stop()
	
	EXPECT_TRUE(process.update.timer == null)


func should_disable_signal_update():
	var process: Process = get_stubbed_process(valid_signal_with_modifier)
	
	process.inner_update_called.connect(CALL_STATUS_UPDATE(INNER_UPDATE))
	process.start()
	process.stop()
	
	valid_signal_with_modifier.emit(Modifier.new())
	
	EXPECT_FALSE(CALLED(INNER_UPDATE))


func should_call_inner_stop_and_deactivate_running_process():
	var process: Process = get_stubbed_process(valid_signal)
	
	process.inner_stop_called.connect(CALL_STATUS_UPDATE(INNER_STOP))
	process.start()
	process.stop()
	
	EXPECT_TRUE(CALLED(INNER_STOP))
	EXPECT_FALSE(process.is_active())


func should_terminate_after_failing_inner_stop_function():
	var process: Process = get_stubbed_process(valid_signal)
	
	process.inner_stop_called.connect(CALL_STATUS_UPDATE(INNER_STOP))
	process.terminating.connect(CALL_STATUS_UPDATE(TERMINATION))
	process.start()
	process.set_one_status_return(false)
	process.stop()
	
	EXPECT_ERROR("Stop failed")
	
	await Functions.wait(Constants.MIN_TIME_BETWEEN_UPDATES)
	
	EXPECT_TRUE(CALLED(INNER_STOP))
	EXPECT_TRUE(CALLED(TERMINATION))
	EXPECT_TRUE(process == null)
