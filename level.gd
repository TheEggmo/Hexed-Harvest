extends Node2D

func _ready():
	EventBus.camera_limit_changed.emit(Rect2(Vector2.ZERO, $CamLimit.global_position))
	randomize()
	
	spawn_plant_wave()


func spawn_plant_wave():
	$PlantPlots.generate_random_plants(5)
