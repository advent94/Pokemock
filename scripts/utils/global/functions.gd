extends Node

func wait(time_in_sec: float):
	await get_tree().create_timer(time_in_sec).timeout

func wait_if_blocked(moving_object):
	assert(moving_object.has_node("Movement"), "%s doesn't have movement component." % get_parent().name)
	var movement: Node = moving_object.get_node("Movement")
	while movement.is_blocking():
			await movement.blocking_movement_finished
