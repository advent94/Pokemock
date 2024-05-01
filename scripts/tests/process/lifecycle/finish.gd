extends ProcessTest

func should_not_execute_when_limiter_calls_if_invalid():
	var process: Process = get_base_process(invalid_callable)
	var limiter: Limiter = Limiter.new(CounterTest.ONE_DEFAULT_INCREMENT)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
	
	process.set_limit(limiter)
	process.finished.connect(CALL_STATUS_UPDATE(FINISH))
	limiter.increment()
	
	EXPECT_FALSE(CALLED(FINISH))
