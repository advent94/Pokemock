#ifndef TRANSITION
#define TRANSITION

#include "res://shaders/includes/colors.gdshaderinc"

uniform bool transition_active = false;
uniform vec4 transition_color: source_color = BLACK;
uniform float transition_modifier: hint_range(0.0, 1.0, 0.1) = 0.0;
uniform bool transition_affects_transparency = false;

#endif // TRANSITION