extends ProcessTest

## Resumes update timer, limiter and calls interal resume method to resume the process.[br]
## Does nothing when called from invalid process.
#func resume():
	#if should_resume():
		#if limiter != null:
			#limiter.resume()
		#
		#if update != null && update.timer != null:
			#update.timer.resume()
		#
		#var resume_result = _resume()
		#
		#if resume_result != null && resume_result is bool && resume_result == false:
			#return _handle_error("Resume failed! Killing %s \"%s\"." % [get_identity(), get_type_str()])
		#
		#_flags &= ~Flags.PAUSED
		#resumed.emit()

func should_execute_correctly():
	var process: Process = get_base_process()
	
	process.start()
	process.pause()
	
	EXPECT_TRUE(process.is_paused())
	
	process.resumed.connect(CALL_STATUS_UPDATE(RESUME))
	process.resume()
	
	EXPECT_TRUE(CALLED(RESUME))
	EXPECT_FALSE(process.is_paused())
	EXPECT_TRUE(process.is_active())


func should_ignore_when_invalid():
	var process: Process = get_base_process(invalid_callable)
	
	EXPECT_FALSE(process.is_valid())
	EXPECT_FALSE(process.is_active())

	process.resumed.connect(CALL_STATUS_UPDATE(RESUME))
	
	process.resume()
	
	EXPECT_FALSE(CALLED(RESUME))


func should_ignore_when_valid_not_active():
	var process: Process = get_base_process()
	
	EXPECT_TRUE(process.is_valid())
	EXPECT_FALSE(process.is_active())

	process.resumed.connect(CALL_STATUS_UPDATE(RESUME))
	
	process.resume()
	
	EXPECT_FALSE(CALLED(RESUME))
	EXPECT_FALSE(process.is_active())


func should_ignore_when_active_not_paused():
	var process: Process = get_base_process()
	
	process.start()
	
	EXPECT_FALSE(process.is_paused())
	
	process.resumed.connect(CALL_STATUS_UPDATE(RESUME))
	process.resume()
	
	EXPECT_FALSE(CALLED(RESUME))
	EXPECT_TRUE(process.is_active())


func should_resume_time_limit():
	var process: Process = get_base_process()
	var limiter: Limiter = Limiter.new(LimiterTest.VALID_TIME_LIMIT, process)
	
	process.set_limit(limiter)
	process.start()
	process.pause()
	
	EXPECT_FALSE(limiter.is_active())
	EXPECT_TRUE(limiter.is_paused())
	
	var value_before_resume: float = limiter.left()
	
	process.resume()
	
	await Functions.wait(TIME_FOR_CLEAN_UP)
	
	EXPECT_FALSE(limiter.is_paused())
	EXPECT_TRUE(limiter.is_active())
	EXPECT_FLOAT_NEQ(value_before_resume, limiter.left())
	

func should_resume_pending_update():
	var process: Process = get_base_process(valid_callable, valid_signal)
	
	process.start()
	process.update.timer = AdvancedTimer.new(VERY_LONG_TIME)
	process.add_child(process.update.timer)
	process.update.timer.start()	
	process.pause()
	
	EXPECT_TRUE(process.update.timer.is_paused())
	
	process.resume()
	
	EXPECT_FALSE(process.update.timer.is_paused())


func should_enable_signal_update():
	var process: Process = get_stubbed_process(valid_signal_with_modifier)
	
	process.inner_update_called.connect(CALL_STATUS_UPDATE(INNER_UPDATE))
	process.start()
	process.pause()
	valid_signal_with_modifier.emit(Modifier.new())
	
	EXPECT_FALSE(CALLED(INNER_UPDATE))
	
	process.resume()
	valid_signal_with_modifier.emit(Modifier.new())
	
	EXPECT_TRUE(CALLED(INNER_UPDATE))


func should_call_inner_function_and_resume_running_process():
	var process: Process = get_stubbed_process(valid_signal)
	
	process.inner_resume_called.connect(CALL_STATUS_UPDATE(INNER_RESUME))
	process.start()
	process.pause()
	process.resume()
	
	EXPECT_TRUE(CALLED(INNER_RESUME))
	EXPECT_FALSE(process.is_paused())


func should_die_after_failing_inner_resume_function():
	var process: Process = get_stubbed_process(valid_signal)
	
	process.inner_resume_called.connect(CALL_STATUS_UPDATE(INNER_RESUME))
	process.killed.connect(CALL_STATUS_UPDATE(KILL_COMMAND))
	process.start()
	process.pause()
	process.set_one_status_return(false)
	process.resume()
	
	EXPECT_TRUE(CALLED(INNER_RESUME))
	EXPECT_TRUE(CALLED(KILL_COMMAND))
	EXPECT_FALSE(process.is_active())
	EXPECT_ERROR("Resume failed")
