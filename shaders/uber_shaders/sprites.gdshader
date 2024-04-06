shader_type canvas_item;

#include "res://shaders/includes/utils.gdshaderinc"
#include "res://shaders/includes/effects/fade.gdshaderinc"

void vertex() {
}

void fragment() {
	vec4 new_color = COLOR;
	if (fade_active) {
		new_color = get_color_between(new_color, fade_color, fade_modifier, fade_affects_transparency);
	}
	COLOR = new_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
