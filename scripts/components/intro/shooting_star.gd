extends Sprite2D

signal left_screen

const SHOOTING_STAR_SFX = preload(FilePaths.SHOOTING_STAR_SFX)

const STAR_FALLING_SPEED: int = 300

func _ready():
	hide()
	$Movement.speed = STAR_FALLING_SPEED
	const BOTTOM_LEFT: Vector2 = Vector2(-1, 1)
	$Movement.direction = BOTTOM_LEFT	
	position = _get_initial_position()
	show()
	
func _get_initial_position() -> Vector2:
	var top_right_corner_pos = Vector2(get_viewport_rect().size.x, 0)
	assert(texture != null, "%s needs to have texture initialized" % name)
	var _offset: Vector2 = Vector2(0, -(texture.get_image().get_size().y))/2
	return top_right_corner_pos + _offset

var _center_pos_reached: bool = false

func _physics_process(_delta):
	if not _center_pos_reached:
		_play_sound()
	
func _play_sound():
	if _star_reached_screen_center():
		Audio.play_sfx(SHOOTING_STAR_SFX)
		_center_pos_reached = true

func _star_reached_screen_center() -> bool:
	var screen_center_pos: Vector2 = get_viewport_rect().size/2;
	return (position.x <= screen_center_pos.x) && (position.y >= screen_center_pos.y)

func _on_visible_on_screen_notifier_2d_screen_exited():
	left_screen.emit()
	queue_free()
