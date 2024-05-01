extends Node

var _name_to_counter: Dictionary = {}

func register(_name: String, counter: Counter = Counter.new()) -> Counter:
	_name_to_counter[_name] = counter
	if not counter is AdvancedCounter || not counter.restarts_on_limit():
		_name_to_counter[_name].finished.connect(func(): _remove(_name))
	return _name_to_counter[_name]

func get_instance(_name: String) -> Counter:
	if not exists(_name):
		register(_name, Counter.new())
	return _name_to_counter[_name]

func exists(_name: String) -> bool:
	return _name_to_counter.keys().has(_name)

func bind_to_node(_name: String, node: Node):
	if exists(_name):
		node.tree_exiting.connect(func():_remove(_name))

func _remove(_name: String):
	_name_to_counter.erase(_name)
