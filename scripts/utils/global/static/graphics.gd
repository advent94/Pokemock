class_name Graphics

static func get_pixel_array(img: Image) -> Array[Color]:
	var pixels: Array[Color] = []
	var x: int = 0
	var y: int = 0
	var img_width: int = img.get_width()
	var img_height: int = img.get_height()
	
	for i in range(0, img_width * img_height):
		x = i - ((Functions.safe_integer_division(i, img_width)) * img_width)
		y = Functions.safe_integer_division(i, img_width)
		pixels.push_back(img.get_pixel(x, y))
	
	return pixels


static func get_color_palette(img: Image, unique: bool = true, add_transparent: bool = false) -> Array[Color]:
	var palette: Array[Color] = []
	var x: int = 0
	var y: int = 0
	var color: Color
	var img_width: int = img.get_width()
	var img_height: int = img.get_height()
	
	for i in range(0, img_width * img_height):
		x = i - ((Functions.safe_integer_division(i, img_width)) * img_width)
		y = Functions.safe_integer_division(i, img_width)
		color = img.get_pixel(x, y)
		
		if (unique and palette.has(color)) or not add_transparent && is_transparent(color):
			pass
		else:
			palette.push_back(img.get_pixel(x, y))
	
	return palette

static func is_transparent(color: Color) -> bool:
	return not is_opaque(color)

static func is_opaque(color: Color) -> bool:
	const OPAQUE: float = 1.0
	return is_equal_approx(color.a, OPAQUE)


enum Sort { ASCENDING, DESCENDING }

const COLOR_SORT_INDEX: Dictionary = {
	Sort.ASCENDING: "_sort_ascending_by_luminance",
	Sort.DESCENDING: "_sort_descending_by_luminance"
}

static func _sort_ascending_by_luminance(a: Color, b: Color) -> bool:
	if a.get_luminance() != b.get_luminance():
		return a.get_luminance() < b.get_luminance()
	else:
		return _sort_by_color(a, b)


static func _sort_descending_by_luminance(a: Color, b: Color) -> bool:
	if a.get_luminance() != b.get_luminance():
		return a.get_luminance() > b.get_luminance()
	else:
		return _sort_by_color(a, b)


static func _sort_by_color(a: Color, b: Color) -> bool:
	if a.r != b.r:
		return a.r > b.r
		
	if a.g != b.g:
		return a.g > b.g
		
	if a.b != b.b:
		return a.b > b.b
		
	return a.a > b.a


static func sort_colors(color_array: Array[Color], sort: Sort) -> Array[Color]:
	color_array.sort_custom(Callable(Graphics, COLOR_SORT_INDEX[sort]))
	return color_array

const MAX_LUMINANCE: float = 1.0

## Limits color count based on existing array of colors and number you want to limit it by
## Color limit consists of the brightest color, darkest and [count - 2] colors between
static func get_limited_color_array(color_array: Array[Color], count: int) -> Array[Color]:
	Log.assertion(count >= 1, "Color count can't be zero or negative.")
	
	if count >= color_array.size():
		return color_array
	
	if count == 1:
		return [ color_array[0] ]

	var cut_color_array: Array[Color] = []
	var it_modifier: float = float(color_array.size()) / (count - 1)
	var iterator: float = 0.0

	while cut_color_array.size() < count - 1:
		cut_color_array.push_back(color_array[round(iterator)])
		iterator += it_modifier
	
	cut_color_array.push_back(color_array[color_array.size() - 1])
	
	return cut_color_array
