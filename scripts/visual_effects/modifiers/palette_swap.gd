class_name PaletteSwapModifier extends Modifier

var value: Variant

const EXPECTED_SIZE: int = 2
const TYPE_INDEX: int = 0
const ARRAY_INDEX: int = 1

func _init(val: Variant):
	_type = VisualEffect.Type.PALETTE_SWAP
	if not _is_variant_valid(val):
		Log.error("Invalid modifier initialization. Expected Array[SwapType, Array[int/Color]]")
	
	Log.assertion(val[ARRAY_INDEX].size() <= Constants.MAX_PALETTE_SIZE, 
		"Provided array size(%d) for palette swap modifier indicates that palette size is bigger than limit (%d)" % [val.size(), Constants.MAX_PALETTE_SIZE])
	value = val

func _is_variant_valid(val: Variant) -> bool:
	return (
		val is Array and 
		val.size() == EXPECTED_SIZE and 
		val[TYPE_INDEX] is PaletteSwap.SwapType and 
		(
			(val[TYPE_INDEX] == PaletteSwap.SwapType.INDEX and 
			(
				val[ARRAY_INDEX] is Array[int] or 
				Functions.is_implicitly_typed_array(val[ARRAY_INDEX], Variant.Type.TYPE_INT)) 
			) or 
			(val[TYPE_INDEX] == PaletteSwap.SwapType.COLORS and 
			(
				val[ARRAY_INDEX] is Array[Color] or
				Functions.is_implicitly_typed_array(val[ARRAY_INDEX], Variant.Type.TYPE_COLOR))
			)
		) 
	)
