extends Node

func activate():
	InputController.give_control(get_parent())

func deactivate():
	InputController.take_control(get_parent())
	
func _exit_tree():
	deactivate()
