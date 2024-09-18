#ifndef GRAYSCALE_INCLUDE
#define GRAYSCALE_INCLUDE

#include "utils.gdshaderinc"

#define LUMINANCE 0
#define AVG 1
#define LUMA_PAL 2
#define LUMA_HDTV 3
#define LUMA_HDR 4

vec4 luminance_grayscale(vec4 color) {
	return vec4(vec3(max_in_v3(color.rgb)), color.a);	
}

vec4 avg_grayscale(vec4 color) {
	return vec4(vec3((color.r + color.g + color.b)/3.0), color.a);
}

vec4 luma_grayscale(vec4 color, uint type) {
	vec3 transform;
	switch (type) {
		case LUMA_PAL: {
			transform = LUMA_PAL_NTSC_TRANSFORM;
			break;
		}
		case LUMA_HDTV: {
			transform = LUMA_HDTV_TRANSFORM;
			break;
		}
		case LUMA_HDR: {
			transform = LUMA_HDR_TRANSFORM;
			break;
		}
	}
	float new_shade = (color.r * transform.r) + (color.g * transform.g) + (color.b * transform.b);
	return vec4(vec3(new_shade), color.a);
}

vec4 grayscale(vec4 color, uint type) {
	switch (type) {
		case LUMINANCE:
			return luminance_grayscale(color);
		case AVG:
			return avg_grayscale(color);
		case LUMA_HDR:
		case LUMA_HDTV:
		case LUMA_PAL:
			return luma_grayscale(color, type);
		default:
			return luma_grayscale(color, LUMA_HDTV);
	}
}

#endif // GRAYSCALE_INCLUDE