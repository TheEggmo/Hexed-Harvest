extends Node2D

func _ready():
	EventBus.camera_limit_changed.emit(Rect2(Vector2.ZERO, $Marker2D.global_position))
	#$Marker2D
