extends Control

func _on_timer_timeout():
	$PlantPlots.generate_random_plants(5)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level.tscn")
