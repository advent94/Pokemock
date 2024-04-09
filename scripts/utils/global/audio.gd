extends Node

@onready var bgm: AudioStreamPlayer
@onready var sfx_node

# TODO: Fix this, ref is not necessary as argument, do callable for function call arg

class SFX:
	signal finished(ref)
	var rsc: AudioStreamPlayer
	
	func _init(sfx: AudioStreamPlayer):
		assert(sfx)
		rsc = sfx
		rsc.finished.connect(kill)
		finished.connect(Audio.remove_sfx)
	
	func kill():
		finished.emit(self)

var sfx_array: Array[SFX] = []
var loop: bool = false
var pause_pos: float = 0

func _ready():
	_initialize()

func _initialize():
	add_audio()
	loop_bgm(true)
	
func add_audio():
	sfx_node = Node.new()
	sfx_node.name = "SFX"
	add_child(sfx_node)
	bgm = AudioStreamPlayer.new()
	bgm.name = "BGM"
	add_child(bgm)
	
func play_bgm(stream: AudioStream):
	assert("." + stream.resource_path.get_extension() == FilePaths.BGM_EXT)
	assert(bgm)
	bgm.stream = stream
	bgm.play()

func stop_bgm():
	if bgm.playing:
		bgm.stop()
	pause_pos = 0

func resume_bgm():
	if not bgm.playing && bgm.stream:
		bgm.play(pause_pos)
		pause_pos = 0
		
func pause_bgm():
	if bgm.playing:
		pause_pos = bgm.get_playback_position()
		bgm.stop()

func restart_bgm():
	if bgm.stream:
		bgm.stop()
		bgm.play()
		pause_pos = 0

func play_sfx(stream: AudioStream) -> AudioStreamPlayer:
	assert("." + stream.resource_path.get_extension() == FilePaths.SFX_FILE_EXT)
	var rsc: AudioStreamPlayer = AudioStreamPlayer.new()
	rsc.stream = stream
	var sfx: SFX = SFX.new(rsc)
	sfx_node.add_child(rsc)
	sfx_array.push_back(sfx)
	rsc.play()
	return rsc

func remove_sfx(sfx: SFX):
	sfx.rsc.queue_free()
	sfx_array.erase(sfx)
		
func loop_bgm(mode: bool):
	if not mode && loop:
		bgm.finished.disconnect(restart_bgm)
	elif mode && not loop:
		bgm.finished.connect(restart_bgm)
