extends Node

var debug_timer_index: Dictionary = {}
var total_times: Dictionary = {}
var one_time: bool = true
var frame_counter = 0

func _process(_delta):
	frame_counter += 1
	
class DebugTimer:
	var finished: bool = false
	var begin: int
	var end: int
	
	func _init():
		begin = Time.get_ticks_usec()

	func _stop():
		end = Time.get_ticks_usec()
		finished = true
		
	func get_elapsed() -> int:
		if not finished:
			return Time.get_ticks_usec() - begin
		return end - begin

func start_timer(_name: String):
	debug_timer_index[_name] = DebugTimer.new()

func stop_timer(_name: String):
	if debug_timer_index.keys().has(_name) && not debug_timer_index[_name].finished:
		debug_timer_index[_name]._stop()

func add_to_total_time(_group: String, _timer_name: String):
	if not total_times.has(_group):
		total_times[_group] = 0
	if debug_timer_index.keys().has(_timer_name) && debug_timer_index[_timer_name].finished :
		total_times[_group] += debug_timer_index[_timer_name].get_elapsed()

func print_times():
	print("Frames: %d" % frame_counter)
	print("[Debug Timers]:")
	for time in debug_timer_index.keys():
		print("%s: [%dusm %fms]" % [time, debug_timer_index[time].get_elapsed(), debug_timer_index[time].get_elapsed()/1000.0])
	print("[Total]:")
	for time in total_times.keys():
		print("%s: [%dusm %fms]" % [time, total_times[time], total_times[time]/1000.0])

func print_string_in_ASCII(string: String):
	var lines: PackedStringArray = Functions.get_lines_from_string(string)
	print("\n")
	for index in range(lines.size()):
		print("#%d : %s" % [index, _get_ASCII_array(lines[index])])
		
func _get_ASCII_array(string: String) -> Array[int]:
	var ascii_decoded_array: Array[int] = []
	for character in string:
		ascii_decoded_array.append(character.to_ascii_buffer()[0])
	return ascii_decoded_array
