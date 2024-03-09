extends Node2D

@export var text = "TEXT"

func _ready():
	$Node2D/Label.text = text

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
