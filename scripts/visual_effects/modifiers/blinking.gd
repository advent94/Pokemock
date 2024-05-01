extends Modifier
class_name BlinkingModifier

var value: bool

func _init(val: bool):
	_type = VisualEffect.Type.BLINKING
	value = val
