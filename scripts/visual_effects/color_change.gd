class_name ColorChange

extends VisualEffect

const NEW_COLOR: String = "change_color"
const CHANGE_AFFECTS_TRANSPARENCY: String = "change_affects_transparency"
const COLOR_CHANGE_ACTIVE: String = "change_active"

func _init(color: Color, affects_transparency: bool = false, permanent: bool = false):
	_type = Type.COLOR_CHANGE
	super(func(): initialize_shader(color, affects_transparency), null, permanent)

func initialize_shader(color: Color, affects_transparency: bool):
	swap_color(color, affects_transparency)
	owner.material.set_shader_parameter(COLOR_CHANGE_ACTIVE, true)

func swap_color(new_color: Color, affects_transparency: bool = false):
	owner.material.set_shader_parameter(NEW_COLOR, new_color)
	owner.material.set_shader_parameter(CHANGE_AFFECTS_TRANSPARENCY, affects_transparency)

func _stop():
	owner.material.set_shader_parameter(COLOR_CHANGE_ACTIVE, false)
