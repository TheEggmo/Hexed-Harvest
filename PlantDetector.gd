extends Area2D

var plants = []

@onready var shape := $CollisionShape2D
@onready var cursor := $AnimatedSprite2D

func _ready():
	highlight_plant(null)
	cursor.top_level = true

func _physics_process(delta):
	var nearest_plant = find_nearest_plant()
	highlight_plant(nearest_plant)

func find_nearest_plant():
	var nearest_plant
	for plant in plants:
		if !nearest_plant:
			nearest_plant = plant
			continue
		if plant.global_position.distance_squared_to(shape.global_position) < nearest_plant.global_position.distance_squared_to(shape.global_position):
			nearest_plant = plant
	return nearest_plant

func highlight_plant(plant :Plant):
	if !plant:
		cursor.visible = false
		return
	
	cursor.visible = true
	cursor.global_position = plant.global_position
	

func _on_area_entered(area):
	plants.append(area)

func _on_area_exited(area):
	plants.erase(area)
