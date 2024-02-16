extends Sprite2D

var blinking = false
var _original_color: Color = Color(0.376, 0.376, 0.376, 1.0)
var _is_transparent: bool = false

const SHADER_COLOR_PARAMETER: String = "color"

func _on_blinking_timer_timeout():
	if blinking:
		_blink()

func _blink():
	_is_transparent = not _is_transparent
	_change_shader_color()

const TRANSPARENT_COLOR: Color = Color(1, 1, 1, 1)

func _change_shader_color():
	var color: Color
	if _is_transparent:
		color = TRANSPARENT_COLOR
	else:
		color = _original_color
	material.set_shader_parameter(SHADER_COLOR_PARAMETER, color)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
