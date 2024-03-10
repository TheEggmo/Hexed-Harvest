extends CharacterBody2D

@export var move_speed = 500

var primed = false

func _ready():
	velocity *= move_speed
	var slowdown = create_tween()
	slowdown.tween_property(self, "velocity", Vector2.ZERO, 0.2)

func _physics_process(_delta):
	move_and_slide()

func _on_timeout_timer_timeout():
	var alpha_tween = create_tween()
	alpha_tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	alpha_tween.tween_callback(queue_free)

func _on_primer_timer_timeout():
	primed = true
	var direction = global_position.direction_to(Global.get_player_position())
	var accelerate = create_tween()
	accelerate.tween_property(self, "velocity", direction * move_speed, 1.5)

func _on_hitbox_area_entered(area):
	area.activate()
	queue_free()
