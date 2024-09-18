class_name CharacterEntrance extends PaletteSwap

const ANIMATION_TIME_STEP: float = 0.13

static func _get_update() -> Update:
	return Update.new([[
		ANIMATION_TIME_STEP, 
		ANIMATION_TIME_STEP, 
		ANIMATION_TIME_STEP, 
		ANIMATION_TIME_STEP],[
		PaletteSwapModifier.new([PaletteSwap.SwapType.INDEX, [1, 1, 1, 3]]),
		PaletteSwapModifier.new([PaletteSwap.SwapType.INDEX, [0, 0, 0, 3]]),
		PaletteSwapModifier.new([PaletteSwap.SwapType.INDEX, [0, 0, 2, 3]]),
		PaletteSwapModifier.new([PaletteSwap.SwapType.INDEX, [0, 0, 1, 3]]),
		]])

static func _get_initial_palette_swap() -> PaletteSwapModifier:
	return PaletteSwapModifier.new([PaletteSwap.SwapType.INDEX, [2, 2, 2, 3]])
	
func _init(palette: Array[Color] = []) -> void:
	super._init(_get_update(), _get_initial_palette_swap(), palette)
