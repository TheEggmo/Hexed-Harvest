extends Button

func _ready():
	self_modulate.a = 0.5
	pressed.connect(_on_pressed)

func _on_mouse_entered():
	self_modulate.a = 1

func _on_mouse_exited():
	self_modulate.a = 0.5

func _on_pressed():
	AudioManager.play("res://SFX/dig2.wav")
