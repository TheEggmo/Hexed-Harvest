extends TileMap

@export var demo_mode := false

var empty_plots = []

var plant_scene = preload("res://Plants/plant.tscn")

func _ready():
	generate_plots_list()
	
	Global.player_died.connect(set.bind("demo_mode", true))

func generate_plots_list():
	empty_plots = get_used_cells(0)

func generate_random_plants(amount := 0, type :Plant.PlantType = -1):
	var select_random_plant = func():
		var out = Plant.PlantType.WEED
		while out == Plant.PlantType.WEED:
			out = Plant.PlantType.values()[randi() % (Plant.PlantType.size())]
		return out
	for i in empty_plots.size() if amount == 0 else amount:
		if empty_plots.is_empty():
			break
		generate_plant(select_random_plant.call() if type == -1 else type)

func generate_plant(type :Plant.PlantType):
	var target_plot = empty_plots.pick_random()
	if !target_plot:
		return
	empty_plots.erase(target_plot)
	
	var plant_instance :Plant = plant_scene.instantiate()
	plant_instance.type = type
	plant_instance.position = map_to_local(target_plot)
	plant_instance.plant_removed.connect(func(): empty_plots.append(target_plot))
	if demo_mode:
		plant_instance.get_node("AttackTimer").queue_free()
	add_child(plant_instance)
