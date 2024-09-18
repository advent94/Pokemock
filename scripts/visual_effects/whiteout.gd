class_name Whiteout extends ColorTransition

const TIME_BETWEEN_UPDATES: float = 0.20
const TOTAL_EFFECT_TIME: float = 1.0

func _init() -> void:
	super._init(Update.new([TOTAL_EFFECT_TIME, TIME_BETWEEN_UPDATES]), Color.WHITE, false, true, true)
