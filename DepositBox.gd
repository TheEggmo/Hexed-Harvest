extends Area2D

@export var base_points = 50
@export var corrupted_points = 100

@export var allow_parsnip := true
@export var allow_melon := true
@export var allow_tomato := true

var highlighted = false:
	set(val):
		highlighted = val
		$Polygon2D.color.a = 1.0 if highlighted else 0.5 #TODO change modulate to display cursor

func deposit_plant(plant :Plant):
	if !is_plant_allowed(plant):
		print("not allowed")
		return false
	plant.queue_free()
	EventBus.points += corrupted_points if plant.corrupted else base_points
	print(EventBus.points)
	return true

func is_plant_allowed(plant :Plant):
	match plant.type:
		Plant.PlantType.PARSNIP:
			return allow_parsnip
		Plant.PlantType.MELON:
			return allow_melon
		Plant.PlantType.TOMATO:
			return allow_tomato
	return true
