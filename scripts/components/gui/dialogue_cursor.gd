extends Label

@export var active: bool = false

func _ready():
	if active:
		activate()

func activate():
	show()
	$BlinkingTimer.start()

func deactivate():
	hide()
	$BlinkingTimer.stop()
	
func blink():
	if visible:
		hide()
	else:
		show()
