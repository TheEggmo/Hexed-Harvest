extends Node

signal camera_limit_changed(rect :Rect2)
signal points_changed(new_amount :int)

var points = 0:
	set(val):
		points = val
		points_changed.emit(points)

var text_scene = preload("res://TextInstance.tscn")
func spawn_floating_text(text :String, position: Vector2):
	var inst = text_scene.instantiate()
	inst.text = text
	inst.global_position = position
	add_child(inst)
