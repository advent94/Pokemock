extends Test
class_name LimiterTest

signal valid_signal

const VALID_COUNTER_LIMIT: int = 2
const VALID_TIME_LIMIT: float = 1.0


func _global_timer_owner_clear_up():
	Timers.get_children()[Constants.FIRST_ELEMENT_IN_INDEX].queue_free()
	await Timers.get_children()[Constants.FIRST_ELEMENT_IN_INDEX].tree_exited
	
	EXPECT_TRUE(Timers.get_children().is_empty())
