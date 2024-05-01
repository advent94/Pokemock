#ifndef UTILS
#define UTILS

#include "constants.gdshaderinc"
#include "colors.gdshaderinc"

#define MAX_COLORS_COUNT 255
#define ERROR_COLOR RED

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform int color_array_size = 0;
uniform vec4 color_array[MAX_COLORS_COUNT];
uniform float color_transform[MAX_COLORS_COUNT];
uniform int luminosity_adjustment = 0;
uniform int color_swap = 0;
uniform float luminosity_modifier = 0.0;

bool floats_eq(float a, float b) {
	return abs(a - b) <= EPSILON;
}

bool is_color_transparent(vec4 color) {
	return floats_eq(color.a, 0.0);
}

float max_in_v3(vec3 color) {
	return max(max(color.r, color.g), color.b);
}

bool are_v2_equal(vec2 v1, vec2 v2) {
	bvec2 result = equal(v1, v2);
	return result.x && result.y;
}

bool are_colors_equal(vec4 v1, vec4 v2) {
	bvec4 result = equal(v1, v2);
	return result.r && result.g && result.b && result.a;
}

bool is_color_array_size_valid() {
	return !(color_array_size < 1 || color_array_size > MAX_COLORS_COUNT);
}

int get_color_index(vec4 color, vec4 array[MAX_COLORS_COUNT]) {
	if (!is_color_array_size_valid()) {
		return FAILURE;
	}
	
	// @NOTE: Can optimize sorting if necessary
	for(int i = 0; i < color_array_size; ++i) {
		if (color == array[i]) {
			return i;
		}
	}
	
	return FAILURE;
}

bool is_color_in_array(vec4 color, vec4 array[MAX_COLORS_COUNT]) {
	return get_color_index(color, array) != FAILURE;
}

vec4 get_color_with_adjusted_luminosity(vec4 color, float lum_mod) {
	lum_mod = clamp(lum_mod, -1.0, 1.0);
	return vec4(clamp(color.rgb + lum_mod, vec3(0.0), vec3(1.0)), color.a);
}

vec4 get_swapped_color(vec4 color, vec4 array[MAX_COLORS_COUNT], float transform[MAX_COLORS_COUNT]) {
	int index = get_color_index(color, color_array);
	
	if (index == FAILURE) {
		return ERROR_COLOR;
	}
	
	index = clamp(index += int(transform[index]), 0, color_array_size - ZERO_INDEXING_OFFSET);
	return color_array[index];
}

vec4 get_color_between(vec4 from, vec4 to, float modifier, bool affects_transparent) {
	modifier = clamp(modifier, 0.0, 1.0);
	vec4 transform = (to.rgba - from.rgba) * modifier;
	return vec4((from.rgb + transform.rgb), from.a + (transform.a * float(affects_transparent)));
}

vec4 get_new_color(vec4 old_color, vec4 new_color, bool affects_transparent) {
	if (affects_transparent) {
		return new_color;
	} else {
		return vec4((new_color.rgb), old_color.a);
	}
}

#endif // UTILS