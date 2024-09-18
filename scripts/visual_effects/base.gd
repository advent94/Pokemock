class_name VisualEffect
extends Process

enum Type {
	COLOR_CHANGE,
	COLOR_TRANSITION,
	BLINKING,
	PALETTE_SWAP,
}

func _init(init_method: Callable, update_args: Variant = null, permanent: bool = false, keep_final: bool = false):
	super(init_method, update_args, permanent, keep_final)

func get_type_str() -> String:
	return Functions.enum_to_str(get_type(), Type)

func get_identity() -> String:
	const VISUAL_EFFECT_IDENTITY: String = "visual effect"
	return VISUAL_EFFECT_IDENTITY

func is_valid() -> bool:
	return super.is_valid() && owner != null
