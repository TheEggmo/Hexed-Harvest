extends Node2D

signal hp_lost
signal hp_depleted

@export var max_hp = 3
@onready var hp = max_hp 

@export var enabled = true

func _on_hurtbox_attack_detected():
	if !enabled:
		return
	
	hp -= 1
	if hp <= 0:
		hp_depleted.emit()
	else:
		hp_lost.emit()
