shader_type canvas_item;

uniform float whiteout_time_step = 0.0;
uniform float whiteout_added_color : hint_range(0.0, 1.0) = 0.01;

void fragment() {
    COLOR.rgb += whiteout_added_color * whiteout_time_step;
    COLOR.rgb = clamp(COLOR.rgb, vec3(0.0), vec3(1.0));
}