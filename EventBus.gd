extends Node

signal player_died
signal restart
signal camera_limit_changed(rect :Rect2)
signal points_changed(new_amount :int)

var points = 0:
	set(val):
		points = val
		points_changed.emit(points)

func _ready():
	restart.connect(cleanup)

var text_scene = preload("res://Text/TextInstance.tscn")
func spawn_floating_text(text :String, position: Vector2):
	var inst = text_scene.instantiate()
	inst.text = text
	inst.global_position = position
	add_child(inst)

func cleanup():
	for c in get_children():
		c.queue_free()

var player_pos := Vector2.ZERO ## Prevents shenanigans when player is freed
func get_player_position():
	#var player = get_tree().get_first_node_in_group("player")
	var player = get_tree().get_first_node_in_group("player_hurtbox")
	if player:
		player_pos = player.global_position
	return player_pos
