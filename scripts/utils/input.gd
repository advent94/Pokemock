extends Node

class_name InputComponent

enum Type { BUTTON_A, BUTTON_B, UP, DOWN, LEFT, RIGHT, SELECT }

const TYPE_TO_STR: Dictionary = {
	Type.BUTTON_A: "A",
	Type.BUTTON_B: "B",
	Type.UP: "up",
	Type.DOWN: "down",
	Type.LEFT: "left",
	Type.RIGHT: "right",
	Type.SELECT: "select",
}
