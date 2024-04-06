extends Timer

class_name AdvancedTimer

func _init(seconds: float):
	if seconds < Constants.MIN_TIME_BETWEEN_UPDATES:
		push_warning("Time before update(%f) specified was too low. Changed to min value (%f)" % [seconds, Constants.MIN_TIME_BETWEEN_UPDATES])
		seconds = Constants.MIN_TIME_BETWEEN_UPDATES
	wait_time = seconds

func pause():
	paused = true

func resume():
	paused = false
