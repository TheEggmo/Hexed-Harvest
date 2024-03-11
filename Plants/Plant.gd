class_name Plant
extends Area2D

## In retrospect I should have made these as separate derieved scenes, 
## rather than forcing the different plants into one class

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

#@export var atk_speed_weed := 3.0
#@export var atk_speed_parsnip := 3.0
#@export var atk_speed_melon := 3.0
#@export var atk_speed_tomato := 3.0

var dirt_particles = preload("res://DirtParticles/dirt_particles.tscn")

func _ready():
	update_sprite()
	
	if type == PlantType.WEED:
		mature = true
	else:
		start_growth_timer()
		Global.player_died.connect(disable.bind(false))

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
	visible = false
	global_position.x = -1000
	disable()
	return self

func disable(remove := true):
	if get_parent() && remove:
		get_parent().remove_child(self)
	set_physics_process(false)
	$AttackTimer.queue_free()
	#for c in get_children():
		#if c is Timer:
			#c.stop()

func spawn_dirt_particles():
	var dirt_instance = dirt_particles.instantiate()
	dirt_instance.make_red() if corrupted else dirt_instance.make_white()
	dirt_instance.global_position = global_position
	Global.add_child(dirt_instance)

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
			if get_node_or_null("AttackTimer"):
				$AttackTimer.start()
		else:
			corruption_chance += corruption_chance_ramp

func attack():
	if !corrupted:
		return
	match type:
		PlantType.WEED:
			attack_weed()
		PlantType.PARSNIP:
			attack_parsnip()
		PlantType.MELON:
			attack_melon()
		PlantType.TOMATO:
			attack_tomato()

func attack_weed():
	pass

var parsnip_projectile_scene = preload("res://Plants/Attacks/parsnip_projectile.tscn")
func attack_parsnip():
	var atk_scene = parsnip_projectile_scene.instantiate()
	atk_scene.global_position = $ParsnipBeamOrigin.global_position
	tree_exiting.connect(atk_scene.queue_free)
	Global.add_child(atk_scene)

var melon_projectile_scene = preload("res://Plants/Attacks/melon_projectile.tscn")
func attack_melon():
	var atk_scene = melon_projectile_scene.instantiate()
	atk_scene.global_position = global_position
	tree_exiting.connect(atk_scene.queue_free)
	Global.add_child(atk_scene)

var tomato_projectile_scene = preload("res://Plants/Attacks/tomato_projectile.tscn")
func attack_tomato():
	for i in 3:
		var atk_scene = tomato_projectile_scene.instantiate()
		atk_scene.velocity = Vector2.RIGHT.rotated(randf() * TAU)
		atk_scene.global_position = global_position
		Global.add_child(atk_scene)
