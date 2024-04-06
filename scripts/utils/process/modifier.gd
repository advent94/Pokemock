extends RefCounted
class_name Modifier

var _type = Constants.NOT_FOUND:
	get = get_type

func _init(_variant: Variant = null):
	pass

func get_type_str() -> String:
	return "BASE_MODIFIER"

func get_type():
	return _type
