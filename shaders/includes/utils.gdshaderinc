#ifndef UTILS
#define UTILS

#include "constants.gdshaderinc"
#include "colors.gdshaderinc"

#define MAX_COLOR_PALETTE_SIZE 258
#define MAX_INT_ARRAY_SIZE 1028
#define ERROR_COLOR RED

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform int original_color_palette_size = 0;
uniform vec4 original_color_palette[MAX_COLOR_PALETTE_SIZE];

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

bool is_color_array_size_valid(int color_array_size) {
	return color_array_size >= 1 && color_array_size <= MAX_COLOR_PALETTE_SIZE;
}

bool is_index_valid(int index, int array_size) {
	return index >= 0 && index < array_size;
}

int get_color_index(vec4 color, vec4 array[MAX_COLOR_PALETTE_SIZE], int array_size) {
	if (!is_color_array_size_valid(array_size)) {
		return FAILURE;
	}
	
	// @NOTE: Can optimize search if necessary
	for(int i = 0; i < array_size; ++i) {
		if (are_colors_equal(color, array[i])) {
			return i;
		}
	}
	
	return FAILURE;
}

#endif // UTILS