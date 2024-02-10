extends AnimatedSprite2D

signal call_shooting_star

func _ready():
	hide()
	start()
	
func start():
	show();
	play()

enum FrameType { WHITE_SCREEN_FRAME_ID = 1, GAME_FREAK_LOGO_FRAME_ID = 2 }

func _on_frame_changed():
	match frame:
		FrameType.WHITE_SCREEN_FRAME_ID: _show_black_bars()
		FrameType.GAME_FREAK_LOGO_FRAME_ID: _spawn_shooting_star()

func _show_black_bars():
	$BottomBlackBar.show()
	$TopBlackBar.show()

func _spawn_shooting_star():
	pause()
	call_shooting_star.emit()

func _on_shooting_star_left_screen():
	_create_tiny_stars()
	play()

const TIME_BEFORE_CREATING_TINY_STARS: float = 0.7

func _create_tiny_stars():
	await Functions.wait(TIME_BEFORE_CREATING_TINY_STARS)
	$TinyStarFactory.create_effect()

func _on_tiny_stars_created():
	$TinyStarFactory.queue_free()
	$PokemonBattleTimer.start()
	
func _on_pokemon_battle_timer_timeout():
	pause()
	frame = FrameType.WHITE_SCREEN_FRAME_ID
	$PokemonBattle.play()

func _on_pokemon_battle_pokemon_battle_ended():
	$PokemonBattle.hide()
	$BottomBlackBar.hide()
	$TopBlackBar.hide()	
	$TitleScreen.initialize()
