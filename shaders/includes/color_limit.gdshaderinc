#ifndef COLOR_LIMIT_INCLUDE
#define COLOR_LIMIT_INCLUDE

#include "utils.gdshaderinc"

const vec3 LUMA_HDTV_WEIGTHS = vec3(0.2126, 0.7152, 0.0722);

uniform int limited_colors_mode = 0;

#define COLOR_LIMIT_MODE_ADJUST 0
#define COLOR_LIMIT_MODE_SKIP 1

vec4 get_limited_grayscale_color(vec4 color, vec4 limited_array[MAX_COLORS_COUNT]) {
	if (!is_color_array_size_valid()) {
		return ERROR_COLOR;
	}
	float index_mod = float(color_array_size - 1) * color.r;
	return limited_array[int(index_mod)];
}

vec4 get_limited_color(vec4 color, vec4 limited_array[MAX_COLORS_COUNT]) {
	if (!is_color_array_size_valid()) {
		return ERROR_COLOR;
	}
	return limited_array[(color_array_size - ZERO_INDEXING_OFFSET) * int(color.r * LUMA_HDTV_WEIGTHS.r + color.g * LUMA_HDTV_WEIGTHS.g + color.b * LUMA_HDTV_WEIGTHS.b)];
}

#endif // COLOR_LIMIT_INCLUDE