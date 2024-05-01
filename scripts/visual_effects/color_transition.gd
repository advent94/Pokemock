class_name ColorTransition

extends VisualEffect

const COLOR_TRANSITION_ACTIVE: String = "transition_active"
const TRANSITION_COLOR: String = "transition_color"
const TRANSITION_MODIFIER: String = "transition_modifier"
const TRANSITION_AFFECTS_TRANSPARENCY: String = "transition_affects_transparency"

const DEFAULT_MOD: float = 0.0

func _init(update_args: Variant, color: Color = Color.WHITE, affects_transparency: bool = false, permanent: bool = false, keep_final: bool = false):
	_type = Type.COLOR_TRANSITION
	super(func(): initialize_shader(color, affects_transparency), update_args, permanent, keep_final)

func initialize_shader(color: Color, affects_transparency: bool) -> bool:
	owner.material.set_shader_parameter(TRANSITION_COLOR, color)
	owner.material.set_shader_parameter(TRANSITION_AFFECTS_TRANSPARENCY, affects_transparency)
	owner.material.set_shader_parameter(COLOR_TRANSITION_ACTIVE, true)
	return true

func _update(modifier: Modifier):
	owner.material.set_shader_parameter(TRANSITION_MODIFIER, modifier.value)

func _get_default_modifier(step: int, step_count: int) -> Modifier:
	return ColorTransitionModifier.new(float(step)/step_count)

func _stop():
	owner.material.set_shader_parameter(COLOR_TRANSITION_ACTIVE, false)
	owner.material.set_shader_parameter(TRANSITION_MODIFIER, ColorTransitionModifier.MIN_COLOR_VALUE)
