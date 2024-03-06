extends AnimatedSprite2D

var held_plant :Plant
var corrupted :bool

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
