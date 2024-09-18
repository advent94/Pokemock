extends Node

class_name TinyStarFactory

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
	name = "TinyStars"

## Creates falling stars effect for GameFreak logo intro
func create_effect():
	_validate_pair_pos_array_size()
	for row_index in range(_ROWS):
		_create_row(row_index)
		await Functions.wait(TIME_BETWEEN_CREATING_NEW_ROW)
	
	tiny_stars_created.emit()


func _validate_pair_pos_array_size():
	Log.assertion(_PAIR_X_OFFSET_INDEX.size() == (_ROWS * _PAIRS_PER_ROW), 
			"Star pairs pos array size is invalid (expected size = %d, current size = %d)"
			% [(_ROWS * _PAIRS_PER_ROW), _PAIR_X_OFFSET_INDEX.size()])	

func _create_row(row_index: int):
	for pair in range(_PAIRS_PER_ROW):
		await _create_pair(_get_star_positions(row_index, pair))


func _get_star_positions(i: int, j: int) -> Array[Vector2]:
	const SECOND_STAR_OFFSET: Vector2 = Vector2(3, -3)
	
	Log.assertion(i <= _ROWS && j <= _PAIRS_PER_ROW, "Array out of boundaries")
	var first_star_in_pair_pos: Vector2 = _get_first_star_in_pair_pos(i, j)
	var second_star_in_pair_pos: Vector2 = first_star_in_pair_pos + SECOND_STAR_OFFSET
	return [first_star_in_pair_pos, second_star_in_pair_pos]


func _get_first_star_in_pair_pos(i: int, j: int) -> Vector2:
	const FIRST_STAR_POS: Vector2 = Vector2(42, 90)
	const NEXT_PAIR_X_OFFSET: int = 4
	
	var row: int = _PAIRS_PER_ROW * i
	var first_star_in_pair_pos: Vector2 = FIRST_STAR_POS
	first_star_in_pair_pos.x += _PAIR_X_OFFSET_INDEX[row + j] * NEXT_PAIR_X_OFFSET
	return first_star_in_pair_pos


func _create_pair(current_pair_pos:Array[Vector2]):
	const REQUIRED_PAIR_POS_ARRAY_SIZE: int = 2	
	const FIRST_STAR_INDEX: int = 0
	const SECOND_STAR_INDEX: int = 1
	const SECOND_STAR_COLOR: Color = Color("#a8a8a8")

	Log.assertion(current_pair_pos.size() == REQUIRED_PAIR_POS_ARRAY_SIZE, "Wrong array size")
	
	await _create_star(current_pair_pos[FIRST_STAR_INDEX], null, true)
	await _create_star(current_pair_pos[SECOND_STAR_INDEX], SECOND_STAR_COLOR, false)


func _create_star(pos: Vector2, color = null, blinking: bool = false):
	Log.assertion(color == null || color is Color)
	
	const STAR_PROTOTYPE : PackedScene = preload(FilePaths.TINY_STAR_COMPONENT_SCENE)
	var star = STAR_PROTOTYPE.instantiate()
	
	star.initialize(color, pos, blinking)
	star.name = Functions.get_unique_name(self, "TinyStar")
	add_child.call_deferred(star)
	await star.tree_entered
	star.show()
