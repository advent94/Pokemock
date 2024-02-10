extends "res://scripts/utils/moving_sprite.gd"

const FINAL_VERSION_POSITION: Vector2 = Vector2(79, 68)
const VERSION_SLIDE_TIME: float = 0.7

func slide_in():
	var version_offset: Vector2 = Vector2(position.x - FINAL_VERSION_POSITION.x, 0)
	move(-version_offset, VERSION_SLIDE_TIME)
	await Functions.wait_if_blocked(self)
	$SFX.stream = load("res://assets/sounds/sfx/intro/SFX_INTRO_WHOOSH.wav")
	$SFX.play()
