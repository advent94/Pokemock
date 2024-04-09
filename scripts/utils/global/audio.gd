extends Node

## Sound effects. Class to use shorter sound effects that can have multiple instances.
## It doesn't have any specific functionality other than to play and be removed once it's finished.
class SFX:
	signal finished()
	
	static var _array: Array[SFX] = []
	static var _node: Node
	
	var _player: AudioStreamPlayer
	
	func _init(sfx: AudioStreamPlayer):
		_player = sfx
		_player.finished.connect(die)
		finished.connect(func(): remove(self))
		
	func die():
		finished.emit()

	## Plays new sound effect. Returns player object that can be used to wait for
	## finished signal for example.
	static func play(stream: AudioStream) -> AudioStreamPlayer:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		var sfx: SFX = SFX.new(player)
		
		player.stream = stream
		_node.add_child(player)
		_array.push_back(sfx)
		player.play()
		
		return player

	## Frees resources and removes object.
	static func remove(sfx: SFX):
		sfx._player.queue_free()
		_array.erase(sfx)

## Background Music instance.
class BGM:
	static var _player: AudioStreamPlayer
	static var _pause_pos: float = 0
	static var _loop: bool = false

	## Plays music.
	static func play(stream: AudioStream):
		if _player != null:
			_player.stream = stream
			_player.play()
		else:
			Log.error("BGM can't be played, AudioStreamPlayer is null!")

	## Stops music completely.
	static func stop():
		if _player.playing:
			_player.stop()
		_pause_pos = 0

	## Resumes playing music.
	static func resume():
		if not _player.playing && _player.stream:
			_player.play(_pause_pos)
			_pause_pos = 0
	
	## Pauses music.
	static func pause():
		if _player.playing:
			_pause_pos = _player.get_playback_position()
			_player.stop()

	## Restarts music.
	static func restart():
		if _player.stream:
			_player.stop()
			_player.play()
			_pause_pos = 0

	## Switches looping.
	static func loop(mode: bool):
		if not mode && _loop:
			_player.finished.disconnect(restart)
			_loop = false
		elif mode && not _loop:
			_player.finished.connect(restart)
			_loop = true


func _ready():
	_initialize()


func _initialize():
	_add_sfx_node()
	_add_bgm_node()
	
	await BGM._player.tree_entered
	
	BGM.loop(true)


func _add_sfx_node():
	SFX._node = Node.new()
	SFX._node.name = "SFX"
	add_child(SFX._node)	

func _add_bgm_node():
	BGM._player = AudioStreamPlayer.new()
	BGM._player.name = "BGM"
	add_child(BGM._player)
