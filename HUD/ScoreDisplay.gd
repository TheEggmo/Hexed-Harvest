extends VBoxContainer

@export var display_delay := 0.3

func _ready():
	Global.player_died.connect(start_score_display)
	
	get_parent().self_modulate.a = 0
	for c in get_children():
		c.modulate.a = 0

#func _physics_process(delta):
	#if Input.is_action_just_pressed("interact"):
		#start_score_display()

func start_score_display():
	var time_survived = Global.get_survived_time() ## In seconds
	var score = Global.points
	var score_real = score + _time_to_score(time_survived)
	var high_score_str = str(Global.highscore) if Global.highscore > score_real else str(score_real) +"\nNEW RECORD!"
	
	var tween = create_tween()
	## Background
	tween.tween_interval(display_delay)
	tween.tween_property(get_parent(), "self_modulate", Color.WHITE, 0.0)
	## Time survived
	tween.tween_property($TimeSurvived, "modulate", Color.WHITE, 0.0)
	tween.tween_interval(display_delay)
	tween.tween_property($TimeSurvivedCount, "modulate", Color.WHITE, 0.0)
	tween.tween_property($TimeSurvivedCount, "text", _time_to_text(time_survived), 0.0)
	tween.tween_interval(display_delay)
	## Score
	tween.tween_property($Score, "modulate", Color.WHITE, 0.0)
	tween.tween_interval(display_delay)
	tween.tween_property($ScoreCount, "modulate", Color.WHITE, 0.0)
	tween.tween_property($ScoreCount, "text", str(score) + " + " + _time_to_text(time_survived), 0.0)
	tween.tween_interval(display_delay)
	tween.tween_property($ScoreCount, "text", str(score) + " + " + str(_time_to_score(time_survived)), 0.0)
	tween.tween_interval(display_delay)
	tween.tween_property($ScoreCount, "text", str(score_real), 0.0)
	tween.tween_interval(display_delay)
	## High score
	tween.tween_property($HighScore, "modulate", Color.WHITE, 0.0)
	tween.tween_interval(display_delay)
	tween.tween_property($HighScoreCount, "modulate", Color.WHITE, 0.0)
	tween.tween_property($HighScoreCount, "text", high_score_str, 0.0)
	tween.tween_interval(display_delay)
	## Main menu button
	tween.tween_property($Button, "modulate", Color8(255, 255, 255, 140), 0.0)
	
	if score_real > Global.highscore:
		Global.highscore = score_real

## Converts time in seconds to a string minute display
func _time_to_text(seconds):
	var minutes_str = str(int(seconds / 60))
	var seconds_str = str(seconds % 60)
	if seconds % 60 < 10:
		seconds_str = "0" + seconds_str
	return minutes_str + ":" + seconds_str

func _time_to_score(seconds):
	return seconds * 5
