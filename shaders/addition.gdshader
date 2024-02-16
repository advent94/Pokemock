shader_type canvas_item;

uniform float modifier;

void fragment() {
    COLOR.rgb = clamp(COLOR.rgb + modifier, vec3(0.0), vec3(1.0));
}