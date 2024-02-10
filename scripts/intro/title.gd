extends "res://scripts/utils/moving_sprite.gd"

const FINAL_TITLE_POSITION: Vector2 = Vector2(80, 36)
const INITIAL_TITLE_FALLING_TIME: float = 0.4
const BOUNCE_COUNT: int = 3

func bounce():
	var bounce_offset: Vector2 = Vector2(0, FINAL_TITLE_POSITION.y - position.y)
	var bounce_time = INITIAL_TITLE_FALLING_TIME
	for i in range(BOUNCE_COUNT):
		if (bounce_offset.y > 0):
			move(bounce_offset, bounce_time)
			await Functions.wait_if_blocked(self)
			bounce_offset = Vector2(bounce_offset.x, bounce_offset.y/2)
			bounce_time = bounce_time/4
			move(-bounce_offset, bounce_time)		
			await Functions.wait_if_blocked(self)
	$SFX.stream = load("res://assets/sounds/sfx/intro/SFX_INTRO_CRASH.wav")
	$SFX.play()
