extends LimiterTest

func should_call_registered_callable_after_signal_emits():
	var limiter: Limiter = Limiter.new(valid_signal)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.SIGNAL)
	
	limiter.add_observer(CALL_STATUS_UPDATE())
	valid_signal.emit()

	EXPECT_TRUE(CALLED())
