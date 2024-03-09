extends Area2D

@export var base_points = 50
@export var corrupted_points = 100

@export var allowed_plant :Plant.PlantType: ## Weed acts as any type
	set(val):
		allowed_plant = val
		$Sprite/SignParsnip.visible = allowed_plant == Plant.PlantType.PARSNIP
		$Sprite/SignMelon.visible = allowed_plant == Plant.PlantType.MELON
		$Sprite/SignTomato.visible = allowed_plant == Plant.PlantType.TOMATO

var highlighted = false:
	set(val):
		highlighted = val
		$Sprite/Cursor.visible = highlighted

func _physics_process(delta):
	if randi() % 1000 == 0:
		$AnimationPlayer.play("blink")

func deposit_plant(plant :Plant):
	if !is_plant_allowed(plant):
		print("not allowed")
		return false
	plant.queue_free()
	EventBus.points += corrupted_points if plant.corrupted else base_points
	print(EventBus.points)
	return true

func is_plant_allowed(plant :Plant):
	return allowed_plant == Plant.PlantType.WEED || allowed_plant == plant.type
