extends Control


@export_enum("Character Name:7", "Pokemon Name:10") var field_type: int 

const EMPTY_CHARACTER: String = " "
const CHARACTER_SEPARATOR: String = "_"
const ACTIVE_INPUT: String = "|"

var max_characters: int
var added_characters_counter: int = 0

func _ready():
	initialize()

func initialize():
	max_characters = field_type
	$Name.text = String()
	$Spaces.text = String().lpad(field_type, CHARACTER_SEPARATOR)
	$Spaces.text[0] = ACTIVE_INPUT
	
func _add_character(character: String):
	if added_characters_counter < max_characters:
		$Name.text += character
		if (added_characters_counter + Constants.ONE_CHARACTER) < max_characters:
			$Spaces.text[added_characters_counter] = CHARACTER_SEPARATOR
			$Spaces.text[added_characters_counter + Constants.ONE_CHARACTER] = ACTIVE_INPUT
		added_characters_counter += Constants.ONE_CHARACTER
		
func _remove_last_character():
	if added_characters_counter >= Constants.ONE_CHARACTER:
		var last_character_index: int = added_characters_counter - Constants.ZERO_INDEXING_OFFSET
		$Name.text = $Name.text.erase(last_character_index)
		if added_characters_counter < max_characters:
			$Spaces.text[last_character_index + Constants.ONE_CHARACTER] = CHARACTER_SEPARATOR
		$Spaces.text[last_character_index] = ACTIVE_INPUT
		added_characters_counter -= Constants.ONE_CHARACTER
