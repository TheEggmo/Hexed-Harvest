extends Node

var num_players = 20
var bus = "master"

var available = []  ## The available players.
var queue = []  ## The queue of sounds to play.

var sounds_dict = {}

func _ready():
	## Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus

func _on_stream_finished(stream):
	## When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_path):
	queue.append(sound_path)

func _process(delta):
	## Play a queued sound if any players are available.
	if !queue.is_empty() && !available.is_empty():
		var sound_path = queue.pop_front()
		var stream_to_play :AudioStreamPlayer
		if sounds_dict.has(sound_path):
			stream_to_play = sounds_dict[sound_path]
		else:
			stream_to_play = available.pop_front()
			stream_to_play.stream = load(sound_path)
			sounds_dict[sound_path] = stream_to_play
		
		if stream_to_play && !stream_to_play.playing:
			stream_to_play.play()
