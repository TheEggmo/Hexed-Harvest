extends Control

func _ready():
	Global.restart.emit()
	Global.points = 0

func _on_timer_timeout():
	$PlantPlots.generate_random_plants(5)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level.tscn")

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/tutorial_screen.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/credits_screen.tscn")
