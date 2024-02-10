extends Control

@export_enum("Character Name:7", "Pokemon Name:10") var field_type: int 

const EMPTY_CHARACTER: String = " "
const CHARACTER_SEPARATOR: String = "_"
const ACTIVE_INPUT: String = "|"

var max_characters: int
var added_characters: int = 0

func _ready():
	_initialize()

func _initialize():
	max_characters = field_type
	$Name.text = String()
	$Spaces.text = String().lpad(field_type, CHARACTER_SEPARATOR)
	$Spaces.text[0] = ACTIVE_INPUT
	
func add_character(character: String):
	if added_characters < max_characters:
		$Name.text += character
		if (added_characters + Constants.ONE_CHARACTER) < max_characters:
			$Spaces.text[added_characters] = CHARACTER_SEPARATOR
			$Spaces.text[added_characters + Constants.ONE_CHARACTER] = ACTIVE_INPUT
		added_characters += Constants.ONE_CHARACTER
		
func remove_last_character():
	if added_characters >= Constants.ONE_CHARACTER:
		var last_character_index: int = added_characters - Constants.ZERO_INDEXING_OFFSET
		$Name.text = $Name.text.erase(last_character_index)
		if added_characters < max_characters:
			$Spaces.text[last_character_index + Constants.ONE_CHARACTER] = CHARACTER_SEPARATOR
		$Spaces.text[last_character_index] = ACTIVE_INPUT
		added_characters -= Constants.ONE_CHARACTER
