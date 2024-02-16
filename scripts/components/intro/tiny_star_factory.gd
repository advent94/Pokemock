extends Node

signal tiny_stars_created

# ROW IS USED AS NAME FOR STAR ROW, NOT FOR ARRAY INDEXING!
const _ROWS: int = 4
const _PAIRS_PER_ROW:int = 4

# There are 18 colums in which star pairs can be placed in one row, index is a
# variable in range of 18, describing how big horizontal offset is 
# (pos.x += (index * offset))
const _PAIR_X_OFFSET_INDEX: Array[int] = [
	0, 4, 10, 18,
	2, 6, 12, 16,
	1, 7, 9, 13,
	3, 11, 15, 17,
]

const TIME_BETWEEN_CREATING_NEW_ROW: float = 0.5

func _ready():
	create_effect()

## Creates falling stars effect for GameFreak logo intro
func create_effect():
	_validate_pair_pos_array_size()
	for row_index in range(_ROWS):
		_create_row(row_index)
		await Functions.wait(TIME_BETWEEN_CREATING_NEW_ROW)
	tiny_stars_created.emit()
	
func _validate_pair_pos_array_size():
	assert(_PAIR_X_OFFSET_INDEX.size() == (_ROWS * _PAIRS_PER_ROW), 
			"Star pairs pos array size is invalid (expected size = %d, current size = %d)"
			% [(_ROWS * _PAIRS_PER_ROW), _PAIR_X_OFFSET_INDEX.size()])	

func _create_row(row_index: int):
	for pair in range(_PAIRS_PER_ROW):
		var current_pair_pos: Array[Vector2] = _get_star_positions(row_index, pair)
		_create_pair(current_pair_pos)

const _FIRST_STAR_POS: Vector2 = Vector2(42, 90)
const _SECOND_STAR_OFFSET: Vector2 = Vector2(3, -3)
const _NEXT_PAIR_X_OFFSET: int = 4

func _get_star_positions(i: int, j: int) -> Array[Vector2]:
	assert(i <= _ROWS && j <= _PAIRS_PER_ROW, "Array out of boundaries")
	var first_star_in_pair_pos: Vector2 = _get_first_star_in_pair_pos(i, j)
	var second_star_in_pair_pos: Vector2 = first_star_in_pair_pos + _SECOND_STAR_OFFSET
	return [first_star_in_pair_pos, second_star_in_pair_pos]

func _get_first_star_in_pair_pos(i: int, j: int) -> Vector2:
	var row: int = _PAIRS_PER_ROW * i
	var first_star_in_pair_pos: Vector2 = _FIRST_STAR_POS
	first_star_in_pair_pos.x += _PAIR_X_OFFSET_INDEX[row + j] * _NEXT_PAIR_X_OFFSET
	return first_star_in_pair_pos

const _REQUIRED_PAIR_POS_ARRAY_SIZE: int = 2	
const _FIRST_STAR_INDEX: int = 0
const _SECOND_STAR_INDEX: int = 1
const _FIRST_STAR_COLOR: Color = Color("#606060")
const _SECOND_STAR_COLOR: Color = Color("#a8a8a8")

const BLINKING: bool = true

func _create_pair(current_pair_pos:Array[Vector2]):
	assert(current_pair_pos.size() == _REQUIRED_PAIR_POS_ARRAY_SIZE, "Wrong array size")
	_create_star(current_pair_pos[_FIRST_STAR_INDEX], _FIRST_STAR_COLOR, BLINKING)
	_create_star(current_pair_pos[_SECOND_STAR_INDEX], _SECOND_STAR_COLOR, not BLINKING)

var _star_node : PackedScene = load(FilePaths.TINY_STAR_COMPONENT_SCENE)	

func _create_star(pos: Vector2, _color: Color, blinking: bool):
	var star = _star_node.instantiate()
	_set_new_star_parameters(star, pos, _color, blinking)
	get_parent().add_child(star)
	star.show()
	
func _set_new_star_parameters(scene: Sprite2D, pos: Vector2, _color: Color, blinking: bool):
	scene.material.set_shader_parameter("color", _color)
	scene.position = pos
	scene.blinking = blinking
	scene.show()
