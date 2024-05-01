extends Test

class_name VisualEffectsTest

@warning_ignore("unassigned_variable")
var invalid_callable: Callable
	
func get_testable_visual_effects() -> Node:
	return CAPTURED_NODE(get_entity("VisualEffects").duplicate())

func get_dummy_owner() -> CanvasItem:
	return CAPTURED_NODE(Node2D.new())

func get_dummy_effect(init_method: Callable = func(): pass, update_args: Variant = null, permanent: bool = false, keep_final: bool = false) -> VisualEffect:
	return CAPTURED_NODE(VisualEffect.new(init_method, update_args, permanent, keep_final))

func get_dummy_shader_material() -> ShaderMaterial:
	return ShaderMaterial.new()
