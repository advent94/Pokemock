extends ProcessTest

func should_execute_properly():
	var process: Process = get_base_process()
	
	process.setup(valid_callable)
	process.start()
	
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(process.is_valid())
	
	process.stopped.connect(CALL_STATUS_UPDATE(STOP))
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.restarted.connect(CALL_STATUS_UPDATE(RESTART))
	process.restart()
	
	EXPECT_TRUE(CALLED(STOP))
	EXPECT_TRUE(CALLED(START))
	EXPECT_TRUE(CALLED(RESTART))
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(process.is_valid())


func should_ignore_when_invalid():
	var process: Process = get_base_process()
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())

	process.restarted.connect(CALL_STATUS_UPDATE(RESTART))
	
	process.restart()
	
	EXPECT_FALSE(CALLED(RESTART))


func should_execute_with_call_between():
	var process: Process = get_base_process()
	var call_order: Array[int] = []
	var report_call: Callable = func(order: int): call_order.push_back(order)
	var call_between: Callable = func(): valid_signal.emit()
	
	process.setup(valid_callable)
	process.start()
	
	process.stopped.connect(CALL_STATUS_UPDATE(STOP))
	process.stopped.connect(report_call.bind(STOP))
	valid_signal.connect(CALL_STATUS_UPDATE(CALL_BETWEEN))
	valid_signal.connect(report_call.bind(CALL_BETWEEN))
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.started.connect(report_call.bind(START))
	process.restarted.connect(CALL_STATUS_UPDATE(RESTART))
	process.restarted.connect(report_call.bind(RESTART))
	
	process.restart(call_between)
	
	EXPECT_TRUE(CALLED(STOP))
	EXPECT_TRUE(CALLED(START))
	EXPECT_TRUE(CALLED(RESTART))
	EXPECT_TRUE(CALLED(CALL_BETWEEN))
	EXPECT_EQ(call_order, EXPECTED_RESTART_CALL_ORDER)


func should_fail_to_stop():
	var process: ProcessStub = get_stubbed_process(null)
	var call_between: Callable = func(): valid_signal.emit()
	
	process.start()

	process.terminating.connect(CALL_STATUS_UPDATE(TERMINATION))	
	process.stopped.connect(CALL_STATUS_UPDATE(STOP))
	valid_signal.connect(CALL_STATUS_UPDATE(CALL_BETWEEN))
	process.started.connect(CALL_STATUS_UPDATE(START))
	process.restarted.connect(CALL_STATUS_UPDATE(RESTART))
	
	process.set_one_status_return(false)
	process.restart(call_between)
	
	EXPECT_TRUE(CALLED(TERMINATION))
	EXPECT_FALSE(CALLED(STOP))
	EXPECT_FALSE(CALLED(START))
	EXPECT_FALSE(CALLED(RESTART))
	EXPECT_FALSE(CALLED(CALL_BETWEEN))
	EXPECT_ERROR("Stop failed")


func should_restart_and_use_new_initialization():
	var process: Process = get_base_process()
	var initialization: Callable = func(): valid_signal.emit()
	
	process.setup(valid_callable)
	process.start()
	
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(process.is_valid())
	
	process.restarted.connect(CALL_STATUS_UPDATE(RESTART))
	valid_signal.connect(CALL_STATUS_UPDATE(CALL_BETWEEN))
	
	process.set_initialization(initialization, true)
	
	EXPECT_TRUE(CALLED(CALL_BETWEEN))
	EXPECT_TRUE(CALLED(RESTART))


func should_restart_and_use_new_update():
	var process: Process = get_base_process()
	
	process.setup(valid_callable, valid_signal)
	process.start()
	
	EXPECT_TRUE(process.is_active())
	EXPECT_TRUE(process.is_valid())
	
	process.restarted.connect(CALL_STATUS_UPDATE(RESTART))
	
	process.set_update(valid_signal_with_modifier)
	
	EXPECT_TRUE(CALLED(RESTART))
	EXPECT_EQ(valid_signal_with_modifier, process.update.get_value())
