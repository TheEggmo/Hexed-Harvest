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

var dirt_particles = preload("res://dirt_particles.tscn")

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
	if !mature:
		return null
	spawn_dirt_particles()
	plant_removed.emit()
	queue_free()
	return self

func spawn_dirt_particles():
	var dirt_instance = dirt_particles.instantiate()
	dirt_instance.make_red() if corrupted else dirt_instance.make_white()
	dirt_instance.global_position = global_position
	get_tree().get_root().add_child(dirt_instance)

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
