extends TileMap

var empty_plots = []

var plant_scene = preload("res://plant.tscn")

func _ready():
	generate_plots_list()

func generate_plots_list():
	empty_plots = get_used_cells(0)

func generate_random_plants(amount := 0, type :Plant.PlantType = -1):
	var select_random_plant = func():
		return Plant.PlantType.values()[randi() % (Plant.PlantType.size() - 1)]
	for i in empty_plots.size() if amount == 0 else amount:
		generate_plant(select_random_plant.call() if type == -1 else type)
		if empty_plots.is_empty():
			break

func generate_plant(type :Plant.PlantType):
	var target_plot = empty_plots.pick_random()
	if !target_plot:
		return
	empty_plots.erase(target_plot)
	
	var plant_instance :Plant = plant_scene.instantiate()
	plant_instance.type = type
	plant_instance.position = map_to_local(target_plot)
	plant_instance.plant_removed.connect(func(): empty_plots.append(target_plot))
	add_child(plant_instance)
