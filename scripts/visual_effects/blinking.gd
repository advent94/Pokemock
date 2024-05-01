extends VisualEffect

class_name Blinking

const BLINKING : String = "blinking"
const STEPS: int = 2

var is_visible: bool = true

func _init(time_between: float, permanent: bool = false):
	_type = Type.BLINKING
	var two_step_update: Update = Update.new([time_between * STEPS, STEPS])
	super(func(): initialize_shader(), two_step_update, permanent)

func initialize_shader():
	owner.material.set_shader_parameter(BLINKING, is_visible)
	is_visible = not is_visible

func _update(modifier: Modifier):
	owner.material.set_shader_parameter(BLINKING, modifier.value)

func _get_default_modifier(_step: int, _step_count: int) -> Modifier:
	var modifier: Modifier = BlinkingModifier.new(is_visible)
	is_visible = not is_visible
	return modifier

func _stop():
	owner.material.set_shader_parameter(BLINKING, false)
	is_visible = true
