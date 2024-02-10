class_name Options

enum TextSpeed { SLOW, NORMAL, FAST }
enum BattleAnimation { ON, OFF }
enum BattleStyle { SHIFT, SET }

var text_speed: TextSpeed
var battle_animation: BattleAnimation
var battle_style: BattleStyle

func _init(_text_speed: TextSpeed = TextSpeed.NORMAL, _battle_animation: BattleAnimation = BattleAnimation.ON, 
		_battle_style: BattleStyle = BattleStyle.SHIFT):
	self.text_speed = _text_speed
	self.battle_animation = _battle_animation
	self.battle_style = _battle_style
