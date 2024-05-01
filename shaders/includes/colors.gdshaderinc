#ifndef COLORS_INCLUDE
#define COLORS_INCLUDE

#define BLACK vec4(vec3(0.0), 1.0)
#define WHITE vec4(1.0)
#define ORANGE vec4(1.0, 0.75, 0.0, 1.0)
#define RED vec4(1.0, 0.0, 0.0, 1.0)
#define GREEN vec4(0.0, 1.0, 0.0, 1.0)
#define BLUE vec4(0.0, 0.0, 1.0, 1.0)
#define TRANSPARENCY vec4(1.0, 1.0, 1.0, 0.0)

vec4 color_from_rgba(int r, int g, int b, int a) {
	r = r >= 0 ? r % 256 : 0;
	g = g >= 0 ? g % 256 : 0;
	b = b >= 0 ? b % 256 : 0;
	a = a >= 0 ? a % 256 : 0;
	return vec4(float(r)/255.0, float(g)/255.0, float(b)/255.0, float(a)/255.0);
}

#endif // COLORS_INCLUDE