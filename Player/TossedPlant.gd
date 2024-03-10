extends CharacterBody2D

func _ready():
	var alpha_tween = create_tween()
	alpha_tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	alpha_tween.tween_callback(queue_free)

func prep(velo, frame):
	velocity = velo
	$AnimatedSprite2D.frame = frame

func _physics_process(delta):
	velocity.y += 100 * delta
	move_and_slide()
