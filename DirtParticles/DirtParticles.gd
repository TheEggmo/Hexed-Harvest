extends GPUParticles2D

@export var amount_override = -1

func _ready():
	if amount_override > 0:
		amount = amount_override
	else:
		amount = randi_range(4, 8)
	one_shot = true
	emitting = true

func make_white():
	process_material.color = Color.WHITE

func make_red():
	process_material.color = Color.RED

func _on_finished():
	queue_free()
