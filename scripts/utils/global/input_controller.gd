extends Node

var input_controller_array: Array[Object] = []

func _input(_event):
	for controller in input_controller_array:
		controller._parse_input()

func give_control(object: Object):
	assert(object.has_method("_parse_input"), "Object doesn't have input parsing method")
	if not input_controller_array.has(object):
		input_controller_array.push_back(object)

func take_control(object: Object):
	input_controller_array.erase(object)
