#ifndef LUMINOSITY
#define LUMINOSITY

#include "res://shaders/includes/constants.gdshaderinc"

uniform bool luminosity_adjustment = false;
uniform float luminosity_modifier = 0.0;

// var: "lum_mod"
// Description: "adjective between -1.0 and 1.0"

vec4 get_color_with_adjusted_luminosity(vec4 color, float lum_mod)
{
	vec3 color_mod = vec3(0.0);
	bool is_grayscale = color.r == color.g && color.g == color.b;
	// This uses math to remove conditional for faster/more optimal shader processing
	// is_grayscale will equal to 0.0 or 1.0. If we deal with grayscale, we don't want to use PAL/NTSC
	// transform. Otherwise we multiply 1.0 by inverse of luma transform and we get absolute value
	// from subtraction which is reinversing our transform.
	color_mod = abs((float(!is_grayscale) * (1.0 - LUMA_PAL_NTSC_TRANSFORM)) - 1.0) * clamp(lum_mod, -1.0, 1.0);
	return vec4 (clamp(color.rgb + color_mod, vec3(0.0), vec3(1.0)), color.a);
}

#endif // LUMINOSITY