extends Node2D

func _ready():
	var target = Global.get_player_position()
	## Lengthen the beam so it goes past the player
	target += global_position.direction_to(target) * 1000
	
	$TelegraphLine.clear_points()
	$TelegraphLine.add_point(Vector2.ZERO)
	$TelegraphLine.add_point(to_local(target))
	
	$AttackLine.clear_points()
	$AttackLine.add_point(Vector2.ZERO)
	$AttackLine.add_point(to_local(target))
	$AttackLine.visible = false
	
	$RayCast2D.target_position = to_local(target)
	set_physics_process(false)

func _physics_process(_delta):
	var hurtbox = $RayCast2D.get_collider()
	if hurtbox:
		hurtbox.activate()

func _on_attack_timer_timeout():
	$TelegraphLine.visible = false
	$AttackLine.visible = true
	set_physics_process(true)
	$Fadeout.start()

func _on_fadeout_timeout():
	set_physics_process(false)
	var tween = create_tween()
	tween.tween_property($AttackLine, "width", 0, 0.1)
	tween.tween_callback(queue_free)
