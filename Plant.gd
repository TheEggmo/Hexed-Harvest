class_name Plant
extends Area2D

enum PlantType{
	WEED,
	PARSNIP,
	MELON,
	TOMATO
}

@onready var sprite = $AnimatedSprite2D

@export var type :PlantType
@export var growth_stage = 0

func _ready():
	update_sprite()

func update_sprite():
	#var frame
	#match type:
		#PlantType.WEED:
			#frame = 0
		#PlantType.PARSNIP:
			#frame = 1
		#PlantType.MELON:
			#frame = 4
		#PlantType.TOMATO:
			#frame = 7
	## Weed having only 1 stage and being the first plant complicates this equation
	## But this will work dynamically if I decide to add more plants (which I will surely do)
	sprite.frame = growth_stage + (type - 1) * 3 + 1
