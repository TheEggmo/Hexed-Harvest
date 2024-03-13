extends CharacterBody2D

@export var move_speed = 300

@onready var held_plant = $Body/HeldPlantPivot/HeldPlant

var hold = false
var sprint = false

func _ready():
	Global.run_start_time = Time.get_ticks_msec()

func _physics_process(_delta):
	move()
	update_animation()
	
	if Input.is_action_just_pressed("interact"):
		interact()
	sprint = Input.is_action_pressed("sprint") && !hold

func move():
	var move_direction = Input.get_vector("left", "right", "up", "down")
	velocity = move_direction * move_speed * (1.5 if sprint else 1.0)
	move_and_slide()

func update_animation():
	var anim_name = ""
	anim_name += "Run" if velocity != Vector2.ZERO else "Idle"
	anim_name += "Hold" if hold else ""
	$AnimationPlayer.play(anim_name)
	
	$Body.rotation_degrees = 0
	if velocity.x != 0:
		var flip = velocity.x > 0
		$Body.flip_h = flip
		$Body/Arms.flip_h = flip
		$Body/Eyes.flip_h = flip
		
		if sprint:
			$Body.rotation_degrees = 15 if flip else -15

func interact():
	if held_plant.held_plant:
		if $DepositDetector.nearest_box:
			## Deposit plant to box
			if $DepositDetector.nearest_box.deposit_plant(held_plant.held_plant):
				held_plant.clear_plant()
				hold = false
		else:
			## Toss plants if not withing deposit box range
			toss_plant()
	else:
		## Attempt to pick up plant
		var new_plant :Plant = $PlantDetector.collect_plant()
		if new_plant:
			if new_plant.type != Plant.PlantType.WEED:
				held_plant.set_plant(new_plant)
				hold = true

func toss_plant():
	held_plant.toss_plant(velocity + Vector2(100 if $Body.flip_h else -100, 0))
	hold = false

func _on_hp_controller_hp_lost():
	if held_plant.held_plant:
		toss_plant()
	$HPController.enabled = false
	$IFrameAnimation.play("iframes")
	AudioManager.play("res://SFX/hitHurt.wav")

func _on_hp_controller_hp_depleted():
	set_physics_process(false)
	Global.run_end_time = Time.get_ticks_msec()
	Global.player_died.emit()
	## Reparent the camera so that it doesn't get deleted along with the player
	for c in get_children():
		if c is Camera2D:
			remove_child(c)
			c.global_position = global_position
			get_parent().add_child(c)
			break
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_callback(queue_free)

func _on_i_frame_animation_animation_finished(_anim_name):
	$HPController.enabled = true
