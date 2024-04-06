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

const OPAQUE: float = 1.0

static func get_unique_colors(color_array: Array[Color], remove_transparent: bool = true) -> Array[Color]:
	var unique_colors: Array[Color] = []
	for color in color_array:
		if remove_transparent && not is_equal_approx(color.a, OPAQUE):
			continue
		if not unique_colors.has(color):
			unique_colors.push_back(color)
	return unique_colors

enum Sort { ASCENDING, DESCENDING }

const COLOR_SORT_INDEX: Dictionary = {
	Sort.ASCENDING: "_sort_ascending_by_luminance",
	Sort.DESCENDING: "_sort_descending_by_luminance"
}

static func _sort_ascending_by_luminance(a: Color, b: Color):
	if a.get_luminance() < b.get_luminance():
		return true
	return false

static func _sort_descending_by_luminance(a: Color, b: Color):
	if a.get_luminance() > b.get_luminance():
		return true
	return false

static func sort_colors(color_array: Array[Color], sort: Sort) -> Array[Color]:
	color_array.sort_custom(Callable(Graphics, COLOR_SORT_INDEX[sort]))
	return color_array

const MAX_LUMINANCE: float = 1.0

## Finds corresponding color to it's own luminance
static func get_color_by_luminance(color: Color, colors_sorted_by_luminance: Array[Color], sort: Sort = Sort.ASCENDING) -> Color:
	if colors_sorted_by_luminance.is_empty():
		return color
	var mod: float = color.get_luminance()
	# Basically, we reverse mod by subtracting it's max value from it's current value
	if sort == Sort.DESCENDING:
		mod = MAX_LUMINANCE - color.get_luminance()
	return colors_sorted_by_luminance[(colors_sorted_by_luminance.size() - 1) * mod]

## Limits color count based on existing array of colors and number you want to limit it by
## Color limit consists of the brightest color, darkest and [count - 2] colors between
static func get_limited_color_array(color_array: Array[Color], count: int) -> Array[Color]:
	assert(count >= 1, "Color count can't be zero or negative.")
	
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
