extends LimiterTest

func should_throw_error_and_be_invalid_for_null_limit():
	var limiter: Limiter = Limiter.new(null)
	
	EXPECT_FALSE(limiter.is_valid())
	EXPECT_EQ(limiter.get_type(), Limiter.Type.INVALID)
	EXPECT_ERROR("Limit is null")


func should_throw_error_and_be_invalid_for_unsupported_limit():
	var limiter: Limiter = Limiter.new(Vector2.LEFT)
	
	EXPECT_FALSE(limiter.is_valid())
	EXPECT_EQ(limiter.get_type(), Limiter.Type.INVALID)
	EXPECT_ERROR("Invalid limit")


func should_not_call_registered_callable():
	const NO_TIMEOUT: int = 0
	const NO_COUNTER_LIMIT_REACHED: int = 1
	const NO_SIGNAL_EMITTED: int = 2
	
	var node: Node = NODE()
	var counter_limiter: Limiter = Limiter.new(VALID_COUNTER_LIMIT)
	var signal_limiter: Limiter = Limiter.new(valid_signal)
	var time_limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(counter_limiter.get_type() == Limiter.Type.COUNTER)
	EXPECT_TRUE(signal_limiter.get_type() == Limiter.Type.SIGNAL)
	EXPECT_TRUE(time_limiter.get_type() == Limiter.Type.TIMER)
	
	time_limiter.add_observer(CALL_STATUS_UPDATE(NO_TIMEOUT))
	counter_limiter.add_observer(CALL_STATUS_UPDATE(NO_COUNTER_LIMIT_REACHED))
	signal_limiter.add_observer(CALL_STATUS_UPDATE(NO_SIGNAL_EMITTED))
	
	EXPECT_FALSE(CALLED(NO_TIMEOUT))
	EXPECT_FALSE(CALLED(NO_COUNTER_LIMIT_REACHED))
	EXPECT_FALSE(CALLED(NO_SIGNAL_EMITTED))
