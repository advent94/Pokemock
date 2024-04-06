extends LimiterTest

func should_properly_create_new_timer():
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.TIMER)
	EXPECT_TRUE(limiter.get_limit() == VALID_TIME_LIMIT)
	EXPECT_TRUE(node.get_child(Constants.FIRST_ELEMENT_IN_INDEX) == limiter._value)


func should_throw_warning_and_correct_invalid_time_value():
	const INVALID_TIME_VALUE: float = 0.0
	
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(INVALID_TIME_VALUE, node)
	
	EXPECT_EQ(limiter.get_limit(), Limiter.MIN_TIMEOUT)


func should_initialize_with_existing_timer():
	var timer: Timer = CAPTURED_NODE(Timer.new())
	var limiter: Limiter = Limiter.new(timer)
	
	EXPECT_EQ(timer, limiter._value)


func should_throw_warning_and_add_timer_to_global_owner_when_limit_is_orphan_timer():
	var timer: Timer = Timer.new()
	var limiter: Limiter = Limiter.new(timer)
	
	EXPECT_EQ(timer, limiter._value)
	EXPECT_EQ(Timers.get_child(Constants.FIRST_ELEMENT_IN_INDEX), limiter._value)
	
	await _global_timer_owner_clear_up()


func should_warn_and_add_timer_to_global_owner_when_owner_is_null_for_float_limit():
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT)
	
	EXPECT_EQ(Timers.get_child(Constants.FIRST_ELEMENT_IN_INDEX), limiter._value)
	
	await _global_timer_owner_clear_up()


func should_warn_when_trying_to_set_new_limit_when_current_is_timer():
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_EQ(limiter.get_type(), Limiter.Type.TIMER)
	
	limiter.set_limit(VALID_TIME_LIMIT, node)


func should_start_timer():
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.TIMER)
	
	limiter.start()
	
	EXPECT_TRUE(limiter.is_active())


func should_pause_timer():
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.TIMER)
	
	limiter.start()
	
	EXPECT_TRUE(limiter.is_active())
	
	limiter.pause()
	
	EXPECT_FALSE(limiter.is_active())


func should_resume_timer():
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.TIMER)
	
	limiter.start()	
	limiter.pause()
	
	EXPECT_FALSE(limiter.is_active())
	
	limiter.resume()
	
	EXPECT_TRUE(limiter.is_active())	


func should_restart_timer():
	const DELAY: float = 0.05
	
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.TIMER)
	EXPECT_FLOAT_EQ(limiter.left(), VALID_TIME_LIMIT)
	
	limiter.start()
	
	EXPECT_TRUE(limiter.is_active())
	
	await Functions.wait(DELAY)

	EXPECT_TRUE(limiter.left() <= VALID_TIME_LIMIT - DELAY)
	
	limiter.reset()
	
	EXPECT_TRUE(limiter.is_active())
	EXPECT_FLOAT_EQ(limiter.left(), VALID_TIME_LIMIT)


func should_stop_timer():
	const DELAY: float = 0.05
	
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.TIMER)
	EXPECT_FLOAT_EQ(limiter.left(), VALID_TIME_LIMIT)
	
	limiter.start()
	
	EXPECT_TRUE(limiter.is_active())
	
	await Functions.wait(DELAY)

	EXPECT_TRUE(limiter.left() <= VALID_TIME_LIMIT - DELAY)
	
	limiter.stop()
	
	EXPECT_FALSE(limiter.is_active())
	EXPECT_FLOAT_EQ(limiter.left(), VALID_TIME_LIMIT)


func should_call_registered_callable_and_remove_timer_after_timeout():
	var node: Node = NODE()
	var limiter: Limiter = Limiter.new(VALID_TIME_LIMIT, node)
	
	EXPECT_TRUE(limiter.get_type() == Limiter.Type.TIMER)
	
	limiter.start()	
	limiter.add_observer(CALL_STATUS_UPDATE())
	await limiter._value.timeout
	await limiter._value.tree_exited
	
	EXPECT_TRUE(CALLED())
	EXPECT_TRUE(node.get_child_count() == 0)
