class_name CharacterExit extends PaletteSwap

const ANIMATION_TIME_STEP: float = 0.13

static func _get_update() -> Update:
	return Update.new([[  
		ANIMATION_TIME_STEP,
		ANIMATION_TIME_STEP],[
		PaletteSwapModifier.new([PaletteSwap.SwapType.INDEX, [1, 2, 3, 3]]),
		PaletteSwapModifier.new([PaletteSwap.SwapType.INDEX, [2, 3, 3, 3]])
		]])

func _init(palette: Array[Color] = []) -> void:
	super._init(_get_update(), null, palette, false, true, true)
	iterated.connect(func(): 
		await Functions.wait(ANIMATION_TIME_STEP)
		owner.hide()
		die()
	)
