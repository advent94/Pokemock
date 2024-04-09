extends CounterTest

func should_have_default_counter_parameters():
	var counter: AdvancedCounter = AdvancedCounter.new()
	
	EXPECT_EQ(counter.get_value(), DEFAULT_STARTING_VALUE)
	EXPECT_EQ(counter.get_limit(), DEFAULT_LIMIT)
	EXPECT_EQ(counter.get_reverse_limit(), DEFAULT_R_LIMIT)
	EXPECT_EQ(counter.get_total_repetitions(), DEFAULT_REPETITIONS)
	EXPECT_EQ(counter.get_repetitions_left(), DEFAULT_REPETITIONS)
	EXPECT_EQ(counter.get_increment_value(), DEFAULT_INCREMENT_VALUE)
	EXPECT_EQ(counter.get_flags_str(), DEFAULT_FLAG_SETUP_STR)
		
	EXPECT_FALSE(counter.is_fast())
	EXPECT_FALSE(counter.is_reverse())
	EXPECT_FALSE(counter.can_be_negative())
	EXPECT_FALSE(counter.restarts_on_limit())
	EXPECT_TRUE(counter.is_strict())


func should_set_new_valid_r_limit():
	var counter: AdvancedCounter = AdvancedCounter.new()
	
	EXPECT_EQ(counter.get_reverse_limit(), DEFAULT_R_LIMIT)
	
	counter.set_r_limit(TESTED_VALID_NEGATIVE_R_LIMIT)
	
	EXPECT_EQ(counter.get_reverse_limit(), TESTED_VALID_NEGATIVE_R_LIMIT)


func should_force_min_possible_value_for_f_limit():
	var counter: AdvancedCounter = AdvancedCounter.new(
		DEFAULT_LIMIT, 
		DEFAULT_STARTING_VALUE, 
		R_LIMIT_EQUAL_TO_DEFAULT_LIMIT, 
		DEFAULT_REPETITIONS, 
		DEFAULT_INCREMENT_VALUE, 
		FLAGS_WITH_STRICT_UNSET
	)
	
	EXPECT_EQ(counter.get_reverse_limit(), Constants.MIN_INT)
	EXPECT_WARNING("Invalid limit")


func should_force_max_possible_value_for_f_limit():
	var counter: AdvancedCounter = AdvancedCounter.new(
		-DEFAULT_LIMIT, 
		DEFAULT_STARTING_VALUE, 
		-R_LIMIT_EQUAL_TO_DEFAULT_LIMIT, 
		DEFAULT_REPETITIONS, 
		DEFAULT_INCREMENT_VALUE, 
		FLAGS_WITH_STRICT_UNSET
	)
	
	EXPECT_EQ(counter.get_reverse_limit(), Constants.MAX_INT)
	EXPECT_WARNING("Invalid limit")


func should_force_negative_flag():
	var counter_with_neg_limit: AdvancedCounter = AdvancedCounter.new(NEGATIVE_VALUE)
	var counter_with_neg_starting_val: AdvancedCounter = AdvancedCounter.new(DEFAULT_LIMIT, NEGATIVE_VALUE)
	var counter_with_neg_r_limit: AdvancedCounter = AdvancedCounter.new(DEFAULT_LIMIT, DEFAULT_STARTING_VALUE, TESTED_VALID_NEGATIVE_R_LIMIT)
	
	EXPECT_TRUE(counter_with_neg_limit.can_be_negative())
	EXPECT_TRUE(counter_with_neg_starting_val.can_be_negative())
	EXPECT_TRUE(counter_with_neg_r_limit.can_be_negative())


func should_adapt_to_reverse_settings():
	var counter: AdvancedCounter = AdvancedCounter.new(NEGATIVE_VALUE)
	
	EXPECT_TRUE(counter.is_reverse())
	EXPECT_EQ(counter.get_increment_value(), -DEFAULT_INCREMENT_VALUE)

func should_set_new_increment_value():
	var counter: AdvancedCounter = AdvancedCounter.new()
	
	EXPECT_EQ(counter.get_increment_value(), DEFAULT_INCREMENT_VALUE)
	
	counter.set_increment_value(TESTED_NEW_INCREMENT_VALUE)
	
	EXPECT_EQ(counter.get_increment_value(), TESTED_NEW_INCREMENT_VALUE)


func should_set_reverse_new_increment_value():
	var counter: AdvancedCounter = AdvancedCounter.new(NEGATIVE_VALUE)
	
	EXPECT_EQ(counter.get_increment_value(), -DEFAULT_INCREMENT_VALUE)
	
	counter.set_increment_value(TESTED_NEW_INCREMENT_VALUE)
	
	EXPECT_EQ(counter.get_increment_value(), -TESTED_NEW_INCREMENT_VALUE)


