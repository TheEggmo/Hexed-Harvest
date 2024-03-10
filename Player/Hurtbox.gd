extends Area2D

signal attack_detected

func activate():
	attack_detected.emit()
