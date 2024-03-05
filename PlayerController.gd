extends CharacterBody2D

@export var move_speed = 300

var hold = false

func _physics_process(delta):
	move()
	update_animation()

func move():
	var move_direction = Input.get_vector("left", "right", "up", "down")
	velocity = move_direction * move_speed
	move_and_slide()

func update_animation():
	var anim_name = ""
	anim_name += "Run" if velocity != Vector2.ZERO else "Idle"
	anim_name += "Hold" if hold else ""
	$AnimationPlayer.play(anim_name)
	
	if velocity.x != 0:
		var flip = velocity.x > 0
		$Body.flip_h = flip
		$Body/Arms.flip_h = flip
		$Body/Eyes.flip_h = flip
