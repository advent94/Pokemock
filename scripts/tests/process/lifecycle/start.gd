extends ProcessTest

func should_properly_execute():
	var process: Process = get_base_process()

	
	EXPECT_FALSE(process.is_active())
	
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.start()
	
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(CALLED(START))


func should_not_execute_again_when_called_active():
	var process: Process = get_base_process()
	
	process.start()
	process.started.connect(CALL_STATUS_UPDATE(START))
	
	EXPECT_FALSE(CALLED(START))
	
	process.start()
	
	EXPECT_FALSE(CALLED(START))


func should_throw_error_and_terminate_freeing_resources_for_orphan_invalid_process():
	#NOTE: This is necessary to automatically free resources(parent == null)
	var process: Process = Process.new(invalid_callable)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_TRUE(process != null)
	
	process.terminating.connect(CALL_STATUS_UPDATE(TERMINATION))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.start()
	
	EXPECT_ERROR("Tried to start invalid process")
	
	await Functions.wait(TIME_FOR_CLEAN_UP)
	
	EXPECT_TRUE(CALLED(TERMINATION))
	EXPECT_FALSE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(CALLED(START))
	EXPECT_TRUE(process == null)


func should_throw_error_and_terminate_freeing_resources_when_started_without_kill_observers():	
	var process: Process = get_base_process(invalid_callable)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_TRUE(process != null)
	
	process.terminating.connect(CALL_STATUS_UPDATE(TERMINATION))
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.start()
	
	EXPECT_ERROR("Tried to start invalid process")
	
	await Functions.wait(TIME_FOR_CLEAN_UP)
	
	EXPECT_TRUE(CALLED(TERMINATION))
	EXPECT_FALSE(CALLED(START))
	EXPECT_TRUE(process == null)


func should_throw_error_and_die_freeing_resources_when_started():
	var process: Process = get_base_process(invalid_callable)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_TRUE(process != null)
	
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.tree_exiting.connect(CALL_STATUS_UPDATE(FREE_RESOURCES))
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.start()
	
	EXPECT_ERROR("Tried to start invalid process")
	
	await Functions.wait(TIME_FOR_CLEAN_UP)
	
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_TRUE(CALLED(FREE_RESOURCES))
	EXPECT_FALSE(CALLED(START))
	EXPECT_EQ(process, null)


func should_restart_when_called_active_with_flag():
	const FORCE_RESTART: bool = true
	
	var process: Process = get_base_process()
	
	process.start()
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.stopped.connect(CALL_STATUS_UPDATE(STOP))
	process.restarted.connect(CALL_STATUS_UPDATE(RESTART))
	
	EXPECT_FALSE(CALLED(START))
	
	process.start(FORCE_RESTART)
	
	EXPECT_TRUE(CALLED(START))
	EXPECT_TRUE(CALLED(STOP))
	EXPECT_TRUE(CALLED(RESTART))


func should_call_initialization_and_activate():
	var process: ProcessStub = get_stubbed_process(valid_signal)
	
	process.initialization_called.connect(CALL_STATUS_UPDATE(INITIALIZATION))
	process.start()
	
	EXPECT_TRUE(CALLED(INITIALIZATION))
	EXPECT_TRUE(process.is_active())


func should_fail_initialization_and_die():
	var process: ProcessStub = get_stubbed_process(valid_signal)
	
	process.initialization_called.connect(CALL_STATUS_UPDATE(INITIALIZATION))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.set_one_status_return(false)
	process.start()
	
	EXPECT_TRUE(CALLED(INITIALIZATION))
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_active())
	EXPECT_ERROR("Initialization failed")


func should_start_timer_limiter():
	var process: Process = get_base_process()
	var limiter: Limiter = Limiter.new(Update.MIN_TIME_BETWEEN_UPDATES)
	
	process.set_limit(limiter)
	
	EXPECT_FALSE(limiter.is_active())
	
	process.start()
	
	EXPECT_TRUE(limiter.is_active())

