extends CharacterBody2D

@export var move_speed = 100

@export var windup = true
var target_hurtbox
@export var fade = false 

func _physics_process(delta):
	if windup:
		velocity = global_position.direction_to(Global.get_player_position()) * move_speed
		move_and_slide()
	else:
		$AnimationPlayer.play("Chomp")
		if target_hurtbox && !fade:
			target_hurtbox.activate()

func _on_hitbox_area_entered(area):
	target_hurtbox = area

func _on_hitbox_area_exited(area):
	target_hurtbox = null

func play_audio():
	AudioManager.play("res://SFX/chomp2.wav")
