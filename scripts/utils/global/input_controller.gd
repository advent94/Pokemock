extends Node

var input_controller_array: Array[Object] = []

func _input(_event):
	for controller in input_controller_array:
		controller._parse_input()

func give_control(object: Object):
	if (object.has_method("_parse_input")):
		if not input_controller_array.has(object):
			input_controller_array.push_back(object)
	else:
		Log.error("Tried to give input control to object that doesn't have parsing method(%s)" % str(object))

func take_control(object: Object):
	input_controller_array.erase(object)
