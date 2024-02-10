extends Control

signal name_inserted(string: String)

const CHARACTER_NAME_LABEL = "YOUR NAME?"
@export var label: String = CHARACTER_NAME_LABEL

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label
	$CharacterInput.initialize()
