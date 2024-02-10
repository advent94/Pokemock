extends InputComponent

class_name InputRelay

func _ready():
	var input: Node = get_parent()
	assert(input is InputComponent, "Relay is disconnected from input")
	assert(input.has_signal("pressed") && input.has_signal("released"), 
			"Input corrupted, make sure that proper singals are declared.")
	input.pressed.connect(on_pressed)
	input.released.connect(on_released)

func on_pressed(_button: Type):
	#match(button):
	pass

func on_released(_button: Type):
	#match(button):
	pass
