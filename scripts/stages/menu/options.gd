extends Node

enum OptionPanel { TEXT_SPEED, BATTLE_ANIMATION, BATTLE_STYLE, CANCEL }

const SFX_BUTTON_PRESSED = preload(FilePaths.PRESS_AB_SFX)

var options: Options
var panel_index = []
var current_panel: OptionPanel = OptionPanel.TEXT_SPEED

func _ready():
	_initialize_panel_index()
	_activate(current_panel)

func _initialize_panel_index():
	panel_index.resize(OptionPanel.size())
	panel_index[OptionPanel.TEXT_SPEED] = $TextSpeed
	panel_index[OptionPanel.BATTLE_ANIMATION] = $BattleAnimation
	panel_index[OptionPanel.BATTLE_STYLE] = $BattleStyle
	panel_index[OptionPanel.CANCEL] = $Cancel

func _invalid_panel_assertion(panel: OptionPanel):
	assert(Functions.is_between(panel, Constants.FIRST_ELEMENT_IN_INDEX, OptionPanel.size() - Constants.ZERO_INDEXING_OFFSET), 
		"Invalid panel(%d)" % panel)
		
func _activate(panel: OptionPanel):
	_invalid_panel_assertion(panel)
	var active = panel_index[panel]
	assert(active.has_method("activate"))
	active.activate()

func _deactivate(panel: OptionPanel):
	_invalid_panel_assertion(panel)
	var active = panel_index[panel]
	assert(active.has_method("deactivate"))
	active.deactivate()
	
func _load_options(_options: Options):
	options = _options
	update()

func update():
	$TextSpeed.initialize_for_option(options.text_speed)
	$BattleAnimation.initialize_for_option(options.battle_animation)
	$BattleStyle.initialize_for_option(options.battle_style)

func _update_text_speed(option : Options.TextSpeed):
	options.text_speed = option

func _update_battle_animation(option : Options.BattleAnimation):
	options.battle_animation = option

func _update_battle_style(option : Options.BattleStyle):
	options.battle_style = option

func _save_options():
	$Options.save(options)

enum Direction { UP, DOWN }
func _move(direction: Direction):
	_deactivate(current_panel)
	var new_panel: int = current_panel
	match direction:
		Direction.UP:
			new_panel -= Constants.ONE_ELEMENT
		Direction.DOWN:
			new_panel += Constants.ONE_ELEMENT
	new_panel = Functions.rclamp(new_panel, Constants.FIRST_ELEMENT_IN_INDEX, OptionPanel.size() - Constants.ZERO_INDEXING_OFFSET)
	current_panel = new_panel as OptionPanel
	_activate(current_panel)

func _return_pressed():
	await Audio.SFX.play(SFX_BUTTON_PRESSED).finished
	_return()

func _return():
	_save_options()
	queue_free()
