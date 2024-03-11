extends MarginContainer

func _ready():
	Global.points_changed.connect(update_points)
	update_points(Global.points)

func update_points(points):
	$Points.text = str(points)
