#ifndef COLOR_CHANGE
#define COLOR_CHANGE

#include "res://shaders/includes/colors.gdshaderinc"

uniform bool change_active = false;
uniform vec4 change_color: source_color;
uniform bool change_affects_transparency = false;

vec4 get_new_color(vec4 old_color, vec4 new_color, bool affects_transparent) 
{
	return vec4((new_color.rgb), (float(affects_transparent) * new_color.a) + (float(!affects_transparent) * old_color.a));
}

#endif // COLOR_CHANGE