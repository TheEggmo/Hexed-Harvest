extends Node2D

@export var text = "TEXT"

func _ready():
	$CenterContainer/Label.text = text

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
