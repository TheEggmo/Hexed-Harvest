extends Area2D

var boxes = []
var nearest_box

@onready var shape := $CollisionShape2D

func _physics_process(delta):
	if nearest_box:
		nearest_box.highlighted = false
	_find_nearest_box()
	if nearest_box:
		nearest_box.highlighted = true

func _find_nearest_box():
	nearest_box = null
	for box in boxes:
		if !nearest_box:
			nearest_box = box
			continue
		if box.global_position.distance_squared_to(shape.global_position) < nearest_box.global_position.distance_squared_to(shape.global_position):
			nearest_box = box

#func get_nearest_box():
	#return nearest_box

func _on_area_entered(area):
	boxes.append(area)

func _on_area_exited(area):
	boxes.erase(area)
