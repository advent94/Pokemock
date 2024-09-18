class_name PaletteSwap extends VisualEffect

enum SwapType { UNINITIALIZED, INDEX, COLORS }

const ORIGINAL_COLOR_PALETTE: String = "original_color_palette"
const ORIGINAL_COLOR_PALETTE_SIZE: String = "original_color_palette_size"
const PALETTE_SWAP_INDEX: String = "palette_swap_index"
const PALETTE_SWAP_COLORS: String = "palette_swap_colors"
const PALETTE_SWAP_USE_INDEX: String = "palette_swap_use_index"
const PALETTE_SWAP_USE_COLORS: String = "palette_swap_use_colors"
const PALETTE_SWAP_AFFECTS_TRANSPARENT: String = "palette_swap_affects_transparent"

var original_palette: Array[Color]
var swap_type: SwapType = SwapType.UNINITIALIZED

func _init(update_args: Variant, init_swap: PaletteSwapModifier = null, palette: Array[Color] = [], transparent: bool = false, permanent: bool = false, keep_final: bool = false):
	_type = Type.PALETTE_SWAP
	super(func(): initialize_shader(palette, init_swap, transparent), update_args, permanent, keep_final)


func initialize_shader(palette: Array[Color], init_swap: PaletteSwapModifier, transparent: bool) -> bool:
	Log.assertion(owner is Sprite2D, "Owner is not Sprite2D and shouldn't use this effect!")
	Log.assertion(owner.texture != null, "Owner's texture can't be null!")
	
	owner.material.set_shader_parameter(PALETTE_SWAP_AFFECTS_TRANSPARENT, transparent)
	
	if palette.is_empty():
		original_palette = Graphics.get_color_palette(owner.texture.get_image(), true, transparent)
		original_palette.sort_custom(Callable(Graphics, Graphics.COLOR_SORT_INDEX[Graphics.Sort.ASCENDING]))
		owner.material.set_shader_parameter(ORIGINAL_COLOR_PALETTE, original_palette)
	else:
		original_palette = palette
		if owner.material.get_shader_parameter(ORIGINAL_COLOR_PALETTE) != original_palette:
			owner.material.set_shader_parameter(ORIGINAL_COLOR_PALETTE, original_palette)
	
	_reset_shader_parameters()
	
	if init_swap != null:
		_update(init_swap)
	
	return true


func _reset_shader_parameters() -> void:
	owner.material.set_shader_parameter(PALETTE_SWAP_INDEX, _get_default_swap_index())
	owner.material.set_shader_parameter(ORIGINAL_COLOR_PALETTE_SIZE, original_palette.size())
	owner.material.set_shader_parameter(PALETTE_SWAP_USE_INDEX, false)
	owner.material.set_shader_parameter(PALETTE_SWAP_USE_COLORS, false)


func _get_default_swap_index() -> Array[int]:
	var default_index: Array[int] = []
	
	default_index.resize(original_palette.size())
	for i in range(original_palette.size()):
		default_index[i] = i
	
	return default_index


func _update(modifier: Modifier):
	Log.assertion(modifier.value[PaletteSwapModifier.ARRAY_INDEX].size() == original_palette.size(), 
		"Size of array should be same as size of unique colors")

	match modifier.value[PaletteSwapModifier.TYPE_INDEX]:
		SwapType.INDEX:
			owner.material.set_shader_parameter(PALETTE_SWAP_INDEX, modifier.value[PaletteSwapModifier.ARRAY_INDEX])
			swap_type = SwapType.INDEX
			owner.material.set_shader_parameter(PALETTE_SWAP_USE_COLORS, false)
			owner.material.set_shader_parameter(PALETTE_SWAP_USE_INDEX, true)
		
		SwapType.COLORS:
			owner.material.set_shader_parameter(PALETTE_SWAP_COLORS, modifier.value[PaletteSwapModifier.ARRAY_INDEX])
			swap_type = SwapType.COLORS
			owner.material.set_shader_parameter(PALETTE_SWAP_USE_INDEX, false)
			owner.material.set_shader_parameter(PALETTE_SWAP_USE_COLORS, true)
		_:
			Log.default_assertion("SwapType shouldn't be uninitialized or undefined!")


func _stop():
	_reset_shader_parameters()
