extends Node

func print_string_in_ASCII(string: String):
	var lines: PackedStringArray = Functions.get_lines_from_string(string)
	print("\n")
	for index in range(lines.size()):
		print("#%d : %s" % [index, _get_ASCII_array(lines[index])])
		
func _get_ASCII_array(string: String) -> Array[int]:
	var ascii_decoded_array: Array[int] = []
	for character in string:
		ascii_decoded_array.append(character.to_ascii_buffer()[0])
	return ascii_decoded_array
