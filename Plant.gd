class_name Plant
extends Area2D

enum PlantType{
	WEED,
	PARSNIP,
	MELON,
	TOMATO
}

signal plant_removed()

@onready var sprite = $AnimatedSprite2D

@export var type :PlantType
var growth_stage = 0

@export var growth_time := 10 ## Time to change into next stage
@export var growth_time_variance := Vector2(0.8, 1.2)
var mature = false

@export var corruption_chance_ramp = 0.1
@onready var corruption_chance = 0
var corrupted = false


func _ready():
	update_sprite()
	
	if type == PlantType.WEED:
		mature = true
	else:
		start_growth_timer()

func start_growth_timer():
	$GrowthTimer.start(growth_time * randf_range(growth_time_variance.x, growth_time_variance.y))

func update_sprite():
	## Weed having only 1 stage and being the first plant complicates this equation
	## But this will work dynamically if I decide to add more plants (which I will surely do)
	sprite.frame = growth_stage + (type - 1) * 3 + 1

func collect():
	plant_removed.emit()
	queue_free()
	return self

func _on_growth_timer_timeout():
	if type == PlantType.WEED:
		return
	growth_stage = 1
	mature = true
	update_sprite()

func _on_corruption_timer_timeout():
	if mature && !corrupted:
		if randf() < corruption_chance:
			corrupted = true
			growth_stage = 2
			update_sprite()
			$CorruptionTimer.stop()
		else:
			corruption_chance += corruption_chance_ramp
