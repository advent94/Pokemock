#ifndef COLOR_LIMIT_INCLUDE
#define COLOR_LIMIT_INCLUDE

#include "utils.gdshaderinc"

const vec3 LUMA_HDTV_WEIGTHS = vec3(0.2126, 0.7152, 0.0722);

vec4 get_limited_grayscale_color(vec4 color, vec4 limited_array[MAX_COLOR_PALETTE_SIZE], int limited_array_size) {
	if (!is_color_array_size_valid(limited_array_size)) {
		return ERROR_COLOR;
	}
	float index_mod = float(original_color_palette_size - 1) * color.r;
	return limited_array[int(index_mod)];
}

vec4 get_limited_color(vec4 color, vec4 limited_array[MAX_COLOR_PALETTE_SIZE], int limited_array_size) {
	if (!is_color_array_size_valid(limited_array_size)) {
		return ERROR_COLOR;
	}
	return limited_array[(original_color_palette_size - ZERO_INDEXING_OFFSET) * int(color.r * LUMA_HDTV_WEIGTHS.r + color.g * LUMA_HDTV_WEIGTHS.g + color.b * LUMA_HDTV_WEIGTHS.b)];
}

#endif // COLOR_LIMIT_INCLUDE