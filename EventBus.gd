extends Node

signal camera_limit_changed(rect :Rect2)
signal points_changed(new_amount :int)

var points = 0:
	set(val):
		points = val
		points_changed.emit(points)
