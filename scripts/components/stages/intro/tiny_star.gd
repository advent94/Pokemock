extends Sprite2D

func initialize(color, initial_pos: Vector2, blinking: bool):
	position = initial_pos
	material = ShaderMaterialFactory.create("sprite")
	
	if color != null && color is Color:
		VisualEffects.add(ColorChange.new(color, false, true), self)

	const TIME_BETWEEN_BLINKS: float = Constants.MIN_TIME_BETWEEN_UPDATES
	
	if blinking:
		VisualEffects.add(Blinking.new(TIME_BETWEEN_BLINKS, true), self, null)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
