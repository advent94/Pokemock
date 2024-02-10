extends CanvasItem

signal blocking_movement_finished

enum MovementType { DIRECTIONAL, JUMP, LINEAR }

@export var speed: float = 0.0
@export var direction: Vector2 = Vector2(0, 0)
var _movement_type: MovementType = MovementType.DIRECTIONAL
var _init_pos: Vector2 = Vector2(0, 0)
var _target_pos: Vector2 = Vector2(0, 0)
var _real_pos: Vector2 = Vector2(0, 0)

func _physics_process(delta):
	_update_position(delta)

func _update_position(delta: float):
	match _movement_type:
		MovementType.DIRECTIONAL:
			_update_directional(delta)
		MovementType.LINEAR:
			_update_linear(delta)
		MovementType.JUMP:
			_update_jump(delta)

func _update_directional(delta):
	if not direction:
		return
	direction = direction.normalized()
	var distance = speed * delta
	var velocity = distance * direction
	get_parent().position += velocity

func _update_linear(delta):
	var distance = (speed * delta)
	var velocity = distance * direction
	if _target_was_reached(velocity):
		_stop_linear()
		return
	_real_pos += velocity
	get_parent().position = (_real_pos + Vector2(0.5, 0.5)).floor()

func _target_was_reached(velocity: Vector2) -> bool:
	var new_pos: Vector2 = _real_pos + velocity
	var distance_from_new_pos: Vector2 = _target_pos - new_pos
	var new_direction: Vector2 = distance_from_new_pos.normalized()
	if new_direction.dot(velocity.normalized()) >= 0:
		return false
	return (_target_pos - new_pos).length() >= (_target_pos - _real_pos).length()

func _stop_linear():
	get_parent().position = _target_pos
	set_default_parameters()
	blocking_movement_finished.emit()

func set_default_parameters():
	_movement_type = MovementType.DIRECTIONAL
	direction = Vector2(0, 0)
	speed = _original_speed
	_original_speed = 0
	_init_pos = Vector2(0, 0)
	_real_pos = _init_pos
	_target_pos = Vector2(0, 0)

func move(new_pos: Vector2, time_in_seconds):
	if not time_in_seconds:
		get_parent().position = new_pos
		return
	_movement_type = MovementType.LINEAR
	direction = get_parent().position.direction_to(new_pos)
	_init_pos = get_parent().position
	_real_pos = _init_pos
	_target_pos = new_pos
	_original_speed = speed
	speed = Vector2(new_pos - _init_pos).length() / time_in_seconds

var _descending: bool = false
var _original_speed = speed
var _apex: int = 0
var _acceleration: float = 0.0 
	
func _update_jump(delta):
	var velocity: Vector2 = _calculate_jump_velocity(delta)
	_update_position_for_jump(velocity)
	if not _descending:	
		if _was__apex_achieved():
			_start_descending()
	elif _target_was_reached(velocity):
		_end_jump()

func _calculate_jump_velocity(delta) -> Vector2:
	var horizontal_velocity : float = speed * delta
	var vertical_velocity : float = _acceleration * delta
	var velocity = Vector2(horizontal_velocity, -vertical_velocity)
	return velocity
	
func _update_position_for_jump(velocity: Vector2):
	_real_pos += velocity
	get_parent().position = (_real_pos + Vector2(0.5, 0.5)).floor()
	
func _was__apex_achieved() -> bool:
	return absf(get_parent().position.y - _init_pos.y) >= _apex 
	
func _start_descending():
	_descending = true
	_acceleration = -_acceleration
	
func _end_jump():
	get_parent().position = _target_pos
	set_default_parameters()
	_descending = false
	_acceleration = 0
	_apex = 0
	blocking_movement_finished.emit()
		
func jump(pos_x: int, time_in_seconds: float, jump_apex: int):
	if not time_in_seconds:
		get_parent().position.x = pos_x
		return
	_movement_type = MovementType.JUMP
	_apex = jump_apex
	var total_distance: float = pos_x - get_parent().position.x
	_original_speed = speed
	speed = total_distance / time_in_seconds
	_acceleration = _apex / (time_in_seconds/2)
	_target_pos = Vector2(pos_x, get_parent().position.y)
	_init_pos = get_parent().position
	_real_pos = _init_pos

func is_blocking() -> bool:
	return _movement_type != MovementType.DIRECTIONAL
