extends Camera2D

func _ready():
	EventBus.camera_limit_changed.connect(_update_camera_limit)

func _update_camera_limit(rect :Rect2):
	limit_left = rect.position.x
	limit_top = rect.position.y
	limit_right = rect.size.x
	limit_bottom = rect.size.y