func should_correctly_read_number_of_repetitions():
	var default_counter: AdvancedCounter = AdvancedCounter.new()
	var one_repetition_counter: AdvancedCounter = AdvancedCounter.new(
		ONE_DEFAULT_INCREMENT, 
		DEFAULT_STARTING_VALUE, 
		DEFAULT_R_LIMIT, 
		ONE_REPETITION
	)
	var advanced_repetition_counter: AdvancedCounter = AdvancedCounter.new(
		ONE_DEFAULT_INCREMENT, 
		DEFAULT_STARTING_VALUE, 
		DEFAULT_R_LIMIT, 
		TWO_REPETITIONS
	)
	
	advanced_repetition_counter.increment()
	
	EXPECT_EQ(default_counter.get_repetitions_left(), NO_REPETITIONS)
	EXPECT_EQ(one_repetition_counter.get_repetitions_left(), ONE_REPETITION)
	EXPECT_EQ(advanced_repetition_counter.get_repetitions_left(), ONE_REPETITION)


func should_call_after_repetition_and_update_repetitions_left():
	var counter: AdvancedCounter = AdvancedCounter.new(
		ONE_DEFAULT_INCREMENT, 
		DEFAULT_STARTING_VALUE, 
		DEFAULT_R_LIMIT, 
		TWO_REPETITIONS
	)
	
	counter.repetition_finished.connect(CALL_STATUS_UPDATE())
	
	EXPECT_EQ(counter.get_repetitions_left(), TWO_REPETITIONS)
	EXPECT_FALSE(CALLED())
	
	counter.increment()
	
	EXPECT_EQ(counter.get_repetitions_left(), ONE_REPETITION)
	EXPECT_TRUE(CALLED())


func should_handle_negative_number_of_set_repetitions():
	var counter: AdvancedCounter = get_non_strict_counter()
	
	counter.set_repetitions(NEGATIVE_VALUE)
	
	EXPECT_EQ(counter.get_repetitions_left(), NO_REPETITIONS)
	EXPECT_EQ(counter.get_total_repetitions(), NO_REPETITIONS)


func should_restart_repetitions_and_value():
	var counter: AdvancedCounter = AdvancedCounter.new(
		TWO_DEFAULT_INCREMENTS,
		DEFAULT_STARTING_VALUE,
		DEFAULT_R_LIMIT,
		TWO_REPETITIONS
	)
	for i in range(3):
		counter.increment()
	
	EXPECT_EQ(counter.get_repetitions_left(), ONE_REPETITION)
	EXPECT_EQ(counter.get_value(), DEFAULT_INCREMENT_VALUE)
	
	counter.restart()
	
	EXPECT_EQ(counter.get_repetitions_left(), TWO_REPETITIONS)
	EXPECT_EQ(counter.get_value(), DEFAULT_STARTING_VALUE)


func should_do_basic_incrementation():
	var counter: AdvancedCounter = AdvancedCounter.new(TWO_DEFAULT_INCREMENTS)
	
	EXPECT_EQ(counter.get_value(), DEFAULT_STARTING_VALUE)
	EXPECT_FALSE(CALLED())
	
	counter.incremented.connect(CALL_STATUS_UPDATE())
	counter.increment()
	
	EXPECT_EQ(counter.get_value(), DEFAULT_STARTING_VALUE + DEFAULT_INCREMENT_VALUE)
	EXPECT_TRUE(CALLED())


func should_increment_differently_for_fast_and_default_counter():
	var default_counter: AdvancedCounter = AdvancedCounter.new(ONE_DEFAULT_INCREMENT)
	var fast_counter: AdvancedCounter = get_fast_counter()
	
	EXPECT_TRUE(fast_counter.is_fast())
	
	default_counter.set_increment_value(TWO_DEFAULT_INCREMENTS)
	fast_counter.set_increment_value(TWO_DEFAULT_INCREMENTS)
	default_counter.increment()
	fast_counter.increment()
	
	EXPECT_EQ(default_counter.get_value(), ONE_DEFAULT_INCREMENT)
	EXPECT_EQ(fast_counter.get_value(), TWO_DEFAULT_INCREMENTS)
	
	
