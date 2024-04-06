extends LimiterTest

func should_properly_create_new_counter():
	var limiter: Limiter = Limiter.new(VALID_COUNTER_LIMIT)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.COUNTER)
	EXPECT_TRUE(limiter.get_limit() == VALID_COUNTER_LIMIT)


func should_throw_warning_and_correct_invalid_tick_value():
	const INVALID_TICK_VALUE: int = 0
	
	var limiter: Limiter = Limiter.new(INVALID_TICK_VALUE)
	
	EXPECT_EQ(limiter.get_limit(), Limiter.MIN_TICKS)


func should_increment_counter():
	var limiter: Limiter = Limiter.new(VALID_COUNTER_LIMIT)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.COUNTER)
	EXPECT_EQ(limiter.left(), VALID_COUNTER_LIMIT)
	
	limiter.increment()
	
	EXPECT_EQ(limiter.left(), VALID_COUNTER_LIMIT - Counter.INCREMENT_VALUE)


func should_restart_counter():
	var limiter: Limiter = Limiter.new(VALID_COUNTER_LIMIT)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.COUNTER)
	EXPECT_EQ(limiter.left(), VALID_COUNTER_LIMIT)
	
	limiter.increment()
	
	EXPECT_EQ(limiter.left(), VALID_COUNTER_LIMIT - Counter.INCREMENT_VALUE)
	
	limiter.reset()
	
	EXPECT_EQ(limiter.left(), VALID_COUNTER_LIMIT)


func should_call_registered_callable_after_counter_hits_limit():
	var limiter: Limiter = Limiter.new(VALID_COUNTER_LIMIT)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.COUNTER)
	
	limiter.add_observer(CALL_STATUS_UPDATE())
	
	for i in range(VALID_COUNTER_LIMIT):
		limiter.increment()
	
	EXPECT_TRUE(CALLED())


func should_not_call_unregistered_callable_after_counter_hits_limit():
	var limiter: Limiter = Limiter.new(VALID_COUNTER_LIMIT)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.COUNTER)
	
	limiter.add_observer(CALL_STATUS_UPDATE())
	limiter.remove_observer(CALL_STATUS_UPDATE())
	
	for i in range(VALID_COUNTER_LIMIT):
		limiter.increment()
	
	EXPECT_FALSE(CALLED())
