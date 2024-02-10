extends PokemonBattleSprite

const SFX_INDEX: Dictionary = {
	"RAISE": preload(FilePaths.INTRO_RAISE_SFX),
	"CRASH": preload(FilePaths.INTRO_CRASH_SFX),
}

const WIND_UP_OFFSET: Vector2 = Vector2(-7, 0)
const WIND_UP_TIME_IN_SECONDS: float = 0.3
const SWING_TIME_IN_SECONDS: float = 0.5

func prepare_for_attack():
	Audio.play_sfx(SFX_INDEX["RAISE"])
	change_frame(FrameType.ANTICIPATION)
	move(WIND_UP_OFFSET, WIND_UP_TIME_IN_SECONDS)
	await Functions.wait_if_blocked(self)
	await Functions.wait(SWING_TIME_IN_SECONDS)

const DASH: Vector2 = Vector2(15, 0)
const DASH_TIME_IN_SECONDS: float = 0.3
	
func attack():
	Audio.play_sfx(SFX_INDEX["CRASH"])
	change_frame(FrameType.ATTACK)
	move(DASH, DASH_TIME_IN_SECONDS)

const BACK_OFF: Vector2 = -DASH
const TIME_TO_BACK_OFF_IN_SEC: float = 0.3
const TIME_AFTER_BACK_OFF_IN_SEC: float = 0.5

func back_off():
	move(BACK_OFF, TIME_TO_BACK_OFF_IN_SEC)
	change_frame(FrameType.IDLE)
	await Functions.wait_if_blocked(self)
	await Functions.wait(TIME_AFTER_BACK_OFF_IN_SEC)
