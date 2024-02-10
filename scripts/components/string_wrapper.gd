extends Node

@export var max_characters_per_line: int

func wrap_string(string: String) -> String:
	var line_array: PackedStringArray = Functions.get_lines_from_string(string)
	var final_line_array: PackedStringArray = []
	for line in line_array:
		if line.length() <= max_characters_per_line:
			final_line_array.push_back(line)
		else: 
			var word_array: PackedStringArray = split_to_words(line)
			var new_lines: PackedStringArray = wrap_words(word_array)
			final_line_array.append_array(new_lines)
	return Constants.NEW_LINE.join(final_line_array)

func split_to_words(string: String) -> PackedStringArray:
	var words: PackedStringArray = []
	var new_word = string[Constants.FIRST_ELEMENT_IN_INDEX]
	var starting_index: int = Constants.FIRST_ELEMENT_IN_INDEX + Constants.ONE_ELEMENT
	for i in range(starting_index, string.length()):
		if string[i] == Constants.EMPTY_SPACE:
			# Check if empty space is part of newly created word after space or last character
			if ((string[i - Constants.ONE_ELEMENT] == Constants.EMPTY_SPACE)) || (
					i == (string.length() - Constants.ZERO_INDEXING_OFFSET)):
				new_word += string[i]
			else:
				words.push_back(new_word)
				new_word = ""
				continue
		else:
			new_word += string[i]
	# Since I took approach of establishing that everything that goes after word and space is another word,
	# it also translates to continuous empty spaces in last word, this part adds these spaces to last word
	if not new_word.is_empty():
		if new_word.count(Constants.EMPTY_SPACE) == new_word.length():
			words[words.size() - Constants.ZERO_INDEXING_OFFSET] += new_word + Constants.EMPTY_SPACE
		else:
			words.push_back(new_word)
	return words

func wrap_words(words: PackedStringArray) -> PackedStringArray:
	var lines: PackedStringArray = []
	var new_line: String = ""
	for i in range(words.size()):
		var length_added = new_line.length() + Constants.EMPTY_SPACE.length() + words[i].length()
		if length_added > max_characters_per_line:
			if not new_line.is_empty():
				lines.push_back(new_line)
			if words[i].length() > max_characters_per_line:
				var complex_word_cut = split_complex_word(words[i])
				new_line = complex_word_cut[complex_word_cut.size() - Constants.ZERO_INDEXING_OFFSET]
				complex_word_cut.remove_at(complex_word_cut.size() - Constants.ZERO_INDEXING_OFFSET)
				lines.append_array(complex_word_cut)
			else:
				new_line = words[i]
		else:
			if new_line.is_empty():
				new_line = words[i]
			else:
				new_line = (new_line + Constants.EMPTY_SPACE + words[i])
	if not new_line.is_empty():
		lines.push_back(new_line)
	return lines

func split_complex_word(string: String) -> PackedStringArray:
	var lines: PackedStringArray = []
	var words_splitted: bool = false
	while not words_splitted:
		if string.length() > max_characters_per_line:
			var chars_to_substract: int = max_characters_per_line - Constants.WORD_CONTINUATION.length()
			lines.push_back(string.substr(Constants.FIRST_ELEMENT_IN_INDEX, chars_to_substract) + Constants.WORD_CONTINUATION)
			string = string.erase(Constants.FIRST_ELEMENT_IN_INDEX, chars_to_substract)
		else:
			lines.push_back(string)
			words_splitted = true
	return lines
