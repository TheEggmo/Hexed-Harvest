extends Node2D

@export var plants_per_wave = 3

func _ready():
	Global.camera_limit_changed.emit(Rect2(Vector2.ZERO, $CamLimit.global_position))
	randomize()
	
	spawn_plant_wave()


func spawn_plant_wave():
	$PlantPlots.generate_random_plants(plants_per_wave)