func should_handle_overflow_cases_for_non_fast_strict_counter():
	var positive_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(ONE_DEFAULT_INCREMENT)
	var negative_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(-ONE_DEFAULT_INCREMENT)
	var positive_r_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(
		-ONE_DEFAULT_INCREMENT,
		DEFAULT_STARTING_VALUE,
		ONE_DEFAULT_INCREMENT
	)		
	var negative_r_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(
		ONE_DEFAULT_INCREMENT,
		DEFAULT_STARTING_VALUE,
		-ONE_DEFAULT_INCREMENT
	)
	
	positive_limit_overflow_counter.set_increment_value(Constants.MAX_INT)
	positive_limit_overflow_counter.increment()
	negative_limit_overflow_counter.set_increment_value(Constants.MAX_INT)
	negative_limit_overflow_counter.increment()
	positive_r_limit_overflow_counter.set_increment_value(Constants.MAX_INT)
	positive_r_limit_overflow_counter.decrement()
	negative_r_limit_overflow_counter.set_increment_value(Constants.MAX_INT)
	negative_r_limit_overflow_counter.decrement()
		
	EXPECT_EQ(positive_limit_overflow_counter.get_value(), ONE_DEFAULT_INCREMENT)
	EXPECT_EQ(negative_limit_overflow_counter.get_value(), -ONE_DEFAULT_INCREMENT)
	EXPECT_EQ(positive_r_limit_overflow_counter.get_value(), ONE_DEFAULT_INCREMENT)
	EXPECT_EQ(negative_r_limit_overflow_counter.get_value(), -ONE_DEFAULT_INCREMENT)
	
	
func should_call_when_limit_or_reverse_limit_reached():
	var positive_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(ONE_DEFAULT_INCREMENT)
	var negative_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(-ONE_DEFAULT_INCREMENT)
	var positive_r_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(
		-ONE_DEFAULT_INCREMENT,
		DEFAULT_STARTING_VALUE,
		ONE_DEFAULT_INCREMENT
	)		
	var negative_r_limit_overflow_counter: AdvancedCounter = AdvancedCounter.new(
		ONE_DEFAULT_INCREMENT,
		DEFAULT_STARTING_VALUE,
		-ONE_DEFAULT_INCREMENT
	)
	
	positive_limit_overflow_counter.finished.connect(CALL_STATUS_UPDATE(POSITIVE_LIMIT_REACHED))
	negative_limit_overflow_counter.finished.connect(CALL_STATUS_UPDATE(NEGATIVE_LIMIT_REACHED))
	positive_r_limit_overflow_counter.reverse_limit_reached.connect(CALL_STATUS_UPDATE(POSITIVE_R_LIMIT_REACHED))
	negative_r_limit_overflow_counter.reverse_limit_reached.connect(CALL_STATUS_UPDATE(NEGATIVE_R_LIMIT_REACHED))
	
	positive_limit_overflow_counter.increment()
	negative_limit_overflow_counter.increment()
	positive_r_limit_overflow_counter.decrement()
	negative_r_limit_overflow_counter.decrement()
	
	EXPECT_TRUE(CALLED(POSITIVE_LIMIT_REACHED))
	EXPECT_TRUE(CALLED(NEGATIVE_LIMIT_REACHED))
	EXPECT_TRUE(CALLED(POSITIVE_R_LIMIT_REACHED))
	EXPECT_TRUE(CALLED(NEGATIVE_R_LIMIT_REACHED))


func should_not_call_finished_for_single_repetition():
	var counter: AdvancedCounter = AdvancedCounter.new(
		ONE_DEFAULT_INCREMENT, 
		DEFAULT_STARTING_VALUE, 
		DEFAULT_R_LIMIT, 
		TWO_REPETITIONS
	)
	
	EXPECT_EQ(counter.get_repetitions_left(), counter.get_total_repetitions())
	EXPECT_EQ(counter.get_repetitions_left(), TWO_REPETITIONS)
	EXPECT_FALSE(CALLED())
	
	counter.finished.connect(CALL_STATUS_UPDATE())
	counter.increment()
	
	EXPECT_EQ(counter.get_repetitions_left(), ONE_REPETITION)
	EXPECT_FALSE(CALLED())


func should_call_finished_after_all_repetitions():
	var counter: AdvancedCounter = AdvancedCounter.new(
		ONE_DEFAULT_INCREMENT, 
		DEFAULT_STARTING_VALUE, 
		DEFAULT_R_LIMIT, 
		TWO_REPETITIONS
	)
	
	EXPECT_EQ(counter.get_repetitions_left(), counter.get_total_repetitions())
	EXPECT_EQ(counter.get_repetitions_left(), TWO_REPETITIONS)
	EXPECT_FALSE(CALLED())
	
	counter.finished.connect(CALL_STATUS_UPDATE())
	for i in range(TWO_REPETITIONS):
		counter.increment()	
	
	EXPECT_TRUE(CALLED())
