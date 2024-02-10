extends Sprite2D

class_name MovingSprite

func move(_offset: Vector2, time_in_s: float):
	await Functions.wait_if_blocked(self)
	$Movement.move(position + _offset, time_in_s)

func jump(x_offset: int, apex: int, time_in_s: float):
	await Functions.wait_if_blocked(self)
	$Movement.jump(position.x + x_offset, time_in_s, apex)
