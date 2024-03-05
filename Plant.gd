class_name Plant
extends Area2D

enum PlantType{
	WEED,
	PARSNIP,
	MELON,
	TOMATO
}

signal plant_removed()

@export var type :PlantType:
	set(val):
		type = val
		update_sprite()
var growth_stage = 0:
	set(val):
		growth_stage = val
		update_sprite()

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
	match type:
		PlantType.WEED:
			$Sprite.animation = "weed"
		PlantType.PARSNIP:
			$Sprite.animation = "parsnip"
		PlantType.MELON:
			$Sprite.animation = "melon"
		PlantType.TOMATO:
			$Sprite.animation = "tomato"
	$Sprite.frame = growth_stage

func collect():
	plant_removed.emit()
	queue_free()
	return self

func _on_growth_timer_timeout():
	if type == PlantType.WEED:
		return
	self.growth_stage = 1
	mature = true

func _on_corruption_timer_timeout():
	if mature && !corrupted:
		if randf() < corruption_chance:
			corrupted = true
			self.growth_stage = 2
			$CorruptionTimer.stop()
		else:
			corruption_chance += corruption_chance_ramp
