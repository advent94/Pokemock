shader_type canvas_item;

#include "res://shaders/includes/utils.gdshaderinc"
#include "res://shaders/includes/effects/blinking.gdshaderinc"
#include "res://shaders/includes/effects/color_change.gdshaderinc"
#include "res://shaders/includes/effects/color_transition.gdshaderinc"
#include "res://shaders/includes/effects/palette_swap.gdshaderinc"

void vertex() {
}

void fragment() {
	vec4 new_color = COLOR;
	
	if (blinking) {
		new_color = TRANSPARENCY;
	}
	else 
	{
		if (palette_swap_affects_transparent || (!palette_swap_affects_transparent && (floats_eq(1.0, new_color.a)))) {
			if (palette_swap_use_colors) {
				new_color = get_swapped_color(new_color);
			} 
			else if (palette_swap_use_index) {
				new_color = get_swapped_color_by_index(new_color);
			}
		}
		
		if (change_active) {
			new_color = get_new_color(new_color, change_color, change_affects_transparency);
		}
		if (transition_active) {
			new_color = get_color_between(new_color, transition_color, transition_modifier, transition_affects_transparency);
		}
	}
	COLOR = new_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
