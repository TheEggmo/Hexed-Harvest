extends GPUParticles2D

func _ready():
	amount = randi_range(4, 8)
	one_shot = true
	emitting = true

func make_red():
	process_material.color = Color.RED

func _on_finished():
	queue_free()
