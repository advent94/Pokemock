#ifndef FADE_VFX
#define FADE_VFX

#include "res://shaders/includes/colors.gdshaderinc"

uniform bool fade_active = false;
uniform vec4 fade_color: source_color = BLACK;
uniform float fade_modifier: hint_range(0.0, 1.0, 0.1) = 0.0;
uniform bool fade_affects_transparency = false;

#endif // FADE_VFX