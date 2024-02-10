extends InputComponent

signal pressed(button)
signal released(button)

@export var active: bool = true
@export var register_pressed: Array[Type] = [ Type.BUTTON_A, Type.BUTTON_B, Type.UP,
		Type.DOWN, Type.LEFT, Type.RIGHT, Type.SELECT ]
@export var register_released: Array[Type] = [ Type.BUTTON_A, Type.BUTTON_B, Type.UP,
		Type.DOWN, Type.LEFT, Type.RIGHT, Type.SELECT ]

func _ready():
	if active:
		$InputRegister.activate()

func activate():
	$InputRegister.activate()

func deactivate():
	$InputRegister.deactivate()

func _parse_input():
	_parse_pressed()
	_parse_released()

func _parse_pressed():
	for i in register_pressed:
		if Input.is_action_just_pressed(TYPE_TO_STR[i]):
			pressed.emit(i)
		
func _parse_released():
	for i in register_released:
		if Input.is_action_just_released(TYPE_TO_STR[i]):
			released.emit(i)
