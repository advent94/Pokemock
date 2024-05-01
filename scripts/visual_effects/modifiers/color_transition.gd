extends Modifier
class_name ColorTransitionModifier

const MIN_COLOR_VALUE: float = 0.0
const MAX_COLOR_VALUE: float = 1.0

var value: float

func _init(val: float):
	_type = VisualEffect.Type.COLOR_TRANSITION
	value = clampf(val, MIN_COLOR_VALUE, MAX_COLOR_VALUE)
