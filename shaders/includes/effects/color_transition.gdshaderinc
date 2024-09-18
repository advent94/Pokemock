#ifndef TRANSITION
#define TRANSITION

#include "res://shaders/includes/colors.gdshaderinc"

uniform bool transition_active = false;
uniform vec4 transition_color: source_color = BLACK;
uniform float transition_modifier: hint_range(0.0, 1.0, 0.1) = 0.0;
uniform bool transition_affects_transparency = false;

vec4 get_color_between(vec4 from, vec4 to, float modifier, bool affects_transparent) {
	modifier = clamp(modifier, 0.0, 1.0);
	vec4 transform = (to.rgba - from.rgba) * modifier;
	return vec4((from.rgb + transform.rgb), from.a + (transform.a * float(affects_transparent)));
}

#endif // TRANSITION