extends PokemonBattleSprite

const SFX_INDEX: Dictionary = {
	"HIP": preload(FilePaths.INTRO_HIP_SFX),
	"HOP": preload(FilePaths.INTRO_HOP_SFX),
	"LUNGE": preload(FilePaths.INTRO_LUNGE_SFX),
}

const TIME_BETWEEN_IN_OUTS_IN_SEC: float = 0.2
const TIME_BEFORE_ACTION_SEC: float = 0.8
const IN_OUT_TIME_IN_SEC: float = 0.5
const IN_OUT_TIMES: int = 2

const JUMP_X_OFFSET: int = 8
const JUMP_APEX: int = 3
	
func in_and_out_first_sequence():
	for i in range(IN_OUT_TIMES):
		go_in_and_out(JUMP_X_OFFSET, IN_OUT_TIME_IN_SEC, JUMP_APEX)
		await Functions.wait_if_blocked(self)
		await Functions.wait(TIME_BETWEEN_IN_OUTS_IN_SEC)
	await Functions.wait(TIME_BEFORE_ACTION_SEC)

const BACK_OFF_APEX: int = 23
const BACK_OFF_DISTANCE: int = 23
const BACK_OFF_TIME_IN_SECONDS: float = 0.2
const RECOVERY_TIME_IN_SECONDS: float = 0.8

func back_off():
	change_frame(FrameType.ANTICIPATION)
	hip(BACK_OFF_DISTANCE, BACK_OFF_TIME_IN_SECONDS, BACK_OFF_APEX)
	await Functions.wait_if_blocked(self)
	await Functions.wait(RECOVERY_TIME_IN_SECONDS)
	
const RETALIATION_JUMP_X_OFFSET: int = -16
const RETALIATION_JUMP_APEX: int = 11

const TIME_BEFORE_WIND_UP_IN_SECONDS: float = 0.5
const TIME_BEFORE_LUNGE_IN_SECONDS: float = 0.3
const WIND_UP_OFFSET: Vector2 = Vector2(0, 2)

func retaliate():
	change_frame(FrameType.IDLE)
	go_in_and_out(RETALIATION_JUMP_X_OFFSET, IN_OUT_TIME_IN_SEC, RETALIATION_JUMP_APEX)
	await Functions.wait_if_blocked(self)
	await Functions.wait(TIME_BEFORE_ACTION_SEC)
	change_frame(FrameType.ANTICIPATION)
	move(WIND_UP_OFFSET, TIME_BEFORE_LUNGE_IN_SECONDS)
	await Functions.wait(TIME_BEFORE_WIND_UP_IN_SECONDS)
	await lunge()

const LUNGE_OFFSET: Vector2 = Vector2(-23, -6)
const TIME_BETWEEN_LUNGE_PHASES: float = 0.1
const LUNGE_SECOND_OFFSET: Vector2 = Vector2(-13, -7)
const LUNGE_THIRD_OFFSET: Vector2 = Vector2(-12, -6)

func lunge():
	change_frame(FrameType.ATTACK)
	move(LUNGE_OFFSET, Constants.NOW)	
	await Functions.wait(TIME_BETWEEN_LUNGE_PHASES)
	move(LUNGE_SECOND_OFFSET, Constants.NOW)
	await Functions.wait(TIME_BETWEEN_LUNGE_PHASES)
	move(LUNGE_THIRD_OFFSET, Constants.NOW)
	Audio.SFX.play(SFX_INDEX["LUNGE"])

func go_in_and_out(offset_x: int, time_in_sec: float, apex: int):
	hip(offset_x, time_in_sec, apex)
	hop(-offset_x, time_in_sec, apex)

func hip(offset_x: int, time_in_sec: float, apex: int):
	await _sfx_jump(offset_x, time_in_sec, apex, "HIP")

func hop(offset_x: int, time_in_sec: float, apex: int):
	await _sfx_jump(offset_x, time_in_sec, apex, "HOP")
			
func _sfx_jump(offset_x: int, time_in_sec: float, apex: int, sfx: String):
	await jump(offset_x, apex, time_in_sec)
	Audio.SFX.play(SFX_INDEX[sfx])
