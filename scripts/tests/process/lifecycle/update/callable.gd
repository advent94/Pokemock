extends ProcessTest

# NOTE/TODO: Mockowanie? W tym przypadku mockiem byłby Update, a raczej jego konstruktory/gety.
# Żeby Zamockować trzeba użyć albo podmiany skryptu albo parametru. Mock powinien być tylko na
# potrzeby testu. Problem jest taki, że GDScript nie obsługuje wielokrotnego dziedziczenia.
# W związku z tym dziedziczyć będziemy po konkretnej klasie, a mock będzie wstrzykiwać reszte. 
# var update = MOCK(Update)
# ON_CALL(update, "method").RETURN(something).TIMES(10)
# EXPECT_CALL(update, "method").TIMES(10)
# exception - update is not a mock, method doesn't exist, return type is invalid(???)

#                 o update succeeds:
#                     o next update
#                     o interval is 0.0, finish()
#                 o update fails - death

func should_finish_after_receiving_null_data():
	var process: Process = get_base_process()
	var return_null: Callable = func(_step): return null
	
	process.setup(valid_callable, return_null)
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.finished.connect(CALL_STATUS_UPDATE(FINISH))
	process.start()
	
	EXPECT_TRUE(CALLED(FINISH))
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(process.is_valid())	
	EXPECT_FALSE(process.is_active())


func should_die_after_receiving_different_data_type():
	const UNSUPPORTED_DATA_TYPE: int = -1
	
	var process: Process = get_base_process()
	var return_unsupported: Callable = func(_step): return UNSUPPORTED_DATA_TYPE
	
	process.setup(valid_callable, return_unsupported)
	
	start_and_expect_dead_process_after_invalid_update(process)


func should_die_after_receiving_unsupported_data():
	var unsupported_update: Update = Update.new(VALID_SHORT_INTERVAL_ARRAY) 
	
	var process: Process = get_base_process()
	var return_unsupported: Callable = func(_step): return unsupported_update
	
	process.setup(valid_callable, return_unsupported)
	
	start_and_expect_dead_process_after_invalid_update(process)


func should_die_after_receiving_corrupted_data_without_modifier():
	var update_data_without_modifier: Update = Update.new([SHORT_INTERVAL, Modifier.new()]) 	
	var return_data_without_modifier: Callable = func(_step) -> Update: return update_data_without_modifier
	var process: Process = get_base_process()
	
	update_data_without_modifier._value.erase(Update.MODIFIER_KEY)
	process.setup(valid_callable, return_data_without_modifier)
	
	start_and_expect_dead_process_after_invalid_update(process)


func should_die_after_receiving_corrupted_data_without_interval():
	var update_data_without_interval: Update = Update.new([SHORT_INTERVAL, Modifier.new()]) 	
	var return_data_without_interval: Callable = func(_step) -> Update: return update_data_without_interval
	var process: Process = get_base_process()
	
	update_data_without_interval._value.erase(Update.INTERVAL_KEY)
	process.setup(valid_callable, return_data_without_interval)
	
	start_and_expect_dead_process_after_invalid_update(process)


func should_succeed_after_interval_correction():
	var update_data_with_invalid_interval: Update = Update.new([INVALID_INTERVAL, Modifier.new()]) 	
	var return_data_with_invalid_interval: Callable = func(_step) -> Update: return update_data_with_invalid_interval
	var process: Process = get_stubbed_process(return_data_with_invalid_interval)
	
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.start()

	await Functions.wait(Constants.MIN_TIME_BETWEEN_UPDATES)
	
	EXPECT_TRUE(CALLED(UPDATE))
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())


func should_schedule_new_update():
	var update_data: Update = Update.new([VERY_LONG_TIME, Modifier.new()]) 	
	var return_data: Callable = func(_step) -> Update: return update_data
	var process: Process = get_stubbed_process(return_data)
	
	EXPECT_EQ(process.update.timer, null)
	
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.finished.connect(CALL_STATUS_UPDATE(FINISH))
	process.start()
	
	await Functions.wait(Constants.MIN_TIME_BETWEEN_UPDATES)
	
	EXPECT_TRUE(process.update.timer.time_left > 0 && process.update.timer.time_left < VERY_LONG_TIME)
	
	EXPECT_FALSE(CALLED(FINISH))
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())


func should_schedule_second_update_after_first():
	var update_data: Update = Update.new([SHORT_INTERVAL, Modifier.new()]) 	
	var return_data: Callable = func(_step) -> Update: return update_data
	var process: Process = get_stubbed_process(return_data)
	
	process.start()
	
	await process.updated
	EXPECT_TRUE(process.update.timer.is_stopped())
	
	await Functions.wait(SHORT_INTERVAL)
	
	EXPECT_FALSE(process.update.timer.is_stopped())
	
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())


func should_die_after_first_interval_as_update_gets_corrupted():
	var update_data: Update = Update.new([SHORT_INTERVAL, Modifier.new()]) 	
	var return_data: Callable = func(_step) -> Update: return update_data
	var process: Process = get_stubbed_process(return_data)
	
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	
	await process.updated
	await Functions.wait(SHORT_INTERVAL/2)
	
	process.update = null
	
	await Functions.wait(SHORT_INTERVAL)
	
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())


func should_update_second_time():
	var update_data: Update = Update.new([SHORT_INTERVAL, Modifier.new()]) 	
	var return_data: Callable = func(_step) -> Update: return update_data
	var process: Process = get_stubbed_process(return_data)
	
	process.start()
	
	await process.updated
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	
	await Functions.wait(SHORT_INTERVAL * 2)
	
	EXPECT_TRUE(CALLED(UPDATE))
	EXPECT_TRUE(process.is_valid())
	EXPECT_TRUE(process.is_active())


func should_update_once_and_finish():
	var update_data: Update = Update.new([SHORT_INTERVAL, Modifier.new()])
	var return_data: Callable = func(_step) -> Update: 
		if _step == Process.INITIALIZATION || _step == Process.FIRST_STEP:
			return update_data
		return null
	var process: Process = get_stubbed_process(return_data)
	
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.finished.connect(CALL_STATUS_UPDATE(FINISH))
	
	process.start()
	
	await process.updated
	await process.finished
	
	EXPECT_TRUE(CALLED(UPDATE))
	EXPECT_TRUE(CALLED(FINISH))
	EXPECT_TRUE(process.is_valid())
	EXPECT_FALSE(process.is_active())

func should_die_after_inner_update_fails():
	var update_data: Update = Update.new([SHORT_INTERVAL, Modifier.new()]) 	
	var return_data: Callable = func(_step) -> Update: return update_data
	var process: Process = get_stubbed_process(return_data)
	
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.updated.connect(CALL_STATUS_UPDATE(UPDATE))
	process.start()
	process.set_one_status_return(false)
	
	await process.killed
	
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(CALLED(UPDATE))
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())
