extends AnimatedSprite2D

var held_plant :Plant
var corrupted :bool

var toss_plant_scene = preload("res://tossed_plant.tscn")

func _ready():
	clear_plant()

func set_plant(plant :Plant):
	if !plant:
		clear_plant()
		return
	match plant.type:
		Plant.PlantType.WEED:
			clear_plant()
			return
		Plant.PlantType.PARSNIP:
			frame = 0
		Plant.PlantType.MELON:
			frame = 2
		Plant.PlantType.TOMATO:
			frame = 4
	if plant.corrupted:
		frame += 1
	held_plant = plant
	visible = true
	corrupted = plant.corrupted

func clear_plant():
	held_plant = null
	visible = false

func toss_plant(velocity := Vector2.ZERO):
	var instance = toss_plant_scene.instantiate()
	instance.prep(velocity, frame)
	instance.global_position = global_position
	get_tree().get_root().add_child(instance)
	
	clear_plant()
