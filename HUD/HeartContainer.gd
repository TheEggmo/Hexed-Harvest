extends HBoxContainer

func _ready():
	Global.player_hp_changed.connect(adjust_hearts)

func adjust_hearts(hp):
	var hearts_to_display = hp
	for c in get_children():
		if hearts_to_display > 0:
			c.visible = true
			hearts_to_display -= 1
		else:
			c.visible = false
