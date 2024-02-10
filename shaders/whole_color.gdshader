shader_type canvas_item;

uniform vec4 star_color : source_color;

void fragment() {
	COLOR = texture(TEXTURE, UV);
  	COLOR.b = star_color.b;
	COLOR.g = star_color.g;
	COLOR.r = star_color.r;
}