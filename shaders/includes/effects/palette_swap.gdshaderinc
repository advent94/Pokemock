#ifndef PALETTE_SWAP
#define PALETTE_SWAP

#include "res://shaders/includes/utils.gdshaderinc"

uniform int palette_swap_index[MAX_INT_ARRAY_SIZE];
uniform vec4 palette_swap_colors[MAX_COLOR_PALETTE_SIZE];
uniform bool palette_swap_use_index = false;
uniform bool palette_swap_use_colors = false;
uniform bool palette_swap_affects_transparent = false;

vec4 get_swapped_color(vec4 color) {
	int index = get_color_index(color, original_color_palette, original_color_palette_size);
	
	if (index == FAILURE) {
		return ERROR_COLOR;
	}
	
	return palette_swap_colors[index];
}

vec4 get_swapped_color_by_index(vec4 color) {
	int index = get_color_index(color, original_color_palette, original_color_palette_size);
	
	if (index == FAILURE) {
		return ERROR_COLOR;
	}
	
	index = palette_swap_index[index];
	
	if (is_index_valid(index, original_color_palette_size)) {
		return original_color_palette[index];
	}
	
	return ERROR_COLOR;
}

#endif // PALETTE_SWAP