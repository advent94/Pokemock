#ifndef COLOR_CHANGE
#define COLOR_CHANGE

#include "res://shaders/includes/colors.gdshaderinc"

uniform bool change_active = false;
uniform vec4 change_color: source_color;
uniform bool change_affects_transparency = false;

#endif // COLOR_CHANGE