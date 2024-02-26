extends CounterTest

func should_start_with_value_set_to_zero():
	var counter = Counter.new()
	
	EXPECT_EQ(counter.get_value(), DEFAULT_STARTING_VALUE)


func should_increase_starting_value_by_one():
	var counter = Counter.new()
	
	EXPECT_EQ(counter.get_value(), DEFAULT_STARTING_VALUE)
	
	counter.increment()
	
	EXPECT_EQ(counter.get_value(), DEFAULT_STARTING_VALUE + 1)


func should_emit_increment_signal():
	var counter = Counter.new()
	counter.incremented.connect(CALL_STATUS_UPDATE())
	
	EXPECT_FALSE(CALLED())
	
	counter.increment()
	
	EXPECT_TRUE(CALLED())


func should_reach_limit_and_emit_finished_signal():
	var counter = Counter.new(ONE_DEFAULT_INCREMENT)
	
	counter.finished.connect(CALL_STATUS_UPDATE())
	
	EXPECT_FALSE(CALLED())
	
	counter.increment()
	EXPECT_TRUE(CALLED())


func should_not_be_able_to_increase_value_after_finished():
	const LIMIT: int = 1
	var counter = Counter.new(LIMIT)
	counter.increment()
	
	EXPECT_EQ(counter.get_value(), LIMIT)
	
	counter.increment()
	
	EXPECT_EQ(counter.get_value(), LIMIT)
