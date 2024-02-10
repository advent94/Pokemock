extends Node

func throw_default_assertion(string : String):
	@warning_ignore("assert_always_true")
	assert(true, string)
