extends MarginContainer

func _ready():
	Global.points_changed.connect(update_points)
	update_points(Global.points)

func update_points(points):
	$Points.text = str(points)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
