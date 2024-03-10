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

func _ready():
	$Sprite/Cursor.visible = false

func _physics_process(delta):
	if randi() % 1000 == 0:
		$AnimationPlayer.play("blink")

func deposit_plant(plant :Plant):
	if !is_plant_allowed(plant):
		#EventBus.spawn_floating_text("wrong plant", global_position)
		$CursorAnimationPlayer.play("wrong_plant")
		return false
	plant.queue_free()
	var awarded_points = corrupted_points if plant.corrupted else base_points
	Global.points += awarded_points
	Global.spawn_floating_text(str(awarded_points), global_position)
	return true

func is_plant_allowed(plant :Plant):
	return allowed_plant == Plant.PlantType.WEED || allowed_plant == plant.type
