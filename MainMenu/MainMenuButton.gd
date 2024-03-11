extends Button

func _ready():
	self_modulate.a = 0.5

func _on_mouse_entered():
	self_modulate.a = 1

func _on_mouse_exited():
	self_modulate.a = 0.5
