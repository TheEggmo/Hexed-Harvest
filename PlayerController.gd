extends CharacterBody2D

@export var move_speed = 300

var hold = false

func _physics_process(delta):
	move()
	update_animation()
	
	if Input.is_action_just_pressed("interact"):
		interact()

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

func interact():
	if $HeldPlant.held_plant:
		if false:
			## Deposit plant to box
			#TODO if within deposit box
			pass
		else:
			## Toss plants if not withing deposit box range
			$HeldPlant.toss_plant(velocity + Vector2(100 if $Body.flip_h else -100, 0))
		hold = false
	else:
		## Attempt to pick up plant
		var new_plant :Plant = $PlantDetector.collect_plant()
		if new_plant:
			if new_plant.type != Plant.PlantType.WEED:
				$HeldPlant.set_plant(new_plant)
				hold = true
